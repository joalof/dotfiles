return {
    'nvim-telescope/telescope.nvim', tag = '0.1.2',
    dependencies = {
        'nvim-lua/plenary.nvim',
        {'nvim-telescope/telescope-fzf-native.nvim', build = 'make'},
        {"ahmedkhalf/project.nvim"},
    },
    config = function()
        require('telescope').setup({
            defaults = {
                mappings = {
                    i = {
                        ['<C-j>'] = require('telescope.actions').select_default,
                    },
                    n = {
                        ['<C-j>'] = require('telescope.actions').select_default,
                        ['<C-c>'] = require('telescope.actions').close,
                    },
                },
            },
        })
        require('telescope').load_extension('fzf')

        require('project_nvim').setup({})
        require('telescope').load_extension('projects')
        local builtin = require('telescope.builtin')

        -- get the project root dir or fallback to cwd
        local function get_root_dir()
            local root = require('project_nvim.project').get_project_root()
            if root ~= nil then
                return root
            else
                return vim.fn.getcwd()
            end
        end
        vim.keymap.set(
            'n',
            '<leader>ff',
            function() builtin.find_files({cwd = get_root_dir(), hidden=true}) end
        )
        vim.keymap.set('n', '<leader>fh', builtin.help_tags)
        vim.keymap.set(
            'n',
            '<leader>fp',
            require('telescope').extensions.projects.projects
        )
        vim.keymap.set(
            'n',
            '<leader>fn',
            function()
                builtin.find_files(
                    {cwd = vim.fn.environ()['HOME'] .. '/.config/nvim', hidden=true}
                )
            end
        )
    end,
}
