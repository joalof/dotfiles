M = {}

function M.is_instance(object, class)
    if type(object) == "table" then
        if class == "table" then
            return true
        else
            local mt = getmetatable(object)
            if mt then
                return mt == class
            end
        end
    elseif type(object) == class then
        return true
    end
    return false
end

return M
