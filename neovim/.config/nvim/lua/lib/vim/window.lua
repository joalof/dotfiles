local api = vim.api
local oop = require("lib.oop")

local Window = setmetatable({}, {})

local M = { Window = Window }

local property_getters = {
    buffer = function(win)
        local Buffer = require("lib.vim.buffer").Buffer
        return Buffer(api.nvim_win_get_buf(win.handle))
    end,
    config = function(win)
        return api.nvim_win_get_config(win.handle)
    end,
    number = function(win)
        return api.nvim_win_get_number(win.handle)
    end,
    position = function(win)
        return api.nvim_win_get_position(win.handle)
    end,
    tabpage = function(win)
        return api.nvim_win_get_tabpage(win.handle)
    end,
    width = function(win)
        return api.nvim_win_get_width(win.handle)
    end,
    height = function(win)
        return api.nvim_win_get_height(win.handle)
    end,
    valid = function(win)
        return api.nvim_win_is_valid(win.handle)
    end,
    float = function(win)
        return vim.api.nvim_win_get_config(win.handle).relative ~= ""
    end,
}

local property_setters = {
    buffer = function(win, val)
        local Buffer = require("lib.vim.buffer").Buffer
        if oop.is_instance(val, Buffer) then
            val = val.handle
        end
        api.nvim_win_set_buf(win.handle, val)
    end,
    config = function(win, val)
        api.nvim_win_set_config(win.handle, val)
    end,
    width = function(win, val)
        api.nvim_win_set_width(win.handle, val)
    end,
    height = function(win, val)
        api.nvim_win_set_height(win.handle, val)
    end,
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

Window.__newindex = function(tbl, key, value)
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
    local Buffer = require("lib.vim.buffer").Buffer
    enter = enter or true
    config = config or {}
    if oop.is_instance(buffer, Buffer) then
        buffer = buffer.handle
    end
    local handle = api.nvim_open_win(buffer, enter, config)
    return Window:_new(handle)
end

function Window:open_float(buffer, enter, config)
end

function Window:split(buffer, enter, config)
end

local mt = getmetatable(Window)
function mt.__call(_, ...)
    if #args == 0 then
        args = { 0, n = 1 }
    end
    if args["n"] == 1 then
        if type(args[1]) == "number" then
            return Window:from_handle(args[1])
        end
    end
end

function Window:close(force)
    force = force or false
    api.nvim_win_close(self.handle, force)
    self = nil
end

function Window:hide()
    api.nvim_win_hide(self.handle)
    self = nil
end

function Window:focus()
    M.set_current(self)
end

function Window:get_cursor()
    local Cursor = require('lib.vim.cursor').Cursor
    return Cursor(self.handle)
end

function Window:set_var(name, value)
    api.nvim_win_set_var(self.handle, name, value)
end

function Window:get_var(name)
    api.nvim_win_get_var(self.handle, name)
end

function Window:del_var(name)
    api.nvim_win_del_var(self.handle, name)
end

function Window:call(fun)
    local res = api.nvim_win_call(self.handle, fun)
    return res
end

function Window:text_height(opts)
    local info = api.nvim_win_text_height(self.handle, opts)
    return info
end

--
-- Module level functions
--
function M.set_current(win)
    if oop.is_instance(win, Window) then
        win = win.handle
    end
    api.nvim_set_current_win(win)
end

function M.list()
    local wins = {}
    local handles = api.nvim_list_wins()
    for i, handle in ipairs(handles) do
        local win = Window:_new(handle)
        wins[i] = win
    end
    return wins
end

function M.find(opts)
    opts = opts or {}
    local wins = {}
    local handles = api.nvim_list_wins()
    for i, handle in ipairs(handles) do
        local win = Window:_new(handle)
        wins[i] = win
    end
    return wins
end

return M
