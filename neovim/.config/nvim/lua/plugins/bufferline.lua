return {
    "akinsho/bufferline.nvim",
    version = '*',
    dependencies = {'nvim-tree/nvim-web-devicons'},
    config = function()
        local bufferline = require('bufferline')
        bufferline.setup({
            options = {
                diagnostics = "nvim_lsp",
                always_show_bufferline = false,
                separator_style = 'slant',
                mode = 'tabs',
            },
        })
    end
}
