return {
    "max397574/better-escape.nvim",
    config = function()
        require("better_escape").setup({
            timeout = vim.o.timeoutlen, -- after `timeout` passes, you can press the escape key and the plugin will ignore it
            mappings = {
                i = {
                    j = {
                        -- These can all also be functions
                        k = "<Esc>",
                    },
                },
                -- c = {
                --     j = {
                --         k = "<C-c>",
                --     },
                -- },
                -- t = {
                --     j = {
                --         k = "<C-\\><C-n>",
                --     },
                -- },
            },
        })
        -- vim.keymap.set('o', 'jk', '<esc>')
    end,
}
