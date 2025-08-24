return {
    "stevearc/overseer.nvim",
    dependencies = { "akinsho/toggleterm.nvim", version = "*", opts = {} },
    cmd = { "OverseerRun", "OverseerToggle" },
    keys = { "<leader>rr" },
    opts = {
        templates = { "builtin" },
    },
    config = function(_, opts)
        local overseer = require("overseer")
        overseer.setup(opts)

        local coderunner = require('extensions.coderunner')

        -- set keymap to run in toggleterm and autoclose
        vim.keymap.set("n", "<leader>rr", function()
            opts = {}
            coderunner.run(opts)
        end, { silent = true })
        vim.keymap.set("n", "<leader>rx", function()
            coderunner.abort_script()
        end, { silent = true })
    end,
}
