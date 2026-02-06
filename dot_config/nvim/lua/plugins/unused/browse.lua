return {
    "lalitmee/browse.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
        require('browse').setup({
            provider = "google",
            bookmarks = {},
        })
        vim.keymap.set("n", "<leader>K", require('browse.devdocs').search)
    end,
}
