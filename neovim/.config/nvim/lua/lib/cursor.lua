local api = vim.api

--- @class Cursor
--- @field pos number [integer, integer]
--- @field window_id integer
local Cursor = setmetatable({}, {})

local Cursor_getters = {
    pos = function(cursor)
        return api.nvim_win_get_cursor(cursor.window_id)
    end,
}

local Cursor_setters = {
    pos = function(cursor, pos)
        api.nvim_win_set_cursor(cursor.window_id, pos)
    end,
}

Cursor.__index = function(tbl, key)
    local raw = rawget(Cursor, key)
    if raw then
        return raw
    end
    local getter = Cursor_getters[key]
    if getter then
        return getter(tbl)
    end
end

Cursor.__newindex = function(tbl, key, value)
    local setter = Cursor_setters[key]
    if setter then
        setter(tbl, value)
    else
        rawset(tbl, key, value)
    end
end

function Cursor:new(win_id, verify)
    if win_id == 0 then
        win_id = api.nvim_get_current_win()
    else
        verify = verify or true
        if verify then
            if api.nvim_win_is_valid(win_id) then
                error(string.format("Window with id %d is not valid", win_id))
            end
        end
    end
    local cursor = {
        window_id = win_id,
    }
    setmetatable(cursor, Cursor)
    return cursor
end

function Cursor:get()
    local pos = api.nvim_win_get_cursor(self.window_id)
    return pos
end

--- @param pos [integer, integer] (row, col) tuple representing the new position
function Cursor:set(pos)
    api.nvim_win_set_cursor(self.window_id, pos)
end

function Cursor:rebound(fun, ...)
    local pos = self:get()
    fun(...)
    self:set(pos)
end

function Cursor:search(pattern, opts)
    opts = opts or {}
    local defaults = {
        forward = true,
    }
    opts = vim.tbl_extend("keep", opts, defaults)
    local flags = "cW"
    if not opts.forward then
        flags = flags .. "b"
    end
    local res = vim.fn.search(pattern, flags)
    return res == 0
end

return { Cursor = Cursor }
