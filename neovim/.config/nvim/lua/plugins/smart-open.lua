return {
    "danielfalk/smart-open.nvim",
    branch = "0.2.x",
    dev = true,
    dependencies = {
        "kkharji/sqlite.lua",
        -- Only required if using match_algorithm fzf
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        -- Optional.  If installed, native fzy will be used when match_algorithm is fzy
        -- { "nvim-telescope/telescope-fzy-native.nvim" },
    },
    keys = {"<leader>fs"},
    config = function()
        require("telescope").setup({
            extensions = {
                smart_open = {
                    match_algorithm = "fzf",
                },
            },
        })
        require("telescope").load_extension("smart_open")
        vim.keymap.set("n", "<leader>fs", function()
            require("telescope").extensions.smart_open.smart_open()
        end, { noremap = true, silent = true })
    end,
}
