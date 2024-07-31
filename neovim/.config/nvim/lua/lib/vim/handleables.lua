require("table.new")


--- @class Handleables : table
--- @field objects table<any>
--- @field handles table<number>
--- @field class type
local Handleables = setmetatable({}, {})

M.Handleables = Handleables

Handleables.__index = function(data, key)
    if type(key) == "number" then
        local obj = data.objects[key]
        if not obj then
            obj = data.class(data.handles[key])
            data.objects[key] = obj
        end
        return obj
    end
    local other = rawget(data, key)
    return other
    
end

--- Creates a new Handleables instance
--- @param handles table<number> 
--- @param class table
--- @return Handleables
function Handleables:new(handles, class)
    local data = {handles=handles, class= class}
    data['objects'] = table.new(#handles)
    setmetatable(data, Handleables)
    return data
end


local Handleables_mt = getmetatable(Handleables)
function Handleables_mt.__call(_, ...)
    return Handleables:new(...)
end

--- Gets a property from all buffers in the list
--- @param property string The property to get
--- @return table The list of property values
function Handleables:get_property(property)
    local values = {}
    for i, _ in ipairs(self.handles) do
        values[i] = self[i]
    end
    return values
end

--- Filters buffers in the list based on a function
--- @param fun function Filtering function, will be passed the 
--- @return Handleables The filtered list of buffers
function Handleables:filter(fun)
    local filtered = {handles = {}, objects= {}}
    for i, hand in ipairs(self.handles) do
        local obj = self[i]
        if fun(obj) then
            filtered.handles[i] = hand
            filtered.objects[i] = obj
        end
    end
    filtered.class = self.class
    setmetatable(filtered, Handleables)
    return filtered
end

--- Filters buffers in the list based on a property value
--- @param property string The property to filter by
--- @param value any The value to match
--- @return Handleables The filtered list of buffers
function Handleables:filter_by(property, value)
    local filtered = {handles = {}, objects= {}}
    for i, hand in ipairs(self.handles) do
        local obj = self[i]
        if obj[property] == value then
            filtered.handles[i] = hand
            filtered.objects[i] = obj
        end
    end
    filtered.class = self.class
    setmetatable(filtered, Handleables)
    return filtered
end

return Handleables
