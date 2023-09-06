return {
    "folke/flash.nvim",
    config = function()
        require("flash").setup({})

        local Util = require('flash.util')
        local actions = {
            [Util.t("<C-j>")] = function(state, char) state:jump() return false end
        }
        vim.keymap.set(
            { 'n', 'x', 'o' }, 's',
            function()
                require("flash").jump({
                    labels = "sdfgqwertyuopzxcvbnm",
                    search = {
                        max_length = 2,
                        incremental = true,
                    },
                    actions = actions,
                })
            end
        )

    end,
}
