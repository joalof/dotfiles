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

local Set = setmetatable({}, {})

Set.__index = Set

function Set:new(data)
    data = data or {}
    local data_new = {}
    if is_listlike(data) then
        for _, elem in ipairs(data) do
            data_new[elem] = true
        end
    else
        for elem in pairs(data) do
            data_new[elem] = true
        end
    end
    data_new = setmetatable(data_new, Set)
    return data_new
end

function Set:has(elem)
    return self[elem] ~= nil
end

function Set:add(elem)
    self[elem] = true
end

-- s <= t
function Set:is_subset(other)
    for elem in pairs(self) do
        if not other[elem] then
            return false
        end
    end
    return true
end

function Set:__le(other)
    return Set:is_subset(other)
end


-- s | t
function Set:union(other)
    local res = Set()
    for elem in pairs(self) do
        res[elem] = true
    end
    for elem in pairs(other) do
        res[elem] = true
    end
    return res
end

-- not supported in luajit
-- function Set:__bor(other)
--     return Set.union(self, other)
-- end


-- s & t
function Set:intersection(other)
    local res = Set()
    for elem in pairs(self) do
        if other[elem] ~= nil then
            res[elem] = true
        end
    end
    return res
end

-- not supported in luajit
-- function Set:__band(other)
--     return Set:intersection(other)
-- end

-- s - t
function Set:difference(other)
    local res = Set()
    for elem in pairs(self) do
        if not other[elem] then
            res[elem] = true
        end
    end
    return res
end

function Set:__sub(other)
    return Set.difference(self, other)
end

-- s ^ t
function Set:symmetric_difference(other)
    local res = Set()
    for elem in pairs(self) do
        if not other[elem] then
            res[elem] = true
        end
    end
    for elem in pairs(other) do
        if not self[elem] then
            res[elem] = true
        end
    end
    return res
end

function Set:__pow(other)
    return Set.symmetric_difference(self, other)
end


function Set:update(other)
    for elem in pairs(other) do
        self[elem] = true
    end
end

function Set:intersection_update(other)
    for elem in pairs(self) do
        if other[elem] == nil then
            self[elem] = nil
        end
    end
end
    
function Set:difference_update(other)
    for elem in pairs(self) do
        if other[elem] then
           self[elem] = nil
        end
    end
end

function Set:symmetric_difference_update(other)
    for elem in pairs(other) do
        if self[elem] then
            self[elem] = nil
        else
            self[elem] = true
        end
    end
end

function Set:pop()
    for elem in pairs(self) do
        self[elem] = nil
        return elem
    end
end

function Set:remove(elem)
    self[elem] = nil
end

function Set:copy()
    local res = Set()
    for elem in pairs(self) do
        res[elem] = true
    end
    return res
end

function Set:__eq(other)
    for elem in pairs(self) do
        if not other[elem] then
            return false
        end
    end
    for elem in pairs(other) do
        if not self[elem] then
            return false
        end
    end
    return true
end

function Set:__tostring()
    local s = "Set{"
    for elem in pairs(self) do
        s = s .. tostring(elem) .. ', '
    end
    s = s:sub(1, -3) .. '}'
    return s
end

function Set:len()
    local count = 0
    for _ in pairs(self) do
        count = count + 1
    end
    return count
end

local mt = getmetatable(Set)
function mt.__call(_, opts)
    return Set:new(opts)
end

return Set
