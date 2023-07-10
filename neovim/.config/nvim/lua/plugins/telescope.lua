return {
    'nvim-telescope/telescope.nvim', tag = '0.1.2',
    dependencies = {
        'nvim-lua/plenary.nvim',
        {'nvim-telescope/telescope-fzf-native.nvim', build = 'make'},
    },
    config = function()
        require('telescope').setup({
            pickers = {
                git_files = {
                    mappings = {
                        i = {
                            ['<C-j>'] = require('telescope.actions').select_default,
                       },
                        n = {
                            ['<C-j>'] = require('telescope.actions').select_default,
                        },

                    },
                },
            },
            require('telescope').load_extension('fzf')
        })
        local builtin = require('telescope.builtin')
        vim.keymap.set('n', '<leader>ff', builtin.git_files)
        vim.keymap.set('n', '<leader>fh', builtin.help_tags)
    end,
}
