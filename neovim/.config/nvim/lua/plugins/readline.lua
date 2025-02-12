return {
    "joalof/readline.nvim",
    dev = true,
    event = "VeryLazy",
    keys = {
        {
            mode = { "!" },
            "<C-a>",
            function()
                require("readline").beginning_of_line()
            end,
        },
        {
            mode = { "!" },
            "<C-e>",
            function()
                require("readline").end_of_line()
            end,
        },
        {
            mode = { "!" },
            "<C-w>",
            function()
                require("readline").unix_word_rubout()
            end,
        },
        {
            mode = { "!" },
            "<C-u>",
            function()
                require("readline").backward_kill_line()
            end,
        },
        { mode = { "!" }, "<C-f>", "<Right>" },
        { mode = { "!" }, "<C-b>", "<Left>" },
    },
}
