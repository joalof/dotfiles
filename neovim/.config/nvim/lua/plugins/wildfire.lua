return {
    "sustech-data/wildfire.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
        require("wildfire").setup({
            keymaps = {
                init_selection = "<C-l>",
                node_incremental = "<C-l>",
                node_decremental = "<C-h>",
            },
        })
    end,
}
