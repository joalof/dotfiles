return {
    "gnikdroy/projections.nvim",
    keys = { "<leader>fp" },
    config = function()
        require("projections").setup({
            workspaces = {
                "~/projects",
                "~/code",
            },
            patterns = {".git"}
        })
        require("telescope").load_extension("projections")
        vim.keymap.set("n", "<leader>fp", function()
            vim.cmd("Telescope projections")
        end)
    end,
}
