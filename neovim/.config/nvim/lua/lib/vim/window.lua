require('table.new')
local api = vim.api
local oop = require("lib.oop")

local Window = setmetatable({}, {})

local M = { Window = Window }

local Window_getters = {
    buffer = function(win)
        local Buffer = require("lib.vim.buffer").Buffer
        return Buffer:new(api.nvim_win_get_buf(win.handle), false)
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
        local Tabpage = require("lib.vim.tabpage").Tabpage
        return Tabpage:from_handle(api.nvim_win_get_tabpage(win.handle))
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
    cursor = function(win)
        local Cursor = require('lib.vim.cursor').Cursor
        return Cursor:new(win.handle, false)
    end,
}

local Window_setters = {
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

    local getter = Window_getters[key]
    if getter then
        return getter(tbl)
    end
end

Window.__newindex = function(tbl, key, value)
    local setter = Window_setters[key]
    if setter then
        setter(tbl, value)
    else
        rawset(tbl, key, value)
    end
end

-- creates a Win object
function Window:new(handle, verify)
    if handle == 0 then
        handle = api.nvim_get_current_win()
    else
        verify = verify or true
        if verify then
            if not api.nvim_win_is_valid(handle) then
                error(string.format('Window with handle %d is not valid', handle))
            end
        end
    end
    local win = {
        handle = handle,
    }
    setmetatable(win, Window)
    return win
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
    return Window:new(handle, false)
end

function Window:open_float(buffer, enter, config)
end

function Window:split(buffer, enter, config)
end

local Window_mt = getmetatable(Window)
function Window_mt.__call(_, ...)
    if #args == 0 then
        args = { 0, n = 1 }
    end
    if args["n"] == 1 then
        if type(args[1]) == "number" then
            return Window:new(args[1])
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
end

function Window:get_cursor()
    return api.nvim_win_get_cursor(self.handle)
end

function Window:set_cursor(pos)
    return api.nvim_win_set_cursor(self.handle, pos)
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
-- WindowList class
--
local WindowList = setmetatable({}, {})

M.WindowList = WindowList

local WindowList_getters = {
    handles = function(buf_list)
        local handles = table.new(#buf_list, 0)
        for i, buf in buf_list do
            handles[i] = buf.handle
        end
        return handles
    end,
}

WindowList.__index = function(tbl, key)
    if type(key) == "number" then
        return tbl[key]
    end
    local getter = WindowList_getters[key]
    if getter then
        return getter(tbl)
    end
    local raw = rawget(WindowList, key)
    if raw then
        return raw
    end
end


-- creates a BufferList object with given handles that
-- are not guaranteed to correspond to actual valid buffers
function WindowList:new(handles, verify)
    verify = verify or true
    local win_list = table.new(#handles, 0)
    for i, hand in ipairs(handles) do
        win_list[i] = Window:new(hand, verify)
    end
    setmetatable(win_list, WindowList)
    return win_list
end

local WindowList_mt = getmetatable(WindowList)
function WindowList_mt.__call(_, ...)
    args = {...}
    if #args == 1 and type(args[1]) == "table" then
        if type(args[1][1]) == 'number' then
            return WindowList:new(args[1])
        elseif oop.is_instance(args[1][1], Window) then
            local wins = args[1]
            setmetatable(wins, WindowList)
            return wins
        end
    end
    error('No constructor for given arguments.')
end

function WindowList:get_property(property)
    local res = table.new(#self.handles, 0)
    for i, win in ipairs(self) do
        res[i] = win[property]
    end
    return res
end

function WindowList:filter(fun)
    local wins = {}
    for i, win in ipairs(self) do
        if fun(win) then
            wins[i] = win
        end
    end
    setmetatable(wins, WindowList)
    return wins
end

function WindowList:filter_by(property, value)
    local wins = {}
    for i, win in ipairs(self) do
        if win[property] == value then
            wins[i] = win
        end
    end
    setmetatable(wins, WindowList)
    return wins
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
    local handles = api.nvim_list_wins()
    return WindowList:new(handles, false)
end

return M
