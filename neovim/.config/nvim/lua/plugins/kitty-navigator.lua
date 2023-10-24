return {
    "knubie/vim-kitty-navigator",
    build = "cp ./*.py ~/.config/kitty/",
    init = function()
        vim.g.kitty_navigator_no_mappings = 1
    end,
    config = function()
        local opts = { silent = true }
        vim.keymap.set({ "n" }, "<C-s>l", ":KittyNavigateRight<cr>", opts)
        vim.keymap.set({ "n" }, "<C-s>h", ":KittyNavigateLeft<cr>", opts)
        vim.keymap.set({ "n" }, "<C-s>k", ":KittyNavigateUp<cr>", opts)
        vim.keymap.set({ "n" }, "<C-s>j", ":KittyNavigateDown<cr>", opts)

        vim.keymap.set({ "i" }, "<C-s>l", "<Esc>:KittyNavigateRight<cr>", opts)
        vim.keymap.set({ "i" }, "<C-s>h", "<Esc>:KittyNavigateLeft<cr>", opts)
        vim.keymap.set({ "i" }, "<C-s>k", "<Esc>:KittyNavigateUp<cr>", opts)
        vim.keymap.set({ "i" }, "<C-s>j", "<Esc>:KittyNavigateDown<cr>", opts)

        vim.keymap.set({ "t" }, "<C-s>l", "<C-\\><C-n>:KittyNavigateRight<cr>", opts)
        vim.keymap.set({ "t" }, "<C-s>h", "<C-\\><C-n>:KittyNavigateLeft<cr>", opts)
        vim.keymap.set({ "t" }, "<C-s>k", "<C-\\><C-n>:KittyNavigateUp<cr>", opts)
        vim.keymap.set({ "t" }, "<C-s>j", "<C-\\><C-n>:KittyNavigateDown<cr>", opts)
    end,
}
