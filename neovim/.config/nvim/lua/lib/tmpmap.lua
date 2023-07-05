local Deque = require('lib/deque')

-- all options allowed by keymap.set (minus buffer) = vim map-arguments + noremap
local MAP_OPTS = {'noremap', 'nowait', 'silent', 'script', 'unique', 'expr', 'cmd'}

-- all available mode short names
local MODES = {'n', 'i', 'c', 'v', 'x', 's', 'o', 't', 'l'}

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


local tmpmap = {}

tmpmap._deques = {}
for _, mode in ipairs(MODES) do
    tmpmap._deques[mode] = {}
end

function tmpmap.set(modes, lhs, rhs, opts)

    if type(modes) == 'string' then
        modes = {modes}
    end

    for _, mode in ipairs(modes) do
        -- initialize a deque at mode, lhs if there is none
        if tmpmap._deques[mode][lhs] == nil then
            tmpmap._deques[mode][lhs] = Deque:new()
        end
        local deque = tmpmap._deques[mode][lhs]

        -- look for existing mapping for mode, lhs and push if found
        local maps_all = vim.api.nvim_get_keymap(mode)
        local map_curr = to_shortform(find_map(maps_all, lhs))
        if map_curr ~= nil then
            deque:push_left(map_curr)
        end

        -- push the new mapping
        local map_new = {['lhs'] = lhs, ['rhs'] = rhs, ['opts'] = opts}
        deque:push_left(map_new)

        vim.keymap.set(mode, lhs, rhs, opts)
    end
end

function tmpmap.del(modes, lhs)
    if type(modes) == 'string' then
        modes = {modes}
    end

    for _, mode in ipairs(modes) do
        local deque = tmpmap._deques[mode][lhs]
        assert(deque ~= nil)

        -- delete current active mapping
        deque:pop_left()
        -- local map_curr = tmpmap._deques[mode][lhs].pop_left()
        -- vim.keymap.del(mode, map_curr.lhs)

        -- activate old mapping
        local map_old = deque:peek_left()
        vim.keymap.set(map_old.mode, map_old.lhs, map_old.rhs, map_old.opts)
    end
end

return tmpmap
