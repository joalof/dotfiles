vim.g.better_escape_shortcut = "jk"
vim.keymap.set("n", "j", "gj")
vim.keymap.set("n", "k", "gk")

vim.keymap.set("n", "'", "`")
vim.keymap.set("n", "`", "'")
vim.keymap.set("n", "0", "^")
vim.keymap.set("n", "^", "0")

-- vim.keymap.set("n", "<c-l>", "i<space><esc>l")
-- vim.keymap.set("n", "<c-k>", "O<esc>")
vim.keymap.set("n", "<c-j>", "o<esc>")

-- vim.keymap.set("n", "gh", "^")
-- vim.keymap.set("n", "gl", "$")
-- vim.keymap.set({"n", "x", "o"}, "gj", "}")
-- vim.keymap.set({"n", "x", "o"}, "gk", "{")

-- Add empty lines before and after cursor line
-- vim.keymap.set('n', '[<space>', "<Cmd>call append(line('.') - 1, repeat([''], v:count1))<CR>")
-- vim.keymap.set('n', ']<space>', "<Cmd>call append(line('.'),     repeat([''], v:count1))<CR>")

vim.keymap.set("n", "]t", ":tabnext<cr>", { silent = true })
vim.keymap.set("n", "[t", ":tabprevious<cr>", { silent = true })
 
vim.keymap.set("n", "]b", ":bnext<cr>", { silent = true })
vim.keymap.set("n", "[b", ":bprevious<cr>", { silent = true })
vim.keymap.set("n", "]B", ":blast<cr>", { silent = true })
vim.keymap.set("n", "[B", ":bfirst<cr>", { silent = true })

-- terminal
vim.keymap.set("t", "jk", "<C-\\><C-n>")

-- splitline
vim.keymap.set("n", "S", function()
    return [[:keeppatterns substitute/\s*\%#\s*/\r/e <bar> normal! ==k$<CR>]]
end, { expr = true })

-- apply macro over visual range
-- vim.keymap.set("x", "@", function()
--     return ":norm @" .. vim.fn.getcharstr() .. "<cr>"
-- end, { expr = true })
