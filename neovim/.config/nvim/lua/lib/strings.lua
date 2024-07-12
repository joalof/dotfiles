local M = {}

function M.trim(str)
    return (str:gsub("^%s*(.-)%s*$", "%1"))
end

function M.split(str, sep)
    if sep == nil then
        sep = "%s"
    end
    local t = {}
    for s in string.gmatch(str, "([^" .. sep .. "]+)") do
        table.insert(t, s)
    end
    return t
end

function M.join(sep, list)
    local s = list[1]
    for i = 2, #list do
        s = s .. sep .. list[i]
    end
    return s
end
