local M = {}

-- useful functions from https://github.com/mobily/.nvim/blob/main/lua/utils/fn.lua
M.pack = table.pack or function(...)
  return { n = select("#", ...), ... }
end

M.unpack = M.unpack or unpack

return M
