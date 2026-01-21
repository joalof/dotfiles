local normal_hl = vim.api.nvim_get_hl(0, { name = "Normal" })
local statusline_hl = vim.api.nvim_get_hl(0, { name = "StatusLine" })

vim.api.nvim_set_hl(0, "TermNormal", { bg = statusline_hl.bg, fg = normal_hl.fg })
