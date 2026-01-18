return {
    "mfussenegger/nvim-dap",
    dependencies = {
        "debugloop/layers.nvim",
        "mfussenegger/nvim-dap-python",
        "igorlfs/nvim-dap-view",
    },
    keys = { "<leader>dm" },
    config = function()
        local dap = require("dap")

        vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })
        local icons = require("icons")
        local signs = {
            DapBreakpoint = { text = icons.dap.Breakpoint, texthl = "NvimDapViewControlPause" },
            DapLogPoint = { text = icons.dap.LogPoint, texthl = "NvimDapViewWatchError" },
            DapStopped = { text = icons.dap.Stopped, texthl = "NvimDapViewString", linehl = "CursorLine" },
        }
        for sign, options in pairs(signs) do
            vim.fn.sign_define(sign, options)
        end

        -- dap view
        local dap_view = require("dap-view")
        dap_view.setup({
            -- Enable "smart" layout that uses a vertical layout if there's only
            -- a single window in the current tab
            windows = {
                position = function()
                    return vim.tbl_count(vim.iter(vim.api.nvim_tabpage_list_wins(0))
                        :filter(function(win)
                            local buf = vim.api.nvim_win_get_buf(win)
                            -- extui has some funky windows
                            return vim.bo[buf].buftype == ""
                        end)
                        :totable()) > 1 and "below" or "right"
                end,
                terminal = {
                    -- `pos` is the position for the regular window
                    position = function(pos)
                        return pos == "below" and "right" or "below"
                    end,
                },
            },
        })

        local layers = require("layers")
        local mode_name = "debug_mode"
        local debug_mode = layers.mode.new(mode_name) -- global, accessible from anywhere

        debug_mode:auto_show_help()

        -- for statuslines
        debug_mode:add_hook(function(_)
            vim.cmd("redrawstatus") -- update status line when toggled
        end)

        require("dap-python").setup("python3")

        -- map our custom mode keymaps
        debug_mode:keymaps({
            n = {
                {
                    "r",
                    function()
                        dap.run_to_cursor()
                    end,
                    { desc = "run to cursor" },
                },
                {
                    "R",
                    function()
                        dap.run_last()
                    end,
                    { desc = "run last" },
                },
                {
                    "s",
                    function()
                        dap.session()
                    end,
                    { desc = "session" },
                },
                {
                    "t",
                    function()
                        dap.toggle_breakpoint()
                    end,
                    { desc = "toggle breakpoint" },
                },
                {
                    "<c-h>",
                    function()
                        dap.step_out()
                    end,
                    { desc = "step out" },
                },
                {
                    "<c-j>",
                    function()
                        dap.step_over()
                    end,
                    { desc = "step over" },
                },
                {
                    "<c-k>",
                    function()
                        dap.step_back()
                    end,
                    { desc = "step back" },
                },
                {
                    "<c-l>",
                    function()
                        dap.step_into()
                    end,
                    { desc = "step into" },
                },
                {
                    "c",
                    function()
                        dap.continue()
                    end,
                    { desc = "continue" },
                },
                {
                    "x",
                    function()
                        dap.terminate()
                    end,
                    { desc = "terminate" },
                },
            },
        })

        vim.keymap.set("n", "<leader>dm", function()
            dap.terminate()
            debug_mode:toggle()
            dap_view.toggle()
        end)
    end,
}
