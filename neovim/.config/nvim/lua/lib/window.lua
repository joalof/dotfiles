require("table.new")
local api = vim.api


local function is_instance(object, class)
    if type(object) == "table" then
        if class == "table" then
            return true
        else
            local mt = getmetatable(object)
            if mt then
                return mt == class
            end
        end
    elseif type(object) == class then
        return true
    end
    return false
end


local Window = setmetatable({}, {})

local Window_getters = {
    buffer = function(win)
        local Buffer = require("lib.vim.buffer")
        return Buffer:new(api.nvim_win_get_buf(win.id), false)
    end,
    config = function(win)
        return api.nvim_win_get_config(win.id)
    end,
    number = function(win)
        return api.nvim_win_get_number(win.id)
    end,
    position = function(win)
        return api.nvim_win_get_position(win.id)
    end,
    tabpage = function(win)
        local Tabpage = require("lib.vim.tabpage")
        return Tabpage:from_id(api.nvim_win_get_tabpage(win.id))
    end,
    width = function(win)
        return api.nvim_win_get_width(win.id)
    end,
    height = function(win)
        return api.nvim_win_get_height(win.id)
    end,
    valid = function(win)
        return api.nvim_win_is_valid(win.id)
    end,
    float = function(win)
        return vim.api.nvim_win_get_config(win.id).relative ~= ""
    end,
    cursor = function(win)
        local Cursor = require("lib.vim.cursor")
        return Cursor:new(win.id, false)
    end,
}

local Window_setters = {
    buffer = function(win, val)
        local Buffer = require("lib.vim.buffer")
        if is_instance(val, Buffer) then
            val = val.id
        end
        api.nvim_win_set_buf(win.id, val)
    end,
    config = function(win, val)
        api.nvim_win_set_config(win.id, val)
    end,
    width = function(win, val)
        api.nvim_win_set_width(win.id, val)
    end,
    height = function(win, val)
        api.nvim_win_set_height(win.id, val)
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
function Window:new(id, verify)
    if id == 0 then
        id = api.nvim_get_current_win()
    else
        verify = verify or true
        if verify then
            if not api.nvim_win_is_valid(id) then
                error(string.format("Window with id %d is not valid", id))
            end
        end
    end
    local win = {
        id = id,
    }
    setmetatable(win, Window)
    return win
end

-- Opens a new window on given buffer
function Window:open(buffer, enter, config)
    local Buffer = require("lib.vim.buffer")
    enter = enter or true
    config = config or {}
    if is_instance(buffer, Buffer) then
        buffer = buffer.id
    end
    local id = api.nvim_open_win(buffer, enter, config)
    return Window:new(id, false)
end

function Window:open_float(buffer, enter, config) end

function Window:split(buffer, enter, config) end

local Window_mt = getmetatable(Window)
function Window_mt.__call(_, ...)
    local args = { ... }
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
    api.nvim_win_close(self.id, force)
    self = nil
end

function Window:hide()
    api.nvim_win_hide(self.id)
    self = nil
end

function Window:focus() end

function Window:get_cursor()
    return api.nvim_win_get_cursor(self.id)
end

function Window:set_cursor(pos)
    return api.nvim_win_set_cursor(self.id, pos)
end

function Window:set_var(name, value)
    api.nvim_win_set_var(self.id, name, value)
end

function Window:get_var(name)
    return api.nvim_win_get_var(self.id, name)
end

function Window:del_var(name)
    api.nvim_win_del_var(self.id, name)
end

function Window:call(fun)
    local res = api.nvim_win_call(self.id, fun)
    return res
end

function Window:text_height(opts)
    local info = api.nvim_win_text_height(self.id, opts)
    return info
end

function Window:set_current()
    api.nvim_set_current_win(self.id)
end

--- Lists all buffers
--- @return table List of all Windows
local function list_windows()
    local ids = api.nvim_list_bufs()
    local windows = table.new(#ids, 0)
    for i, hand in ipairs(ids) do
        windows[i] = Window:new(hand, false)
    end
    return windows
end

return {Window = Window, list_windows = list_windows}
