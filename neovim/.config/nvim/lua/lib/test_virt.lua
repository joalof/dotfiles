local bnr = vim.fn.bufnr('%')
local ns_id = vim.api.nvim_create_namespace('demo')
local line_num = 5
local col_num = 5

local opts = {
    id = 1,
    virt_text = {{"demo", "IncSearch"}},
    virt_text_pos = 'overlay',
    -- virt_text_win_col = 20,
    strict = false,

}

local mark_id = vim.api.nvim_buf_set_extmark(bnr, ns_id, line_num, col_num, opts)
