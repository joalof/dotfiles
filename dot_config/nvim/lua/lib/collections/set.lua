local tablex = require("lib.tablex")

-- Define the Set class
local Set = setmetatable({}, {})

Set.__index = Set

--- Creates a new set.
-- @param data A table containing the initial elements for the set (optional).
-- @return A new set object.
function Set:new(data)
    data = data or {}
    local data_new = {}
    if tablex.is_listlike(data) then
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

--- Checks if the set contains an element.
-- @param elem The element to check.
-- @return True if the element is in the set, false otherwise.
function Set:has(elem)
    return self[elem] ~= nil
end

--- Adds an element to the set.
-- @param elem The element to add.
function Set:add(elem)
    self[elem] = true
end

--- Checks if the set is a subset of another set.
-- @param other The other set.
-- @return True if the set is a subset of the other set, false otherwise.
function Set:is_subset(other)
    for elem in pairs(self) do
        if not other[elem] then
            return false
        end
    end
    return true
end

--- Metamethod for the subset comparison (<=).
-- @param other The other set.
-- @return True if the set is a subset of the other set, false otherwise.
function Set:__le(other)
    return Set:is_subset(other)
end

--- Returns the union of the set with another set.
-- @param other The other set.
-- @return A new set containing all elements from both sets.
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

--- Metamethod for the union operation (+).
-- @param other The other set.
-- @return A new set containing all elements from both sets.
function Set:__add(other)
    return Set.union(self, other)
end

--- Returns the intersection of the set with another set.
-- @param other The other set.
-- @return A new set containing only the elements common to both sets.
function Set:intersection(other)
    local res = Set()
    for elem in pairs(self) do
        if other[elem] ~= nil then
            res[elem] = true
        end
    end
    return res
end

--- Metamethod for the intersection operation (/).
-- @param other The other set.
-- @return A new set containing only the elements common to both sets.
function Set:__div(other)
    return Set:intersection(other)
end

--- Returns the difference of the set with another set.
-- @param other The other set.
-- @return A new set containing the elements in the set but not in the other set.
function Set:difference(other)
    local res = Set()
    for elem in pairs(self) do
        if not other[elem] then
            res[elem] = true
        end
    end
    return res
end

--- Metamethod for the difference operation (-).
-- @param other The other set.
-- @return A new set containing the elements in the set but not in the other set.
function Set:__sub(other)
    return Set.difference(self, other)
end

--- Returns the symmetric difference of the set with another set.
-- @param other The other set.
-- @return A new set containing elements in either set but not in both.
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

--- Metamethod for the symmetric difference operation (^).
-- @param other The other set.
-- @return A new set containing elements in either set but not in both.
function Set:__pow(other)
    return Set.symmetric_difference(self, other)
end

--- Updates the set, adding elements from another set.
-- @param other The other set.
function Set:update(other)
    for elem in pairs(other) do
        self[elem] = true
    end
end

--- Updates the set, keeping only the elements also found in another set.
-- @param other The other set.
function Set:intersection_update(other)
    for elem in pairs(self) do
        if other[elem] == nil then
            self[elem] = nil
        end
    end
end

--- Updates the set, removing elements found in another set.
-- @param other The other set.
function Set:difference_update(other)
    for elem in pairs(self) do
        if other[elem] then
            self[elem] = nil
        end
    end
end

--- Updates the set, performing a symmetric difference with another set.
-- @param other The other set.
function Set:symmetric_difference_update(other)
    for elem in pairs(other) do
        if self[elem] then
            self[elem] = nil
        else
            self[elem] = true
        end
    end
end

--- Removes and returns an arbitrary element from the set.
-- @return An element from the set.
function Set:pop()
    for elem in pairs(self) do
        self[elem] = nil
        return elem
    end
end

--- Removes an element from the set.
-- @param elem The element to remove.
function Set:remove(elem)
    self[elem] = nil
end

--- Creates a copy of the set.
-- @return A new set that is a copy of the current set.
function Set:copy()
    local res = Set()
    for elem in pairs(self) do
        res[elem] = true
    end
    return res
end

--- Checks if two sets are equal.
-- @param other The other set.
-- @return True if the sets contain the same elements, false otherwise.
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

--- Converts the set to a string representation.
-- @return A string representing the set.
function Set:__tostring()
    local s = "Set{"
    for elem in pairs(self) do
        s = s .. tostring(elem) .. ", "
    end
    s = s:sub(1, -3) .. "}"
    return s
end

--- Returns the number of elements in the set.
-- @return The number of elements in the set.
function Set:len()
    local count = 0
    for _ in pairs(self) do
        count = count + 1
    end
    return count
end

-- Metamethod for calling the Set constructor.
-- @param opts The initial elements for the set (optional).
-- @return A new set object.
local Set_mt = getmetatable(Set)
function Set_mt.__call(_, args)
    return Set:new(args)
end

local M = {}
M.Set = Set

-- define some convenient module level functions
M.set = function(args)
    return Set(args)
end

M.union = function(sets)
    local res = Set()
    for _, set in ipairs(sets) do
        res.update(set)
    end
    return res
end

M.intersection = function(sets)
    local res = Set()
    for _, set in ipairs(sets) do
        res.intersection_update(set)
    end
    return res
end

return M
