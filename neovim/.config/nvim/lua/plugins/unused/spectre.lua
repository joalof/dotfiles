return {
    "nvim-pack/nvim-spectre",
    dependencies = {
        'nvim-lua/plenary.nvim',
    },
    cmd = "Spectre",
    opts = { open_cmd = "noswapfile vnew" },
    keys = {
        {"<leader>fr", function() require("spectre").open() end},
    },
}
