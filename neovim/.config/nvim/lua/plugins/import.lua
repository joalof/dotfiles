return {
    "piersolenski/import.nvim",
    dependencies = {
        "folke/snacks.nvim",
    },
    opts = {
        picker = "snacks",
    },
    keys = {
        {
            "<leader>fi",
            function()
                require("import").pick()
            end,
            desc = "Import",
        },
    },
}
