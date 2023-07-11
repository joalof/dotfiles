return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "onsails/lspkind-nvim",
        { "folke/neodev.nvim", config = true },
    },
    config = function()
        require("plugins.lsp.setup")
    end,
}