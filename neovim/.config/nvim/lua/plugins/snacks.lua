return {
    "folke/snacks.nvim",
    priority = 1100,
    lazy = false,
    ---@type snacks.Config
    opts = {
        bigfile = { enabled = true },
        dashboard = { enabled = false },
        explorer = { enabled = false },
        indent = { enabled = false },
        input = { enabled = true },
        rename = { enabled = false },
        image = {
            enabled = true,
            doc = {
                enabled = true,
                max_width = 100,
                max_height = 100,
            },
        },
        notifier = { enabled = false, timeout = 3000 },
        picker = {
            enabled = true,
            win = {
                -- input window
                input = {
                    keys = {
                        ["<c-j>"] = { "confirm", mode = { "i", "n" } },
                        ["<c-c>"] = { "cancel", mode = { "i", "n" } },
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
            },
        },
    },
    keys = {
        {
            "<leader>bs",
            function()
                Snacks.scratch()
            end,
            desc = "Toggle Scratch Buffer",
        },
        {
            "<leader>bS",
            function()
                Snacks.scratch.select()
            end,
            desc = "Select scratch buffer",
        },
        {
            "<leader>fb",
            function()
                Snacks.picker.buffers()
            end,
            desc = "Buffers",
        },
        {
            "<leader>fn",
            function()
                Snacks.picker.files({ cwd = vim.fs.abspath("~/.config/nvim/lua/") })
            end,
            desc = "Find neovim configs",
        },
        {
            "<leader>f.",
            function()
                Snacks.picker.files({ cwd = vim.fs.abspath("~/dotfiles") })
            end,
            desc = "Find managed dotfiles",
        },
        {
            "<leader>fp",
            function()
                Snacks.picker.projects()
            end,
            desc = "Projects",
        },
        -- git
        -- { "<leader>fg", function() Snacks.picker.git_branches() end, desc = "Git Branches" },
        {
            "<leader>f/",
            function()
                Snacks.picker.search_history()
            end,
            desc = "Search History",
        },
        {
            "<leader>fC",
            function()
                Snacks.picker.command_history()
            end,
            desc = "Command History",
        },
        {
            "<leader>fc",
            function()
                Snacks.picker.commands()
            end,
            desc = "Commands",
        },
        {
            "<leader>fd",
            function()
                Snacks.picker.diagnostics_buffer()
            end,
            desc = "Buffer Diagnostics",
        },
        {
            "<leader>fh",
            function()
                Snacks.picker.help()
            end,
            desc = "Help Pages",
        },
        {
            "<leader>fm",
            function()
                Snacks.picker.man()
            end,
            desc = "Man Pages",
        },
        {
            "<leader>fk",
            function()
                Snacks.picker.keymaps()
            end,
            desc = "Key maps",
        },
        {
            "<leader>fu",
            function()
                Snacks.picker.undo()
            end,
            desc = "Undo History",
        },
        -- {
        --     "<leader>af",
        --     function()
        --         Snacks.rename.rename_file()
        --     end,
        --     desc = "Rename File",
        -- },
        {
            "<leader>fl",
            function()
                Snacks.picker.highlights()
            end,
            desc = "Highlights",
        },
        {
            "<leader>ff",
            function()
                Snacks.picker.files({
                    cwd = require("project").get_root("cwd"),
                    matcher = {
                        frecency = true,
                        sort_empty = true,
                    },
                })
            end,
            desc = "Find project files",
        },
        {
            "<leader>fz",
            function()
                Snacks.picker.zoxide()
            end,
            desc = "Highlights",
        },
    },
}
