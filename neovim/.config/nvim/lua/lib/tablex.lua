require("table.new")

local M = {}

-- useful functions from https://github.com/mobily/.nvim/blob/main/lua/utils/fn.lua
M.pack = table.pack or function(...)
    return { n = select("#", ...), ... }
end

M.unpack = M.unpack or unpack

function M.is_listlike(tbl)
    return vim.islist(tbl)
end

function M.shallow_copy(tbl)
    local t_new = table.new(#tbl, 0)
    for i, x in ipairs(tbl) do
        t_new[i] = x
    end
    return t_new
end


return M
