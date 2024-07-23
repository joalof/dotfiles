local api = vim.api

local Window = setmetatable({}, {})

local M = { Window = Window }

local property_getters = {
    buffer = function() end,
    config = function() end,
    number = function() end,
    position = function() end,
    tabpage = function() end,
    width = function() end,
    height = function() end,
    cursor = function() end,
    valid = function() end,
}

local property_setters = {
    buffer = function() end,
    config = function() end,
    width = function() end,
    height = function() end,
    cursor = function() end,
    hl_ns = function() end,
}

Window.__index = function(tbl, key)
    local raw = rawget(Window, key)
    if raw then
        return raw
    end

    local getter = property_getters[key]
    if getter then
        return getter(tbl)
    end
end

Window.__indexnew = function(tbl, key, value)
    local setter = property_setters[key]
    if setter then
        setter(tbl, value)
    else
        rawset(tbl, key, value)
    end
end

-- creates a Win object with given handle that
-- is not guaranteed to correspond to any actual win
function Window:_new(handle)
    local win = {
        handle = handle,
    }
    setmetatable(win, Window)
    return win
end

-- gets an existing Window from it's handle
function Window:from_handle(handle)
    if handle == 0 then
        return Window:_new(api.nvim_get_current_win())
    end
    local existing_handles = api.nvim_list_wins()
    for _, hand in ipairs(existing_handles) do
        if hand == handle then
            return Window:_new(handle)
        end
    end
end

-- Opens a new window on given buffer
function Window:open(buffer, enter, config)
    enter = enter or true
    config = config or {}
    local handle = api.nvim_open_win(buffer, enter, config)
    return Window:_new(handle)
end

function Window:close()
end

local mt = getmetatable(Window)
function mt.__call(_, ...)
    if #arg == 0 then
        arg = { 0, n = 1 }
    end
    if arg["n"] == 1 then
        if type(arg[1]) == "number" then
            return Window:from_handle(arg[1])
        end
    end
end

function M.set_current(win) end

function M.list(opts)
    opts = opts or {}
    local wins = {}
    local handles = api.nvim_list_bufs()
    for i, handle in ipairs(handles) do
        local win = Window:_new(handle)
        wins[i] = win
    end
    return wins
end

return M
