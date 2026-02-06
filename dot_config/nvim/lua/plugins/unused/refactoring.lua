return {
    "ThePrimeagen/refactoring.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
    },
    cmd = { "Refactor" },
    keys = {
        {
            "<leader>apv",
            function()
                require("refactoring").debug.print_var()
            end,
            mode = { "x", "n" },
            desc = "Print variable",
        },
        {
            "<leader>apc",
            function()
                require("refactoring").debug.cleanup({})
            end,
            desc = "Clean inserted prints",
        },
        {
            "<leader>apf",
            function()
                require("refactoring").debug.printf({})
            end,
            desc = "Print to mark calls",
        },
    },
    opts = {
        print_var_statements = {
            python = {
                'print(f"%s {%s}")',
            },
        },
    },
}
