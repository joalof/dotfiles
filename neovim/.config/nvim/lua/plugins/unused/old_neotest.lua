return {
    "nvim-neotest/neotest",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
        "antoinemadec/FixCursorHold.nvim",
        "nvim-neotest/neotest-python",
    },
    keys = { '<leader>tn', '<leader>tf' },
    config = function()
        require('neotest').setup({
            adapters = {
                require("neotest-python")({}),
            },
            quickfix = {
                enabled = true,
                open = true,
            },
            -- consumers = {
            --     always_open_output = function(client)
            --         local async = require("neotest.async")
            --
            --         client.listeners.results = function(adapter_id, results)
            --             local file_path = async.fn.expand("%:p")
            --             local row = async.fn.getpos(".")[2] - 1
            --             local position = client:get_nearest(file_path, row, {})
            --             if not position then
            --                 return
            --             end
            --             local pos_id = position:data().id
            --             if not results[pos_id] then
            --                 return
            --             end
            --             require('neotest').output.open({ position_id = pos_id, adapter = adapter_id })
            --         end
            --     end,
            -- },
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
            '<leader>tx',
            function()
                require('neotest').run.stop()
            end
        )
    end
}
