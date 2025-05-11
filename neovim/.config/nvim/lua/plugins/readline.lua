return {
    "assistcontrol/readline.nvim",
    dev = true,
    event = "VeryLazy",
    keys = {
        {
            mode = { "t", "c" },
            "<C-a>",
            function()
                require("readline").beginning_of_line()
            end,
        },
        {
            mode = { "t", "c" },
            "<C-e>",
            function()
                require("readline").end_of_line()
            end,
        },
        {
            mode = { "t", "c" },
            "<C-w>",
            function()
                require("readline").unix_word_rubout()
            end,
        },
        {
            mode = { "t", "c" },
            "<C-u>",
            function()
                require("readline").backward_kill_line()
            end,
        },
        { mode = { "t", "c" }, "<C-f>", "<Right>" },
        { mode = { "t", "c" }, "<C-b>", "<Left>" },
    },
}
