return {
    "carlos-algms/agentic.nvim",
    opts = {
        -- Available by default: "claude-acp" | "gemini-acp" | "codex-acp" | "opencode-acp" | "cursor-acp"
        provider = "claude-acp",
        keymaps = {
            prompt = {
                submit = {
                    {
                        "<CR>",
                        mode = { "n", "v" },
                    },
                    {
                        "<C-j>",
                        mode = { "n", "v" },
                    },
                },
            },
        },
    },
    keys = {
        {
            "<leader>cc",
            function()
                require("agentic").toggle()
            end,
            mode = { "n" },
            desc = "Toggle Agentic Chat",
        },
        {
            "<leader>ca",
            function()
                require("agentic").add_selection_or_file_to_context()
            end,
            mode = { "n", "v" },
            desc = "Add file or selection to Agentic to Context",
        },
        {
            "<leader>cn",
            function()
                require("agentic").new_session()
            end,
            mode = { "n" },
            desc = "New Agentic Session",
        },
    },
}
