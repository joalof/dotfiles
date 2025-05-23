return {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = {
        "nvim-lua/plenary.nvim",
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        "assistcontrol/readline.nvim"
    },
    config = function()
        local actions = require("telescope.actions")

        require("telescope").setup({
            defaults = {
                prompt_prefix = " ",
                selection_caret = " ",
                -- open files in the first window that is an actual file.
                -- use the current window if no other window is available.
                get_selection_window = function()
                    local wins = vim.api.nvim_list_wins()
                    table.insert(wins, 1, vim.api.nvim_get_current_win())
                    for _, win in ipairs(wins) do
                        local buf = vim.api.nvim_win_get_buf(win)
                        if vim.bo[buf].buftype == "" then
                            return win
                        end
                    end
                    return 0
                end,
                mappings = {
                    i = {
                        ["<C-j>"] = actions.select_default,
                        ["<C-c>"] = actions.close,
                        ["<C-u>"] = function() require("readline").backward_kill_line() end,
                        ["<C-/>"] = actions.select_vertical,
                        ["<C-->"] = actions.select_horizontal,
                    },
                    n = {
                        ["<C-j>"] = actions.select_default,
                        ["<C-c>"] = actions.close,
                        ["<C-q>"] = actions.smart_add_to_qflist + actions.open_qflist, -- add grep to quickfix
                    },
                },
            },
            extensions = {
                fzf = {
                    fuzzy = true, -- false will only do exact matching
                    override_generic_sorter = true, -- override the generic sorter
                    override_file_sorter = true, -- override the file sorter
                    case_mode = "smart_case", -- or "ignore_case" or "respect_case"
                },
            },
        })

        require("telescope").load_extension("fzf")
        -- vim.keymap.set("n", "<leader>ff", function()
        --     builtin.find_files({ cwd = tostring(project.get_root('cwd')) })
        -- end)
        -- vim.keymap.set("n", "<leader>fa", function()
        --     builtin.find_files({ cwd = "~" })
        -- end)
        -- vim.keymap.set("n", "<leader>fg", function()
        --     builtin.live_grep({ cwd = tostring(project.get_root('cwd')) })
        -- end)
        -- vim.keymap.set("n", "<leader>fh", builtin.help_tags)
        -- vim.keymap.set("n", "<leader>fn", function()
        --     builtin.find_files({ cwd = vim.fn.environ()["HOME"] .. "/.config/nvim", hidden = true })
        -- end)
    end,
}
