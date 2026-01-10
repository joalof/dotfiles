return {
    "MagicDuck/grug-far.nvim",
    config = function()
        require("grug-far").setup({})
        vim.keymap.set("n", "<leader>as", function()
            require("grug-far").open({ transient = true })
        end)
    end,
}
