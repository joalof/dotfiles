require("table.new")
local api = vim.api
local oop = require("lib.oop")

local Window = setmetatable({}, {})

local Window_getters = {
    buffer = function(win)
        local Buffer = require("lib.vim.buffer")
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
        local Tabpage = require("lib.vim.tabpage")
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
        local Cursor = require("lib.vim.cursor")
        return Cursor:new(win.handle, false)
    end,
}

local Window_setters = {
    buffer = function(win, val)
        local Buffer = require("lib.vim.buffer")
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
                error(string.format("Window with handle %d is not valid", handle))
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
    local Buffer = require("lib.vim.buffer")
    enter = enter or true
    config = config or {}
    if oop.is_instance(buffer, Buffer) then
        buffer = buffer.handle
    end
    local handle = api.nvim_open_win(buffer, enter, config)
    return Window:new(handle, false)
end

function Window:open_float(buffer, enter, config) end

function Window:split(buffer, enter, config) end

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

function Window:focus() end

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
    return api.nvim_win_get_var(self.handle, name)
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

function Window:set_current()
    api.nvim_set_current_win(self.handle)
end

--- Lists all buffers
--- @return ObjectList List of all Windows
function Window.list_all()
    local ObjectList = require("lib.vim.object_list")
    local handles = api.nvim_list_bufs()
    local objs = table.new(#handles, 0)
    for i, hand in ipairs(handles) do
        objs[i] = Window:new(hand, false)
    end
    return ObjectList(objs)
end

return Window
