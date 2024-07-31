require("table.new")
local tablex = require("lib.tablex")

local M = {}

local Vector = setmetatable({}, {})

M.Vector = Vector

Vector.__index = Vector

function Vector:new(data, copy)
    data = data or {}
    if not tablex.is_listlike(data) then
        error("List-like table required to create Vector")
    end
    if copy then
        data = tablex.shallow_copy(data)
    end
    data = setmetatable(data, Vector)
    return data
end

local Vector_mt = getmetatable(Vector)
function Vector_mt.__call(_, opts)
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
    local data = table.new(1 + math.floor((stop - start) / step), 0)
    for i = start, stop, step do
        data[i] = self[i]
    end
    data = setmetatable(data, Vector)
    return data
end

function Vector:sort(comp)
    table.sort(self, comp)
    return self
end

function Vector:copy()
    return Vector.new(self, true)
end

function Vector:__add(other)
    if type(self) == "number" then
        self, other = other, self
    end
    local res = table.new(#self, 0)
    if type(other) == "number" then
        for i, x in ipairs(self) do
            res[i] = x + other
        end
    else
        for i, x in ipairs(self) do
            res[i] = x + other[i]
        end
    end
    res = setmetatable(res, Vector)
    return res
end

function Vector:add(other)
    local res = table.new(#self, 0)
    if type(other) == "number" then
        for i, x in ipairs(self) do
            self[i] = x + other
        end
    else
        for i, x in ipairs(self) do
            self[i] = x + other[i]
        end
    end
    setmetatable(res, Vector)
    return res
end

function Vector:iadd(other)
    for i, x in ipairs(self) do
        self[i] = x + other[i]
    end
end

function Vector:ineg()
    for i, x in ipairs(self) do
        self[i] = -x
    end
end

function Vector:__unm()
    local res = table.new(#self, 0)
    for i, x in ipairs(self) do
        res[i] = -x
    end
    res = setmetatable(res, Vector)
    return res
end

function Vector:__sub(other)
    local res = nil
    if type(self) == "number" then
        res = table.new(#other, 0)
        for i, x in ipairs(other) do
            res[i] = self - x
        end
    else
        res = table.new(#self, 0)
        if type(other) == "number" then
            for i, x in ipairs(self) do
                res[i] = x - other
            end
        else
            for i, x in ipairs(self) do
                res[i] = x - other[i]
            end
        end
    end
    setmetatable(res, Vector)
    return res
end

function Vector:sub(other)
    local res = table.new(#self, 0)
    if type(other) == "number" then
        for i, x in ipairs(self) do
            self[i] = x - other
        end
    else
        for i, x in ipairs(self) do
            self[i] = x - other[i]
        end
    end
    setmetatable(res, Vector)
    return res
end

function Vector:isub(other)
    if type(other) == "number" then
        for i, x in ipairs(self) do
            self[i] = x - other
        end
    else
        for i, x in ipairs(self) do
            self[i] = x - other[i]
        end
    end
end

function Vector:__mul(other)
    if type(self) == "number" then
        self, other = other, self
    end
    local res = table.new(#self, 0)
    if type(other) == "number" then
        for i, x in ipairs(self) do
            res[i] = x * other
        end
    else
        for i, x in ipairs(self) do
            res[i] = x * other[i]
        end
    end
    res = setmetatable(res, Vector)
    return res
end

function Vector:mul(other)
    local res = table.new(#self, 0)
    if type(other) == "number" then
        for i, x in ipairs(self) do
            self[i] = x * other
        end
    else
        for i, x in ipairs(self) do
            self[i] = x * other[i]
        end
    end
    setmetatable(res, Vector)
    return res
end

function Vector:imul(other)
    if type(other) == "number" then
        for i, x in ipairs(self) do
            self[i] = x * other
        end
    else
        for i, x in ipairs(self) do
            self[i] = x * other[i]
        end
    end
end

function Vector:__div(other)
    local res = nil
    if type(self) == "number" then
        res = table.new(#other, 0)
        for i, x in ipairs(other) do
            res[i] = self / x
        end
    else
        res = table.new(#self, 0)
        if type(other) == "number" then
            for i, x in ipairs(self) do
                res[i] = x / other
            end
        else
            for i, x in ipairs(self) do
                res[i] = x / other[i]
            end
        end
    end
    setmetatable(res, Vector)
    return res
end

function Vector:div(other)
    local res = table.new(#self, 0)
    if type(other) == "number" then
        for i, x in ipairs(self) do
            self[i] = x / other
        end
    else
        for i, x in ipairs(self) do
            self[i] = x / other[i]
        end
    end
    setmetatable(res, Vector)
    return res
end

function Vector:idiv(other)
    if type(other) == "number" then
        for i, x in ipairs(self) do
            self[i] = x / other
        end
    else
        for i, x in ipairs(self) do
            self[i] = x / other[i]
        end
    end
end

function Vector:__pow(scalar)
    local res = table.new(#self, 0)
    for i, x in ipairs(self) do
        res[i] = x ^ scalar
    end
    setmetatable(res, Vector)
    return res
end

function Vector:ipow(scalar)
    for i, x in ipairs(self) do
        self[i] = x ^ scalar
    end
end

function Vector:__tostring()
    local left = "Vector["
    local middle = ""
    for _, x in ipairs(self) do
        middle = middle .. tostring(x) .. ", "
    end
    return left .. middle:sub(1, -3) .. "]"
end

function Vector:__eq(other)
    for i, x in ipairs(self) do
        if x ~= other[i] then
            return false
        end
    end
    return true
end

--
-- Module level functions
--
function M.zeros(n)
    local data = table.new(n, 0)
    for i = 1, n do
        data[i] = 0
    end
    setmetatable(data, Vector)
    return data
end

function M.zeros_like(v)
    return M.zeros(#v)
end

function M.ones(n)
    local data = table.new(n, 0)
    for i = 1, n do
        data[i] = 1
    end
    setmetatable(data, Vector)
    return data
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

function M.cumsum(v)
    local res = table.new(#v, 0)
    local tmp = v[1]
    res[1] = tmp
    for i = 2, #v do
        tmp = tmp + v[i]
        res[i] = tmp
    end
    setmetatable(res, Vector)
    return res
end

function M.prod(v)
    local res = 1
    for _, x in ipairs(v) do
        res = res * x
    end
    return res
end

function M.cumprod(v)
    local res = table.new(#v, 0)
    local tmp = v[1]
    res[1] = tmp
    for i = 2, #v do
        tmp = tmp * v[i]
        res[i] = tmp
    end
    setmetatable(res, Vector)
    return res
end

function M.norm(v)
    local res = 0
    for _, x in ipairs(v) do
        res = res + x ^ 2
    end
    return math.sqrt(res)
end

function M.dot(v, w)
    local res = 0
    for i, x in ipairs(v) do
        res = res + x * w[i]
    end
    return res
end

function M.min(v)
    return math.min(unpack(v))
end

function M.max(v)
    return math.max(unpack(v))
end

function M.argmin(v)
    local ind = 1
    local res = v[1]
    for i = 2, #v do
        if v[i] < res then
            ind = i
        end
    end
    return ind
end

function M.argmax(v)
    local ind = 1
    local res = v[1]
    for i = 2, #v do
        if v[i] > res then
            ind = i
        end
    end
    return ind
end

function M.arange(start, stop, step)
    step = step or 1
    local res = table.new(1 + math.floor((stop - start) / step), 0)
    local i = 1
    for x = start, stop, step do
        res[i] = x
        i = i + 1
    end
    setmetatable(res, Vector)
    return res
end

function M.vector(...)
    return M.Vector(...)
end

return M
