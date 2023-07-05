vim.opt.scrolloff = 3
vim.opt.sidescrolloff = 5
vim.opt.swapfile = false
vim.opt.backup = false
-- vim.opt.listchars = {
--     eol = "$",
--     tab = ">-",
--     trail = "~",
--     extends = ">",
--     precedes = "<",
-- }
vim.opt.signcolumn = 'number'
vim.opt.showmode = false

-- tabs
vim.opt.tabstop = 8
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.mousehide = false
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.number = true

-- performance
vim.opt.history = 1000
vim.opt.synmaxcol = 500
vim.opt.tabpagemax = 50
vim.opt.updatetime = 1000

-- searching
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- highlight match
vim.opt.showmatch = true

-- autosaving
vim.opt.autowriteall = true

-- wildmenu
vim.opt.wildignore = {
    "*.o", "*.obj", "*~", "*.png", "*.jpg", "*.gif", "*.eps",
}
