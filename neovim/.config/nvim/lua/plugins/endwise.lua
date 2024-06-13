return {
    "RRethy/nvim-treesitter-endwise",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    dev = true,
    ft = {'lua', 'julia', 'vimscript', 'bash', 'ruby', 'elixir', 'fish'},
    config = function()
        local opts = {}
        opts["endwise"] = { enable = true }
    require("nvim-treesitter.configs").setup(opts)
    end,
}
