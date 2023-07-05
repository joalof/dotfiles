local nvim_tmux_nav = require('nvim-tmux-navigation')

nvim_tmux_nav.setup {
    disable_when_zoomed = false
}

vim.keymap.set('n', "<C-s>h", nvim_tmux_nav.NvimTmuxNavigateLeft)
vim.keymap.set('n', "<C-s>j", nvim_tmux_nav.NvimTmuxNavigateDown)
vim.keymap.set('n', "<C-s>k", nvim_tmux_nav.NvimTmuxNavigateUp)
vim.keymap.set('n', "<C-s>l", nvim_tmux_nav.NvimTmuxNavigateRight)
