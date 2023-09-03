return {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    keys = {
        { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle pin" },
        { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete non-pinned buffers" },
    },
    config = function()
        local bufferline = require('bufferline')
        bufferline.setup({
            options = {
                diagnostics = "nvim_lsp",
                always_show_bufferline = false,
                separator_style = 'slant',
            },
        })
    end
}
