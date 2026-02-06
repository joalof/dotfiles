return {
    "ibhagwan/fzf-lua",
    cmd = "FzfLua",
    keys = {
        { "<leader>fg", "<cmd>FzfLua grep_project<CR>", desc = "Grep all project files" },
    },
    opts = {
        keymap = {
            builtin = {},
            fzf = {
                ["ctrl-c"] = "abort",
                ["ctrl-u"] = "unix-line-discard",
                ["ctrl-f"] = "half-page-down",
                ["ctrl-b"] = "half-page-up",
                ["ctrl-a"] = "beginning-of-line",
                ["ctrl-e"] = "end-of-line",
            },
        },
    },
}
