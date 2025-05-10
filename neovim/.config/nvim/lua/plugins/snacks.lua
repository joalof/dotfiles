return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
        bigfile = { enabled = true },
        dashboard = { enabled = false },
        explorer = { enabled = false },
        indent = { enabled = false },
        input = { enabled = true },
        notifier = { enabled = false, timeout = 3000},
        picker = {
            enabled = true,
            win = {
                -- input window
                input = {
                    keys = {
                        ["<c-j>"] = { "confirm", mode = {"i", "n"} },
                        ["<c-c>"] = { "cancel", mode = {"i", "n"} },
                    },
                },
            },
        },
        quickfile = { enabled = true },
        scope = { enabled = false },
        scroll = { enabled = false },
        statuscolumn = { enabled = false },
        words = { enabled = false },
        styles = {
            notification = {
                -- wo = { wrap = true } -- Wrap notifications
            }
        }
    },
    keys = {
        -- Top Pickers & Explorer
        -- find
        { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
        { "<leader>fn", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
        { "<leader>ff"},
        { "<leader>fp", function() Snacks.picker.projects() end, desc = "Projects" },
        -- git
        { "<leader>fgb", function() Snacks.picker.git_branches() end, desc = "Git Branches" },
        -- search
        { '<leader>fs', function() Snacks.picker.search_history() end, desc = "Search History" },
        { "<leader>fc", function() Snacks.picker.command_history() end, desc = "Command History" },
        { "<leader>fk", function() Snacks.picker.commands() end, desc = "Commands" },
        { "<leader>fd", function() Snacks.picker.diagnostics_buffer() end, desc = "Buffer Diagnostics" },
        { "<leader>fh", function() Snacks.picker.help() end, desc = "Help Pages" },
        { "<leader>fm", function() Snacks.picker.man() end, desc = "Man Pages" },
        { "<leader>fu", function() Snacks.picker.undo() end, desc = "Undo History" },
        -- LSP
        { "<leader>af", function() Snacks.rename.rename_file() end, desc = "Rename File" },
    },
    config = function(_, opts)
        local Snacks = require('snacks')
        Snacks.setup(opts)

        vim.keymap.set('n', "<leader>ff", function() Snacks.picker.files(
            {
                cwd = require('extensions.project').get_root('cwd'),
                matcher = {
                    frecency = true,
                    sort_empty = true,
                },
            }
        ) end, { desc = "Find project files" })
    end
}
