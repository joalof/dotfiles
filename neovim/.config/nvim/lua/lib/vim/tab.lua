local api = vim.api
local oop = require("lib.oop")

local Tab = setmetatable({}, {})

local M = { Tab = Tab }

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

Tab.__index = function(tbl, key)
    local raw = rawget(Tab, key)
    if raw then
        return raw
    end

    local getter = property_getters[key]
    if getter then
        return getter(tbl)
    end
end

Tab.__newindex = function(tbl, key, value)
    local setter = property_setters[key]
    if setter then
        setter(tbl, value)
    else
        rawset(tbl, key, value)
    end
end

-- creates a tab object with given handle that
-- is not guaranteed to correspond to any actual tab
function Tab:_new(handle)
    local tab = {
        handle = handle,
    }
    setmetatable(tab, Tab)
    return tab
end

-- gets an existing tabdow from it's handle
function Tab:from_handle(handle)
    if handle == 0 then
        return Tab:_new(api.nvim_get_current_tab())
    end
    local existing_handles = api.nvim_list_tabpages()
    for _, hand in ipairs(existing_handles) do
        if hand == handle then
            return Tab:_new(handle)
        end
    end
end

-- Opens a new tabdow on given buffer
function Tab:open(buffer, enter, config)
    local Buffer = require("lib.vim.buffer").Buffer
    enter = enter or true
    config = config or {}
    if oop.is_instance(buffer, Buffer) then
        buffer = buffer.handle
    end
    local handle = api.nvim_open_tab(buffer, enter, config)
    return Tab:_new(handle)
end

local mt = getmetatable(Tab)
function mt.__call(_, ...)
    args = { ... }
    if #args == 0 then
        args = { 0 }
    end
    if #args == 1 then
        if type(args[1]) == "number" then
            return Tab:from_handle(args[1])
        end
    end
end

function Tab:list_windows()
    local Window = require("lib.vim.window").Window
    local handles = api.nvim_tabpage_list_wins(self.handle)
    local wins = {}
    for i, hand in ipairs(handles) do
        wins[i] = Window(hand)
    end
    return wins
end


function Tab:set_var(name, value)
    api.nvim_tabpage_set_var(self.handle, name, value)
end

function Tab:get_var(name)
    api.nvim_tabpage_get_var(self.handle, name)
end

function Tab:del_var(name)
    api.nvim_tabpage_del_var(self.handle, name)
end

--
-- Module level functions
--
function M.set_current(tab)
    if oop.is_instance(tab, Tab) then
        tab = tab.handle
    end
    api.nvim_set_current_tabpage(tab)
end

function M.list()
    local tabs = {}
    local handles = api.nvim_list_tabpages()
    for i, handle in ipairs(handles) do
        local tab = Tab:_new(handle)
        tabs[i] = tab
    end
    return tabs
end

function M.find(opts)
    opts = opts or {}
    local tabs = {}
    local handles = api.nvim_list_tabpages()
    for i, handle in ipairs(handles) do
        local tab = Tab:_new(handle)
        tabs[i] = tab
    end
    return tabs
end

return M
