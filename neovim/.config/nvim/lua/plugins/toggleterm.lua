return {
    "akinsho/toggleterm.nvim",
    version = "*",
    opts = {},
    commands = { "ToggleTerm" },
    keys = {
        {
            "<leader>rt",
            function()
                require("toggleterm").toggle_command()
            end,
        },
    },
}
