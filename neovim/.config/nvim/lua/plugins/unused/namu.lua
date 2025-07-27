return {
    "bassamsdata/namu.nvim",
    opts = {
        global = {},
        namu_symbols = {
            options = {},
        },
    },
    keys = { "<leader>al", "<leader>aw" },
    config = function(_, opts)
        require("namu").setup(opts)
        vim.keymap.set("n", "<leader>al", ":Namu symbols<cr>", {
            desc = "Jump to LSP symbol",
            silent = true,
        })
        vim.keymap.set("n", "<leader>aw", ":Namu workspace<cr>", {
            desc = "LSP Symbols - Workspace",
            silent = true,
        })
    end,
}
