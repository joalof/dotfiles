return {
    "rareitems/printer.nvim",
    config = function()
        require("printer").setup({
            keymap = "<leader>dp",
        })
    end,
}
