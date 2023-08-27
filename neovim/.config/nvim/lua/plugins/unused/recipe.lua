return {
    'ten3roberts/recipe.nvim',
    dependencies = {
        'nvim-lua/plenary.nvim',
        "MunifTanjim/nui.nvim",
    },
    config = function()
        require('recipe').setup({
            term = {
                height = 0.5,
                width = { 120, 0.5 },
                kind = "smart",
                border = "none",
                global_terminal = true,
            },
            custom_recipes = {
                filetypes = {
                    python = {
                        run = {
                            cmd = "python %",
                            kind = 'build',
                            components = {
                                qf = { open = 'auto' },
                            },
                        },
                    },
                },
            },
        })
        -- vim.keymap.set('n', '<leader>mm', function() require('recipe').bake('run') end)
        -- local my_recipe= {
        --     cmd = "python %",
        --     components = {
        --         qf = {open = 'auto'},
        --     },
        -- }
        -- vim.keymap.set('n', '<leader>mm', function() require("recipe").execute(my_recipe):focus({kind='float'}) end)
    end
}
