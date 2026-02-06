local M = {}

function M.join(sep, list)
    local s = list[1]
    for i = 2, #list do
        s = s .. sep .. list[i]
    end
    return s
end

return M
