vim.opt.scrolloff = 3
vim.opt.sidescrolloff = 5


vim.opt.listchars = {
    eol = "$",
    tab = ">-",
    trail = "~",
    extends = ">",
    precedes = "<",
}
vim.opt.signcolumn = 'number'
vim.opt.showmode = false

-- tabs
vim.opt.tabstop = 8
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

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

-- saving
vim.opt.autowriteall = true
vim.opt.swapfile = false
vim.opt.backup = false

-- wildmenu
vim.opt.wildignore = {
    "*.o", "*.obj", "*~", "*.png", "*.jpg", "*.gif", "*.eps",
}

-- colors
vim.opt.termguicolors = true

 -- Sync with system clipboard
vim.opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus"

 -- Allow cursor to move where there is no text in visual block mode
vim.opt.virtualedit = "block"

-- vim.opt.smoothscroll = true
