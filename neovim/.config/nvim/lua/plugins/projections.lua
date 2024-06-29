return {
    "gnikdroy/projections.nvim",
    branch = "pre_release",
    keys = { "<leader>fp" },
    config = function()
        require("projections").setup({
            workspaces = {
                "~/projects",
                "~/code/neovim",
                "~/code/python",
                "~/code/julia",
            },
            patterns = {".git", "Project.toml", "setup.py", "pyproject.toml"}
        })
        require("telescope").load_extension("projections")
        vim.keymap.set("n", "<leader>fp", function()
            vim.cmd("Telescope projections")
        end)
    end,
}
