return {
    "stevearc/overseer.nvim",
    commit = '819bb88b47a6ec94c7fb6e0967fc7af617980d0b',
    dependencies = { "akinsho/toggleterm.nvim", version = "*", opts = {} },
    cmd = { "OverseerRun", "OverseerToggle" },
    keys = { "<leader>rr" },
    opts = {
        templates = { "builtin" },
    },
    config = function(_, opts)
        local overseer = require("overseer")
        overseer.setup(opts)

        local runner = require('utils.runner')

        -- set keymap to run in toggleterm and autoclose
        vim.keymap.set("n", "<leader>rr", function()
            runner.run()
        end, { silent = true })
    end,
}
