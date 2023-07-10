return {
    'knubie/vim-kitty-navigator',
    -- branch = 'fix-multikey-mappings',
    build = 'cp ./*.py ~/.config/kitty/',
    config = function ()
        vim.g.kitty_navigator_no_mappings = 1
        local opts = {silent = true}
        vim.keymap.set('n', '<C-s>l', ':KittyNavigateRight<cr>', opts)
        vim.keymap.set('n', '<C-s>h', ':KittyNavigateLeft<cr>', opts)
        vim.keymap.set('n', '<C-s>k', ':KittyNavigateUp<cr>', opts)
        vim.keymap.set('n', '<C-s>j', ':KittyNavigateDown<cr>', opts)
    end,
}
