local function set_dap_keymaps()
    local tmpmap = require('utils.tmpmap')
    -- tmpmap.set(
    --     'n',
    --     "<leader>dB",
    --     function()require("dap").set_breakpoint(vim.fn.input("Breakpoint condition:"))end,
    --     { desc = "DAP: Breakpoint Condition" }
    -- )
    tmpmap.set('n', "M", function() require("dap").toggle_breakpoint() end, { desc = "Toggle Breakpoint" })
    tmpmap.set('n', "J", function() require("dap").step_over() end, { desc = "DAP: Step over" })
    tmpmap.set('n', "K", function() require("dap").step_back() end, { desc = "DAP: Step back" })
    tmpmap.set('n', "L", function() require("dap").step_into() end, { desc = "DAP: Step into" })
    tmpmap.set('n', "H", function() require("dap").step_out() end, { desc = "DAP: Step out" })
    tmpmap.set('n', "N", function() require("dap").down() end, { desc = "DAP: Frame down" })
    tmpmap.set('n', "P", function() require("dap").up() end, { desc = "DAP: Frame up" })
    tmpmap.set('n', "X", function() require("dap").terminate() end, { desc = "DAP: Terminate" })
    tmpmap.set('n', "C", function() require("dap").continue() end, { desc = "DAP: Continue" })
    tmpmap.set('n', "R", function() require("dap").restart() end, { desc = "DAP: Toggle REPL" })
    -- { "<leader>dg", function() require("dap").goto_() end, desc = "Go to line (no execute)" },
    -- { "<leader>dp", function() require("dap").pause() end, desc = "Pause" },
    -- { "<leader>ds", function() require("dap").session() end, desc = "Session" },
    -- { "<leader>dl", function() require("dap").run_last() end, desc = "Run Last" },
    -- { "<leader>dw", function() require("dap.ui.widgets").hover() end, desc = "Widgets" },
end

local function del_dap_keymaps()
    local tmpmap = require('lib.tmpmap')
    -- tmpmap.set(
    --     'n',
    --     "<leader>dB",
    --     function()require("dap").set_breakpoint(vim.fn.input("Breakpoint condition:"))end,
    --     { desc = "DAP: Breakpoint Condition" }
    -- )
    tmpmap.del('n', "M")
    tmpmap.del('n', "J")
    tmpmap.del('n', "K")
    tmpmap.del('n', "L")
    tmpmap.del('n', "H")
    tmpmap.del('n', "N")
    tmpmap.del('n', "P")
    tmpmap.del('n', "X")
    tmpmap.del('n', "C")
    tmpmap.del('n', "R")
    -- { "<leader>dg", function() require("dap").goto_() end, desc = "Go to line (no execute)" },
    -- { "<leader>dp", function() require("dap").pause() end, desc = "Pause" },
    -- { "<leader>ds", function() require("dap").session() end, desc = "Session" },
    -- { "<leader>dl", function() require("dap").run_last() end, desc = "Run Last" },
    -- { "<leader>dw", function() require("dap.ui.widgets").hover() end, desc = "Widgets" },
end

return {
    "mfussenegger/nvim-dap",
    dependencies = {
        "rcarriga/nvim-dap-ui",
        {
            "jay-babu/mason-nvim-dap.nvim",
            dependencies = "mason.nvim",
            cmd = { "DapInstall", "DapUninstall" },
            opts = {
                automatic_installation = true,
                -- You can provide additional configuration to the handlers,
                -- see mason-nvim-dap README for more information
                handlers = {},
                ensure_installed = {},
            }
        },
        { "theHamsta/nvim-dap-virtual-text", opts = {},  },
        {
            "LiadOz/nvim-dap-repl-highlights",
            dependencies = {
                "nvim-treesitter/nvim-treesitter",
            },
            build = ":TSInstall dap_repl",
            opts = {},
        },
    },
    keys = {
        '<leader>db',
        '<leader>de',
        '<leader>dtm',
        '<leader>dtc',
    },
    config = function()
        -- dap stuff
        vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })
        local signs = {
            DapBreakpoint = { text = "●", texthl = "LspDiagnosticsDefaultError" },
            DapLogPoint = { text = "◉", texthl = "LspDiagnosticsDefaultError" },
            DapStopped = { text = "🞂", texthl = "LspDiagnosticsDefaultInformation", linehl = "CursorLine" },
        }
        for sign, options in pairs(signs) do
            vim.fn.sign_define(sign, options)
        end

        -- dapui stuff
        local dap = require("dap")
        local dapui = require("dapui")
        dapui.setup({
            mappings = {
                expand = { "<CR>", "<c-j>" },
                open = "o",
                remove = "d",
                edit = "e",
                repl = "r",
                toggle = "t",
            },
        })
        -- dap.listeners.after.event_initialized["dapui_config"] = function()
        --     dapui.open({})
        -- end
        -- dap.listeners.before.event_terminated["dapui_config"] = function()
        --     dapui.close({})
        -- end
        -- dap.listeners.before.event_exited["dapui_config"] = function()
        --     dapui.close({})
        -- end

        vim.keymap.set('n', "<leader>db", function() require("dap").toggle_breakpoint() end, { desc = "Toggle Breakpoint" })

        vim.keymap.set({ "n", "v" }, "<leader>de", function() require("dapui").eval() end)

        local ui_active = false
        vim.keymap.set(
            { "n" },
            "<leader>du",
            function()
                require("dapui").toggle()
                ui_active = not ui_active
                if ui_active then
                    set_dap_keymaps()
                else
                    del_dap_keymaps()
                end
            end
        )
    end,
}
