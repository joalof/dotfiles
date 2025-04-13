return {
    "echasnovski/mini.ai",
    event = "VeryLazy",
    dependencies = { "nvim-treesitter-textobjects" },
    config = function()
        local ai = require("mini.ai")
        ai.setup({
            n_lines = 500,
            mappings = {
                goto_left = "",
                goto_right = "",
                around_next = "",
                inside_next = "",
                around_last = "",
                inside_last = "",
            },
            custom_textobjects = {
                o = ai.gen_spec.treesitter({
                    a = { "@block.outer", "@conditional.outer", "@loop.outer" },
                    i = { "@block.inner", "@conditional.inner", "@loop.inner" },
                }, {}),
                f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
                k = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
            },
        })
    end,
}
