return {
    "stevearc/conform.nvim",
    keys = { "<leader>af" },
    config = function()
        require("conform").setup({
            formatters_by_ft = {
                lua = { "stylua" },
                python = { "isort", "black" },
            },
        })
        vim.keymap.set("n", "<leader>af", function()
            require("conform").format({ async = true })
        end)
    end,
}
