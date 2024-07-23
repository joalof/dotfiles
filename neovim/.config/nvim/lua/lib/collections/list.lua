local tablex = require("lib.tablex")
require("table.new")

local List = setmetatable({}, {})
local M = { List = List }

List.__index = List

function List:new(data, copy)
    data = data or {}
    if not tablex.is_listlike(data) then
        error("Failed to create list, table contains non-integer keys")
    end
    if copy then
        data = table.shallow_copy(data)
    end
    data = setmetatable(data, List)
    return data
end

function List:len()
    return #self
end

function List:append(item)
    self[#self + 1] = item
end

function List:extend(other)
    local n = #self
    for i, x in ipairs(other) do
        self[n + i] = x
    end
end

function List:index(item)
    for i, x in ipairs(self) do
        if x == item then
            return i
        end
    end
    error(string.format("%i is not in list", item))
end

function List:pop(i)
    return table.remove(self, i)
end

function List:remove(item)
    local i = self:index(item)
    table.remove(self, i)
end

function List:slice(start, stop, step)
    step = step or 1
    local data = table.new(1 + math.floor((stop - start) / step), 0)
    for i = start, stop, step do
        data[i] = self[i]
    end
    return List.new(data)
end

function List:count(item)
    local num = 0
    for _, x in ipairs(self) do
        if x == item then
            num = num + 1
        end
    end
    return num
end

function List:reverse()
    self:sort(function(a, b)
        return a > b
    end)
end

function List:sort(comp)
    self:sort(comp)
end

function List:copy()
    return List.new(self, true)
end

function List:__tostring()
    local s = "List["
    for _, x in ipairs(self) do
        s = s .. tostring(x) .. ", "
    end
    s = s:sub(1, -3) .. "]"
    return s
end

function List:__eq(other)
    for i, x in ipairs(self) do
        if x ~= other[i] then
            return false
        end
    end
    return true
end

local mt = getmetatable(List)
function mt.__call(_, opts)
    if type(opts) == "table" then
        return List:new(opts)
    end
end

return M
