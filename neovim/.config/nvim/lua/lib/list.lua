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

return M
