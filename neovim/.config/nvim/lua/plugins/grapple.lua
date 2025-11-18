return {
    "cbochs/grapple.nvim",
    opts = {
        -- scope = "git_branch",
    },
    event = { "BufReadPost", "BufNewFile" },
    cmd = "Grapple",
    config = function(_, opts)
        local grapple = require('grapple')
        grapple.setup(opts)

        --
        vim.keymap.set('n', 'm', function()
            grapple.tag({name=vim.fn.expand('%:t')})
        end)
        vim.keymap.set('n', 'L', function()
            grapple.cycle_tags("next")
        end)
        vim.keymap.set('n', 'H', function()
            grapple.cycle_tags("previous")
        end)
        vim.keymap.set('n', 'M', function()
            grapple.toggle_tags()
        end)
    end,
}
