local api = vim.api
local oop = require("lib.oop")

local Tabpage = setmetatable({}, {})

local property_getters = {
    number = function(tab)
        return api.nvim_tabpage_get_number(tab.handle)
    end,
    current_window = function(tab)
        local Window = require("lib.vim.window")
        return Window:from_handle(api.nvim_tabpage_get_win(tab.handle))
    end,
    valid = function(tab)
        return api.nvim_tabpage_is_valid(tab.handle)
    end,
}

local property_setters = {
    current_window = function(tab, val)
        local Window = require("lib.vim.window")
        if oop.is_instance(val, Window) then
            val = val.handle
        end
        api.nvim_tabpage_set_win(tab.handle, val)
    end,
}

Tabpage.__index = function(tbl, key)
    local raw = rawget(Tabpage, key)
    if raw then
        return raw
    end

    local getter = property_getters[key]
    if getter then
        return getter(tbl)
    end
end

Tabpage.__newindex = function(tbl, key, value)
    local setter = property_setters[key]
    if setter then
        setter(tbl, value)
    else
        rawset(tbl, key, value)
    end
end

-- creates a Tabpage object
function Tabpage:new(handle, verify)
    if handle == 0 then
        handle = api.nvim_get_current_tabpage()
    else
        verify = verify or true
        if verify then
            if not api.nvim_tagpage_is_valid(handle) then
                error(string.format("Tabpage with handle %d is not valid", handle))
            end
        end
    end
    local tab = {
        handle = handle,
    }
    setmetatable(tab, Tabpage)
    return tab
end

-- Opens a new tabdow on given buffer
function Tabpage:open(buffer)
    local cmd = { cmd = "tabnew" }
    cmd.args = buffer
    api.nvim_cmd(cmd, {})
    return Tabpage:new(0)
end

function Tabpage:close()
    for _, win in self:list_windows() do
        win:close()
    end
    self = nil
end

local mt = getmetatable(Tabpage)
function mt.__call(_, ...)
    args = { ... }
    if #args == 0 then
        args = { 0 }
    end
    if #args == 1 then
        if type(args[1]) == "number" then
            return Tabpage:from_handle(args[1])
        end
    end
end

function Tabpage:list_windows()
    local Window = require("lib.vim.window")
    local ObjectList = require("lib.vim.object_list")
    local handles = api.nvim_tabpage_list_wins(self.handle)
    local wins = {}
    for i, hand in ipairs(handles) do
        wins[i] = Window:from_handle(hand)
    end
    return ObjectList(wins)
end

function Tabpage:set_var(name, value)
    api.nvim_tabpage_set_var(self.handle, name, value)
end

function Tabpage:get_var(name)
    api.nvim_tabpage_get_var(self.handle, name)
end

function Tabpage:del_var(name)
    api.nvim_tabpage_del_var(self.handle, name)
end

function Tabpage:set_as_current()
    api.nvim_set_current_tabpage(self.handle)
end

--
--  Static functions
--
function Tabpage.list_all()
    local ObjectList = require("lib.vim.object_list")
    local tabs = {}
    local handles = api.nvim_list_tabpages()
    for i, handle in ipairs(handles) do
        local tab = Tabpage:new(handle, false)
        tabs[i] = tab
    end
    return ObjectList(tabs)
end

return Tabpage
