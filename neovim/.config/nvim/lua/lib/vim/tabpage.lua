local api = vim.api
local oop = require("lib.oop")

local Tabpage = setmetatable({}, {})

local M = { Tabpage = Tabpage }

local property_getters = {
    number = function(tab)
        return api.nvim_tabpage_get_number(tab.handle)
    end,
    current_window = function(tab)
        local Window = require("lib.vim.window").Window
        return Window(api.nvim_tabpage_get_win(tab.handle))
    end,
    valid = function(tab)
        return api.nvim_tabpage_is_valid(tab.handle)
    end,
}

local property_setters = {
    current_window = function(tab, val)
        local Window = require("lib.vim.window").Window
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

-- creates a tab object with given handle that
-- is not guaranteed to correspond to any actual tab
function Tabpage:_new(handle)
    local tab = {
        handle = handle,
    }
    setmetatable(tab, Tabpage)
    return tab
end

-- gets an existing tabdow from it's handle
function Tabpage:from_handle(handle)
    if handle == 0 then
        return Tabpage:_new(api.nvim_get_current_tab())
    end
    local existing_handles = api.nvim_list_tabpages()
    for _, hand in ipairs(existing_handles) do
        if hand == handle then
            return Tabpage:_new(handle)
        end
    end
end

-- Opens a new tabdow on given buffer
function Tabpage:open(buffer, enter, config)
    local Buffer = require("lib.vim.buffer").Buffer
    enter = enter or true
    config = config or {}
    if oop.is_instance(buffer, Buffer) then
        buffer = buffer.handle
    end
    local handle = api.nvim_open_tab(buffer, enter, config)
    return Tabpage:_new(handle)
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
    local Window = require("lib.vim.window").Window
    local handles = api.nvim_tabpage_list_wins(self.handle)
    local wins = {}
    for i, hand in ipairs(handles) do
        wins[i] = Window(hand)
    end
    return wins
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

--
-- Module level functions
--
function M.set_current(tab)
    if oop.is_instance(tab, Tabpage) then
        tab = tab.handle
    end
    api.nvim_set_current_tabpage(tab)
end

function M.list()
    local tabs = {}
    local handles = api.nvim_list_tabpages()
    for i, handle in ipairs(handles) do
        local tab = Tabpage:_new(handle)
        tabs[i] = tab
    end
    return tabs
end

function M.find(opts)
    opts = opts or {}
    local tabs = {}
    local handles = api.nvim_list_tabpages()
    for i, handle in ipairs(handles) do
        local tab = Tabpage:_new(handle)
        tabs[i] = tab
    end
    return tabs
end

return M
