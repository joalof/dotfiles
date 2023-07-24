return {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    config = function()
        local Util = require('flash.util')
        local opts = {
            actions = {
                [Util.t("<C-j>")] = function(state, char) state:jump() return false end
            }
        }
        vim.keymap.set({ 'n', 'x', 'o' }, 's', function() require('flash').jump(opts) end)
    end,
}
