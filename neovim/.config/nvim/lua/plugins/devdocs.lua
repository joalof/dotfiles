return {
    "luckasRanarison/nvim-devdocs",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim",
        "nvim-treesitter/nvim-treesitter",
    },
    cmd = {
        'DevdocsFetch',
        'DevdocsInstall',
        'DevdocsUninstall',
        'DevdocsUpdate',
        'DevdocsUpdateAll',
        'DevdocsOpen',
        'DevdocsOpenFloat',
        'DevdocsOpenCurrent',
        'DevdocsOpenCurrentFloat',
        'DevdocsToggle',
        'DevdocsKeywordprg',
    },
    opts = {
        -- previewer_cmd = "glow",
        -- cmd_args = { "-s", "dark", "-w", "80" },
        -- picker_cmd = true,
        -- picker_cmd_args = { "-p" },
    },
}
