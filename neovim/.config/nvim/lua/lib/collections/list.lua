---@param t table
local function is_listlike(t)
    local i = 0
    for _ in pairs(t) do
        i = i + 1
        if t[i] == nil then
            return false
        end
    end
    return true
end


local function shallow_copy(t)
    local t_new = {}
    for i, x in ipairs(t) do
        t_new[i] = x
    end
    return t_new
end


local List = setmetatable({}, {})

List.__index = List
-- List.__index = function(data, key)
--     if type(key) == "number" then
--         return data[wrap_index(data, key)]
--     else
--         return List[key]
--     end
-- end


function List:new(data, copy)
    data = data or {}
    if not is_listlike(data) then
       error('Failed to create list, table contains non-integer keys')
    end
    if copy then
        data = shallow_copy(data)
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
    local data = {}
    for i = start, stop, step do
        data[i] = self[i]
    end
    return List:new(data)
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
    table.sort(self, function(a, b) return a > b end)
end

function List:sort(comp)
    table.sort(self, comp)
end

function List:copy()
    return List.new(self, true)
end

function List:__tostring()
    local s = "List["
    for _, x in ipairs(self) do
        s = s .. tostring(x) .. ', '
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

return List
