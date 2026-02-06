return {
    "gbprod/substitute.nvim",
    opts = {
        yank_substituted_text = false,
        preserve_cursor_position = false,
    },
    keys = {
        {
            "s",
            function()
                return require("substitute").operator()
            end,
            desc = "Substitute operator",
        },
        {
            "ss",
            function()
                return require("substitute").line()
            end,
            desc = "Substitute line",
        },
        {
            "S",
            function()
                return require("substitute").eol()
            end,
            desc = "Substitute to EOL",
        },
        {
            "s",
            function()
                return require("substitute").visual()
            end,
            mode = "x",
            desc = "Substitute visual",
        },
    },
}
