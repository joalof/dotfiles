return {
    "rareitems/printer.nvim",
    keys = {'<leader>dp'},
    config = function()
        require("printer").setup({
            keymap = "<leader>dp",
        })
    end,
}
