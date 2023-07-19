return {
    'echasnovski/mini.ai',
    event = "VeryLazy",
    dependencies = { "nvim-treesitter-textobjects" },
    config = function ()
        local ai = require('mini.ai')
        ai.setup({
            n_lines = 500,
            custom_textobjects = {
                o = ai.gen_spec.treesitter({
                    a = { "@block.outer", "@conditional.outer", "@loop.outer" },
                    i = { "@block.inner", "@conditional.inner", "@loop.inner" },
                }, {}),
                f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
                c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
            },
        })

        -- configs for cells
        -- local cells = require('lib.cells')
        -- cells.setup('%%')
        -- vim.keymap.set('n', ']d', cells.cursor_to_next_cell, {silent=true})
        -- vim.keymap.set('n', '[d', cells.cursor_to_previous_cell, {silent=true})
        -- mini_ai.setup({
        --     custom_textobjects = {
        --         d = cells.get_cell_region
        --     }
        -- })
        -- vim.keymap.del({'o', 'x', 'n'}, 'g]')
        -- vim.keymap.del({'o', 'x', 'n'}, 'g[')
    end,
}
