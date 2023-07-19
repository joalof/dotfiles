return {
    'goolord/alpha-nvim',
    event = "VimEnter",
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function ()
        local alpha = require('alpha')
        alpha.setup(require('alpha.themes.theta').config)
    end
}
