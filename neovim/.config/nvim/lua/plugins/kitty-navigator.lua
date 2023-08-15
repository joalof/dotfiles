return {
    'knubie/vim-kitty-navigator',
    build = 'cp ./*.py ~/.config/kitty/',
    init = function()
        vim.g.kitty_navigator_no_mappings = 1
    end,
    config = function ()
        local opts = {silent = true}
        vim.keymap.set('n', '<C-s>l', ':KittyNavigateRight<cr>', opts)
        vim.keymap.set('n', '<C-s>h', ':KittyNavigateLeft<cr>', opts)
        vim.keymap.set('n', '<C-s>k', ':KittyNavigateUp<cr>', opts)
        vim.keymap.set('n', '<C-s>j', ':KittyNavigateDown<cr>', opts)
    end,
}
