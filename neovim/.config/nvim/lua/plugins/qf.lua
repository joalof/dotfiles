return {
    {
        'stevearc/qf_helper.nvim',
        config = function()
            require('qf_helper').setup
            {
                prefer_loclist = false,
                quickfix = {
                    default_bindings = true
                },
                loclist = {
                    default_bindings = true
                },
            }
            vim.keymap.set("n", "]q", "<CMD>QNext<CR>")
            vim.keymap.set("n", "[q", "<CMD>QPrev<CR>")
            vim.keymap.set("n", "]Q", ":clast<cr>")
            vim.keymap.set("n", "[Q", ":cfirst<cr>")
            vim.keymap.set("n", "<leader>qq", "<CMD>QFToggle!<CR>")
        end,
    },
}
