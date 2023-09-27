return {
    "ThePrimeagen/refactoring.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
    },
    cmd = { "Refactor" },
    keys = {
        {
            "<leader>ap",
            function()
                require("refactoring").debug.print_var()
            end,
            mode = { "x", "n" },
            desc = "Insert print var",
        },
        {
            "<leader>ac",
            function()
                require("refactoring").debug.cleanup({})
            end,
            desc = "Clean inserted prints",
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
