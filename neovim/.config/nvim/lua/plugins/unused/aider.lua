return {
    "GeorgesAlkhouri/nvim-aider",
    cmd = "Aider",
    keys = {
        { "<leader>lt", "<cmd>Aider toggle<cr>", desc = "Toggle Aider" },
        { "<leader>ls", "<cmd>Aider send<cr>", desc = "Send to Aider", mode = { "n", "v" } },
        { "<leader>lc", "<cmd>Aider command<cr>", desc = "Aider Commands" },
        { "<leader>lb", "<cmd>Aider buffer<cr>", desc = "Send Buffer" },
        { "<leader>l+", "<cmd>Aider add<cr>", desc = "Add File" },
        { "<leader>l-", "<cmd>Aider drop<cr>", desc = "Drop File" },
        { "<leader>lr", "<cmd>Aider add readonly<cr>", desc = "Add Read-Only" },
        { "<leader>lR", "<cmd>Aider reset<cr>", desc = "Reset Session" },
    },
    dependencies = {
        "folke/snacks.nvim",
    },
    config = function()
        vim.o.autoread = true
        require("nvim_aider").setup({
            -- Command that executes Aider
            aider_cmd = "aider",
            -- Command line arguments passed to aider
            -- prefer aider yaml config file
            -- args = {
            --     "--no-auto-commits",
            --     "--pretty",
            --     "--stream",
            --     "--model gemini-2.5-pro"
            -- },
            -- Automatically reload buffers changed by Aider (requires vim.o.autoread = true)
            auto_reload = true,
            -- snacks.picker.layout.Config configuration
            picker_cfg = {
                preset = "vscode",
            },
            -- Other snacks.terminal.Opts options
            config = {
                os = { editPreset = "nvim-remote" },
                gui = { nerdFontsVersion = "3" },
            },
            win = {
                wo = { winbar = "Aider" },
                style = "nvim_aider",
                position = "right",
            },
        })
    end
}
