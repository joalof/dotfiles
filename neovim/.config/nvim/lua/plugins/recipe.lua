return {
    'ten3roberts/recipe.nvim',
    dependencies = {
        'nvim-lua/plenary.nvim',
        "MunifTanjim/nui.nvim",
    },
    config = function()
        require('recipe').setup({
            custom_recipes = {
                filetypes = {
                    python = {
                        run = {
                            cmd = "python %",
                            kind = 'term',
                            components = {
                                qf = {open = 'auto'},
                            },
                        },
                    },
                },
            },
        })
        vim.keymap.set('n', '<leader>mm', function() require('recipe').bake('run', {kind = 'float'}) end)
        -- local my_recipe= {
        --     cmd = "python %",
        --     components = {
        --         qf = {open = 'auto'},
        --     },
        -- }
        -- vim.keymap.set('n', '<leader>mm', function() require("recipe").execute(my_recipe):focus({kind='float'}) end)
    end
}
