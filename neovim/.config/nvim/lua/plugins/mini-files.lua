return {
    'echasnovski/mini.files',
    version = false,
    event = 'VeryLazy',
    config = function()
        require('mini.files').setup()
        vim.keymap.set('n', '<leader>fe', require('mini.files').open)
    end,
}
