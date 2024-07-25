local api = vim.api
local Vector = require('lib.collections.vector').Vector

local Cursor = setmetatable({}, {})

local M = { Cursor = Cursor }

Cursor.__index = Cursor

function Cursor:new(win_handle)
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
    opts = vim.tbl_extend('keep', opts, defaults)
    local flags = 'cW'
    if not opts.forward then
        flags = flags .. 'b'
    end
    local res = vim.fn.search(pattern, flags)
    return res == 0
end

return M
