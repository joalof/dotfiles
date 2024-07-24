local M = {}

-- useful functions from https://github.com/mobily/.nvim/blob/main/lua/utils/fn.lua
M.pack = table.pack or function(...)
    return { n = select("#", ...), ... }
end

M.unpack = M.unpack or unpack

function M.is_listlike(tbl)
    return vim.islist(tbl)
end

function M.is_dictlike(tbl)
    return #tbl == 0
end

function M.shallow_copy(tbl)
    local tbl_copy = {}
    for key, val in pairs(tbl) do
        tbl_copy[key] = val
    end
    return tbl_copy
end

return M
