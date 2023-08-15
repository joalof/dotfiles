return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "onsails/lspkind-nvim",
        {
            "folke/neodev.nvim",
            opts = {
                library = { plugins = { "neotest" }, types = true },
            }
        },
    },
    config = function()
        require("plugins.lsp.setup")
    end,
}
