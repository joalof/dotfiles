return {
    "windwp/nvim-autopairs",
    event = 'VeryLazy',
    config = function()
        require("nvim-autopairs").setup{
            map_cr = true,
            map_bs = true,
        }
    end,
}
