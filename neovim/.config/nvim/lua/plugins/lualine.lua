return {
    'nvim-lualine/lualine.nvim',
    dependencies = {'nvim-tree/nvim-web-devicons', lazy = true},
    opts = {
        sections = {
            lualine_c = {
                {'filename', path = 1},
            },
        },
    },
}
