local M = {}

function M.get_index(list, value)
    for i, v in ipairs(list) do
        if v == value then
            return i
        end
    end
    return nil
end

function M.wrap_index(list, ind)
    ind = math.fmod(ind, #list)
    if ind < 1 then
        ind = ind + #list
    end
    return ind
end


---@param t table
function M.is_list(t)
  local i = 0
  ---@diagnostic disable-next-line: no-unknown
  for _ in pairs(t) do
    i = i + 1
    if t[i] == nil then
      return false
    end
  end
  return true
end


return M
