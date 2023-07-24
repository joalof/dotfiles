return {
    "SmiteshP/nvim-navbuddy",
    dependencies = {
        "SmiteshP/nvim-navic",
        "MunifTanjim/nui.nvim"
    },
    config = function()
        local navbuddy = require('nvim-navbuddy')
        local actions = require('nvim-navbuddy.actions')
        navbuddy.setup({
            lsp = {auto_attach = true},
            mappings={['<C-j>'] = actions.select()}
        })
    end
}
