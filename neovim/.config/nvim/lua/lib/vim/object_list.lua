require("table.new")


--- @class ObjectList : table
--- @field objects table<any>
local ObjectList = setmetatable({}, {})


ObjectList.__index = ObjectList

--- @param objects table<number, any> 
--- @return ObjectList
function ObjectList:new(objects)
    setmetatable(objects, ObjectList)
    return objects
end


local ObjectList_mt = getmetatable(ObjectList)
function ObjectList_mt.__call(_, ...)
    return ObjectList:new(...)
end

--- Gets a property from all buffers in the list
--- @param property string The property to get
--- @return table The list of property values
function ObjectList:get_property(property)
    local values = table.new(#self.objects, 0)
    for i, obj in ipairs(self.objects) do
        values[i] = obj[i][property]
    end
    return values
end

--- Filters objects in the list based on a function
--- @param fun function Filtering function, will be passed the 
--- @param opts table Options
--- @return ObjectList | any Filtered list of objects or first matching objects
function ObjectList:filter(fun, opts)
    local filtered = {}
    opts = opts or {first = false}
    for i, obj in ipairs(self.objects) do
        if fun(obj) then
            if opts.first then
                return obj
            else
                filtered[i] = obj
            end
        end
    end
    return ObjectList:new(filtered)
end

--- Filters objects in the list based on a property value
--- @param property string The property to filter by
--- @param value any The value to match
--- @param opts table Options
--- @return ObjectList The filtered list of buffers
function ObjectList:filter_by(property, value, opts)
    local filtered = {}
    opts = opts or {first = false}
    for i, obj in ipairs(self.objects) do
        if obj[property] == value then
            if opts.first then
                return obj
            else
                filtered[i] = obj
            end
        end
    end
    return ObjectList:new(filtered)
end

return ObjectList
