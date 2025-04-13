return {
    "folke/flash.nvim",
    keys = {"f", "F", "t", "T", "/", "?"},
    config = function()
        require("flash").setup({
            modes = {
                search = {
                    enabled = false,
                },
                char = {
                    config = function(opts)
                        -- autohide flash when in operator-pending mode
                        opts.autohide = vim.fn.mode(true):find("no")
                        and (vim.v.operator == "y" or vim.v.operator == "d" or vim.v.operator == "c")
                        -- disable jump labels when enabled and when using a count
                        opts.jump_labels = opts.jump_labels and vim.v.count == 0
                    end,
                },
            },
        })

        local Util = require("flash.util")
        local actions = {
            [Util.t("<C-j>")] = function(state, char)
                state:jump()
                return false
            end,
        }
        -- vim.keymap.set({ "n", "x", "o" }, "s", function()
        --     require("flash").jump({
        --         labels = "sdfgqwertyuopzxcvbnm",
        --         search = {
        --             max_length = 2,
        --             incremental = true,
        --             wrap = false,
        --         },
        --         actions = actions,
        --     })
        -- end,
    end,
}
