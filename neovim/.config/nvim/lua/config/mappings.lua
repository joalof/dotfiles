vim.keymap.set("n", "j", "gj")
vim.keymap.set("n", "k", "gk")

vim.keymap.set("n", "'", "`")
vim.keymap.set("n", "`", "'")
vim.keymap.set("n", "0", "^")
vim.keymap.set("n", "^", "0")

-- vim.keymap.set("n", "]t", ":tabnext<cr>", { silent = true })
-- vim.keymap.set("n", "[t", ":tabprevious<cr>", { silent = true })

vim.keymap.set("n", "]b", ":bnext<cr>", { silent = true })
vim.keymap.set("n", "[b", ":bprevious<cr>", { silent = true })
vim.keymap.set("n", "]B", ":blast<cr>", { silent = true })
vim.keymap.set("n", "[B", ":bfirst<cr>", { silent = true })


-- splitline
vim.keymap.set("n", "S", function()
    return [[:keeppatterns substitute/\s*\%#\s*/\r/e <bar> normal! ==k$<CR>]]
end, { expr = true })


for _, nav in ipairs({'h', 'j', 'k', 'l'}) do
    vim.keymap.set({'n', 't'}, '<C-s>'.. nav, function() vim.cmd.wincmd(nav) end)
end

vim.keymap.set({'n', 't'}, '<C-s>n', ':tabnext<cr>')
vim.keymap.set({'n', 't'}, '<C-s>p', ':tabprevious<cr>')
