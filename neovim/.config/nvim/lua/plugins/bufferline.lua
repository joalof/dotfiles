return {
    "akinsho/bufferline.nvim",
    dependencies = {
        {'ThePrimeagen/harpoon'},
    },
    config = function()
        local bufferline = require('bufferline')
        bufferline.setup({
            options = {
                diagnostics = "nvim_lsp",
                always_show_bufferline = true,
                separator_style = 'slant',
                -- custom_filter = function(buf_num, buf_nums)
                --     vim.notify("I'm a custom filter")
                -- end
            },
        })
    end
}
