return {
    "mfussenegger/nvim-dap",
    dependencies = {
        {
            "rcarriga/nvim-dap-ui",
            keys = {
                { "<leader>du", function() require("dapui").toggle({ }) end},
                { "<leader>de", function() require("dapui").eval() end, mode = {"n", "v"} },
            },
            config = function()
                local dap = require("dap")
                local dapui = require("dapui")
                dapui.setup({
                    mappings = {
                        expand = { "<CR>", "<c-j>"},
                        open = "o",
                        remove = "d",
                        edit = "e",
                        repl = "r",
                        toggle = "t",
                    },
                })
                dap.listeners.after.event_initialized["dapui_config"] = function()
                    dapui.open({})
                end
                dap.listeners.before.event_terminated["dapui_config"] = function()
                    dapui.close({})
                end
                dap.listeners.before.event_exited["dapui_config"] = function()
                    dapui.close({})
                end
            end,
        },
        {
            "theHamsta/nvim-dap-virtual-text",
            opts = {},
        },
        -- mason.nvim integration
        {
            "jay-babu/mason-nvim-dap.nvim",
            dependencies = "mason.nvim",
            cmd = { "DapInstall", "DapUninstall" },
            opts = {
                -- Makes a best effort to setup the various debuggers with
                -- reasonable debug configurations
                automatic_installation = true,

                -- You can provide additional configuration to the handlers,
                -- see mason-nvim-dap README for more information
                handlers = {},

                -- Update this to ensure that you have the debuggers for the langs you want
                ensure_installed = {},
            },
        },
        {
            'HiPhish/debugpy.nvim',
            cmd = {'Debugpy'},
        },
    },
    keys = {
        {
            "<leader>dB",
            function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end,
            desc = "DAP: Breakpoint Condition"
        },
        { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
        -- { "<leader>dg", function() require("dap").goto_() end, desc = "Go to line (no execute)" },

        { "<leader>dj", function() require("dap").step_over() end, desc = "DAP: Step over" },
        { "<leader>dk", function() require("dap").step_back() end, desc = "DAP: Step back" },
        { "<leader>dl", function() require("dap").step_into() end, desc = "DAP: Step into" },
        { "<leader>dh", function() require("dap").step_out() end, desc = "DAP: Step out" },
        { "<leader>dn", function() require("dap").down() end, desc = "DAP: Frame Down"},
        { "<leader>dp", function() require("dap").up() end, desc = "DAP: Up" },
        { "<leader>dx", function() require("dap").terminate() end, desc = "DAP: Terminate" },

        { "<leader>dc", function() require("dap").continue() end, desc = "DAP: Continue" },
        { "<leader>dr", function() require("dap").restart() end, desc = "DAP: Toggle REPL" },

        -- { "<leader>dp", function() require("dap").pause() end, desc = "Pause" },
        -- { "<leader>ds", function() require("dap").session() end, desc = "Session" },
        -- { "<leader>dl", function() require("dap").run_last() end, desc = "Run Last" },
        -- { "<leader>dw", function() require("dap.ui.widgets").hover() end, desc = "Widgets" },
    },
    config = function()
        vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })
        local signs = {
            DapBreakpoint = {text='●', texthl='LspDiagnosticsDefaultError'},
            DapLogPoint = {text='◉', texthl='LspDiagnosticsDefaultError'},
            DapStopped = {text='🞂', texthl='LspDiagnosticsDefaultInformation', linehl='CursorLine'},
        }
        for sign, options in pairs(signs) do
            vim.fn.sign_define(sign, options)
        end
    end,
}
