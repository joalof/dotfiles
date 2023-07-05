return {
    'nvim-lualine/lualine.nvim',
    dependencies = {'kyazdani42/nvim-web-devicons', lazy = true},
    config = function()
        require('lualine').setup()
    end,
}
