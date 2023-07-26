return {
    "nvim-neotest/neotest",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
        "antoinemadec/FixCursorHold.nvim",
        "nvim-neotest/neotest-python",
    },
    keys = {'<leader>tn', '<leader>tf'},
    config = function()
        require('neotest').setup({
            adapters = {
                require("neotest-python")({
                    dap = {justMyCode = true},
                }),
            },
        })
        vim.keymap.set(
            'n',
            '<leader>tn',
            function()
                require('neotest').run.run()
            end
        )
        vim.keymap.set(
            'n',
            '<leader>tf',
            function()
                require('neotest').run.run(vim.fn.expand("%"))
            end
        )
        vim.keymap.set(
            'n',
            '<leader>ts',
            function()
                require('neotest').run.stop()
            end
        )
    end
}
