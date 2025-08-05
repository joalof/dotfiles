vim.keymap.set("n", "j", "gj")
vim.keymap.set("n", "k", "gk")

vim.keymap.set("n", "'", "`")
vim.keymap.set("n", "`", "'")
vim.keymap.set("n", "0", "^")
vim.keymap.set("n", "^", "0")

-- splitline
vim.keymap.set("n", "S", function()
    return [[:keeppatterns substitute/\s*\%#\s*/\r/e <bar> normal! ==k$<CR>]]
end, { expr = true })


local function navigate_window(direction)
    vim.cmd.wincmd(direction)
    local buf_id = vim.api.nvim_win_get_buf(0)
    -- local opt = vim.api.nvim_get_option_value('buftype', {buf=buf_id}) 
    -- local mode = vim.api.nvim_get_mode()
    -- vim.print(mode)
    if vim.api.nvim_get_option_value('buftype', {buf=buf_id}) == 'terminal' and vim.api.nvim_get_mode().mode == 'nt' then
        vim.cmd.normal('i')
    end
end


-- split window navigation
for _, direction in ipairs({'h', 'j', 'k', 'l'}) do
    vim.keymap.set({'n', 't'}, '<C-s>'.. direction, function() navigate_window(direction) end)
end
