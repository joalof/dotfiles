return {
    "SmiteshP/nvim-navbuddy",
    dependencies = {
        "SmiteshP/nvim-navic",
        "MunifTanjim/nui.nvim"
    },
    opts = function()
        local actions = require('nvim-navbuddy.actions')
        return {
            lsp = {auto_attach = true},
            mappings={['<C-j>'] = actions.select()}
        }
    end,
}
