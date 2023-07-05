-- vim.keymap.set("i", "jk", "<esc>")
vim.g.better_escape_shortcut = 'jk'

vim.keymap.set("n", "j", "gj")
vim.keymap.set("n", "k", "gk")

vim.keymap.set("n", "'", "`")
vim.keymap.set("n", "`", "'")
vim.keymap.set("n", "0", "^")
vim.keymap.set("n", "^", "0")

vim.keymap.set("n", "<c-h>", "hx<esc>")
vim.keymap.set("n", "<c-l>", "i<space><esc>l")
vim.keymap.set("n", "<c-j>", "o<esc>")
vim.keymap.set("n", "<c-k>", "O<esc>")

vim.keymap.set("n", "]q", ":cnext<cr>")
vim.keymap.set("n", "[q", ":cprevious<cr>")
vim.keymap.set("n", "]Q", ":clast<cr>")
vim.keymap.set("n", "[Q", ":cfirst<cr>")

vim.keymap.set("n", "]b", ":bnext<cr>")
vim.keymap.set("n", "[b", ":bprevious<cr>")
vim.keymap.set("n", "]B", ":blast<cr>")
vim.keymap.set("n", "[B", ":bfirst<cr>")


-- splitline
vim.keymap.set('n', 'S',
    function ()
        return [[:keeppatterns substitute/\s*\%#\s*/\r/e <bar> normal! ==k$<CR>]]
    end,
    {expr = true})

-- apply macro over visual range
vim.keymap.set('x', '@',
    function ()
        return ':norm @' .. vim.fn.getcharstr() .. '<cr>'
    end,
    {expr = true})
