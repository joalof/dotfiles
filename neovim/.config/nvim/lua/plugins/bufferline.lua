return {
    "akinsho/bufferline.nvim",
    event = {"TabNew"},
    -- keys = {
    --     { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle pin" },
    --     { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete non-pinned buffers" },
    -- },
    config = function()
        local bufferline = require('bufferline')
        bufferline.setup({
            options = {
                mode = "tabs",
                diagnostics = "nvim_lsp",
                always_show_bufferline = false,
                separator_style = 'slant',
            },
        })
    end
}
