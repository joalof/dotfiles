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

        vim.keymap.del({'o', 'x', 'n'}, 'g]')
        vim.keymap.del({'o', 'x', 'n'}, 'g[')
    end,
}
