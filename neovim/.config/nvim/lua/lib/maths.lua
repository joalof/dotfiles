local M = {}

---Round float to nearest int
---@param x number Float
---@return number
function M.round(x)
    return x >= 0 and math.floor(x + 0.5) or math.ceil(x - 0.5)
end

---Clamp value between the min and max values.
function M.clamp(value, min, max)
    return math.min(math.max(value, min), max)
end

return M
