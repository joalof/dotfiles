return {
    "mfussenegger/nvim-dap",
    dependencies = {
        "debugloop/layers.nvim",
    },
    config = function()
        local dap = require('dap')
        
        vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })
        local signs = {
            DapBreakpoint = { text = "●", texthl = "LspDiagnosticsDefaultError" },
            DapLogPoint = { text = "◉", texthl = "LspDiagnosticsDefaultError" },
            DapStopped = { text = "🞂", texthl = "LspDiagnosticsDefaultInformation", linehl = "CursorLine" },
        }
        for sign, options in pairs(signs) do
            vim.fn.sign_define(sign, options)
        end

        local layers = require('layers')
        local debug_mode = layers.mode.new('debug_mode') -- global, accessible from anywhere
        
        debug_mode:auto_show_help()
        
        -- for statuslines
        debug_mode:add_hook(function(_)
            vim.cmd("redrawstatus") -- update status line when toggled
        end)
        
        -- nvim-dap hooks
        dap.listeners.after.event_initialized["debug_mode"] = function()
            debug_mode:activate()
        end
        dap.listeners.before.event_terminated["debug_mode"] = function()
            debug_mode:deactivate()
        end
        dap.listeners.before.event_exited["debug_mode"] = function()
            debug_mode:deactivate()
        end
        
        -- map our custom mode keymaps
        debug_mode:keymaps({
            n = {
                { "r", function() dap.run_to_cursor() end, { desc = "run to cursor" } },
                { "R", function() dap.run_last() end, { desc = "run last" } },
                { "s", function() dap.session() end, { desc = "session" } },
                { "t", function() dap.toggle_breakpoint() end, { desc = "toggle breakpoint" } },
                { "<c-h>", function() dap.step_out() end, { desc = "step out" } },
                { "<c-j>", function() dap.step_over() end, { desc = "step over" } },
                { "<c-k>", function() dap.step_back() end, { desc = "step back" } },
                { "<c-l>", function() dap.step_into() end, { desc = "step into" } },
                { "c", function() dap.continue() end, { desc = "continue" } },
                -- { -- this acts as a way to leave debug mode without quitting the debugger
                --     "<esc>",
                --     function()
                --         debug_mode:deactivate()
                --     end,
                --     { desc = "exit" },
                -- },
            },
        })
    end,
}
