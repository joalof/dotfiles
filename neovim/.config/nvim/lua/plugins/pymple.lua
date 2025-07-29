return {
    "alexpasmantier/pymple.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        "stevearc/dressing.nvim",
        "nvim-tree/nvim-web-devicons",
        -- file modifications apps
        'stevearc/oil.nvim',
    },
    build = ":PympleBuild",
    cmd = 'Oil',
    config = function()
        require("pymple").setup()
    end,
}
