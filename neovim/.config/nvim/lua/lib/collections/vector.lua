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


-- vector class
local Vector = setmetatable({}, {})

-- functions on vectors
local M = {}


Vector.__index = Vector


function Vector:new(data, copy)
    data = data or {}
    if not is_listlike(data) then
       error('List-like table required to create Vector')
    end
    if copy then
        data = shallow_copy(data)
    end
    data = setmetatable(data, Vector)
    return data
end

local mt = getmetatable(Vector)
function mt.__call(_, opts)
    opts = opts or {}
    if type(opts) == "table" then
        return Vector:new(opts)
    end
end

function Vector:len()
    return #self
end

function Vector:slice(start, stop, step)
    step = step or 1
    local data = {}
    for i = start, stop, step do
        data[i] = self[i]
    end
    return Vector:new(data)
end

function Vector:sort(comp)
    table.sort(self, comp)
end

function Vector:copy()
    return Vector.new(self, true)
end

function Vector:__add(other)
    local res = {}
    for i, x in ipairs(self) do
        res[i] = x + other[i]
    end
    return Vector(res)
end


function Vector:__unm()
    local res = {}
    for i, x in ipairs(self) do
        res[i] = -x
    end
    return Vector(res)
end

function Vector:__sub(other)
    local res = {}
    for i, x in ipairs(self) do
        res[i] = x - other[i]
    end
    return Vector(res)
end

function Vector:__mul(other)
    local res = {}
    for i, x in ipairs(self) do
        res[i] = x * other[i]
    end
    return Vector(res)
end

function Vector:__div(other)
    local res = Vector()
    for i, x in ipairs(self) do
        res[i] = x / other[i]
    end
    return res
end

function Vector:__pow(a)
    local res = {}
    for i, x in ipairs(self) do
        res[i] = x ^ a
    end
    return Vector(res)
end

function Vector:__tostring()
    local s = "Vector["
    for _, x in ipairs(self) do
        s = s .. tostring(x) .. ', '
    end
    s = s:sub(1, -3) .. "]"
    return s
end

function Vector:__eq(other)
    for i, x in ipairs(self) do
        if x ~= other[i] then
            return false
        end
    end
    return true
end

function M.zeros(n)
    local data = {}
    for i = 1, n do
        data[i] = 0
    end
    return Vector(data)
end

function M.zeros_like(v)
    return M.zeros(#v)
end

function M.ones(n)
    local data = {}
    for i = 1, n do
        data[i] = 1
    end
    return Vector(data)
end

function M.ones_like(v)
    return M.ones(#v)
end

function M.full(n, fill_value)
    return fill_value * M.ones(n)
end
    
function M.full_like(v, fill_value)
    return fill_value * M.ones_like(v)
end

function M.sum(v)
    local res = 0
    for _, x in ipairs(v) do
        res = res + x
    end
    return res
end

function M.prod(v)
    local res = 1
    for _, x in ipairs(v) do
        res = res * x
    end
    return res
end

function M.norm(v)
    local res = 0
    for _, x in ipairs(v) do
        res = res + x^2
    end
    return math.sqrt(res)
end

function M.dot(v, w)
    local res = 0
    for i, x in ipairs(v) do
        res = res + x*w[i]
    end
    return res
end

function M.min(v)
    return math.min(unpack(v))
end

function M.max(v)
    return math.max(unpack(v))
end

function M.arange(start, stop, step)
    step = step or 1
    local res = {}
    local i = 1
    for x = start, stop, step do
        res[i] = x
        i = i + 1
    end
    return Vector(res)
end

M.Vector = Vector
return M
