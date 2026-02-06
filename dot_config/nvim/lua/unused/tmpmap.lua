local Deque = require("lib.collections.deque")

-- all options allowed by keymap.set (minus buffer) = vim map-arguments + noremap
local MAP_OPTS = { "noremap", "nowait", "silent", "script", "unique", "expr", "cmd" }

-- all available mode short names
local MODES = { "n", "i", "c", "v", "x", "s", "o", "t", "l" }

-- Converts long form vim mapping definition tables return by
-- nvim_get_keymap to short form table compatible with keymap.set.
-- format: {mode = ..., lhs = ..., rhs = ..., opts = ...}
local function to_shortform(map)
    local shortform = {}
    shortform.mode = map.mode
    shortform.lhs = map.lhs

    if map.rhs == nil then
        shortform.rhs = map.callback
    else
        shortform.rhs = map.rhs
    end

    shortform.opts = {}
    for _, opt in ipairs(MAP_OPTS) do
        shortform.opts[opt] = map[opt]
    end
    return shortform
end

-- Finds map with a given lhs from a list of maps in long or short form.
local function find_map(maps, lhs)
    for _, map in ipairs(maps) do
        if map.lhs == lhs then
            return map
        end
    end
    return nil
end

local deques = {}
for _, mode in ipairs(MODES) do
    deques[mode] = {}
end

local tmpmap = {}
function tmpmap.set(modes, lhs, rhs, opts)
    if type(modes) == "string" then
        modes = { modes }
    end

    local dq = nil

    for _, mode in ipairs(modes) do

        -- initialize a deque at (mode, lhs) if there is none
        if deques[mode][lhs] == nil then
            dq = Deque:new()
            deques[mode][lhs] = dq
        else
            dq = deques[mode][lhs]
        end
        -- add current mapping at (mode, lhs) to deque
        local map = vim.fn.maparg(lhs, mode, nil, true)
        if not vim.tbl_isempty(map) then
            local map_short = to_shortform(map)
            dq:push_left(map_short)
        end

    end
    vim.keymap.set(modes, lhs, rhs, opts)
end


function tmpmap.del(modes, lhs, opts)

    if type(modes) == "string" then
        modes = { modes }
    end

    for _, mode in ipairs(modes) do
        vim.keymap.del(modes, lhs, opts)
        local dq = deques[mode][lhs]
        if dq ~= nil and dq:length() > 0 then
            local map_old = dq:pop_left()
            -- TODO expr causes issues?
            map_old.opts.expr = nil
            vim.keymap.set(map_old.mode, map_old.lhs, map_old.rhs, map_old.opts)
        end
    end
end

return tmpmap
