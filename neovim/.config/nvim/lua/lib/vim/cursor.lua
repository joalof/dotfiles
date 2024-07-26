local api = vim.api
local Vector = require("lib.collections.vector").Vector

local Cursor = setmetatable({}, {})

local M = { Cursor = Cursor }

local Cursor_getters = {
    position = function(cursor)
        return Vector(api.nvim_win_get_cursor(cursor.window_handle))
    end,
}

local Cursor_setters = {
    position = function(cursor, pos)
        api.nvim_win_set_cursor(cursor.window_handle, pos)
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

function Cursor:new(win_handle, verify)
    if win_handle == 0 then
        win_handle = api.nvim_get_current_win()
    else
        verify = verify or true
        if verify then
            if api.nvim_win_is_valid(win_handle) then
                error(string.format('Window with handle %d is not valid', win_handle))
            end
        end
    end
    local cursor = {
        window_handle = win_handle,
    }
    setmetatable(cursor, Cursor)
    return cursor
end

function Cursor:get()
    local pos = api.nvim_win_get_cursor(self.window_handle)
    return Vector(pos)
end

function Cursor:set(pos)
    api.nvim_win_set_cursor(self.window_handle, pos)
end

function Cursor:translate(vec)
    local pos_new = self.position + vec
    self.position = pos_new
    return pos_new
end

function Cursor:with_anchor(fun, ...)
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

return M
