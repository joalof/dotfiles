return {
    "cbochs/grapple.nvim",
    opts = {
        scope = "git_branch",
    },
    event = { "BufReadPost", "BufNewFile" },
    cmd = "Grapple",
    config = function(_, opts)
        local grapple = require('grapple')
        grapple.setup(opts)

        local tabline_toggle = require("extensions.tabline").toggle

        vim.keymap.set('n', 'm', function()
            grapple.tag()
            tabline_toggle()
        end)
        vim.keymap.set('n', '<c-n>', function()
            grapple.cycle_tags("next")
        end)
        vim.keymap.set('n', '<c-p>', function()
            grapple.cycle_tags("previous")
        end)
        vim.keymap.set('n', 'M', function()
            grapple.toggle_tags()
            tabline_toggle()
        end)
    end,
}
