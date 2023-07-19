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
    },
    keys = {
        { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = "Breakpoint Condition" },
        { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
        { "<leader>dc", function() require("dap").continue() end, desc = "Continue" },
        -- { "<leader>dc", function() require("dap").run_to_cursor() end, desc = "Run to Cursor" },
        { "<leader>dg", function() require("dap").goto_() end, desc = "Go to line (no execute)" },
        { "<leader>dl", function() require("dap").step_into() end, desc = "Step Into" },
        { "<leader>dj", function() require("dap").down() end, desc = "Down" },
        { "<leader>dk", function() require("dap").up() end, desc = "Up" },
        -- { "<leader>dl", function() require("dap").run_last() end, desc = "Run Last" },
        { "<leader>dh", function() require("dap").step_out() end, desc = "Step Out" },
        { "<leader>dn", function() require("dap").step_over() end, desc = "Step Over" },
        { "<leader>dp", function() require("dap").pause() end, desc = "Pause" },
        { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
        { "<leader>ds", function() require("dap").session() end, desc = "Session" },
        { "<leader>dx", function() require("dap").terminate() end, desc = "Terminate" },
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
