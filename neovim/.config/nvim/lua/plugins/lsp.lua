return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "onsails/lspkind.nvim",
    },
    config = function()
        require("plugins.lsp.init")
    end,
}
