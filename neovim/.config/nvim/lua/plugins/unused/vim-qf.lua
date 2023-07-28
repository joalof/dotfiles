return {
    'romainl/vim-qf',
    config = function()
        vim.keymap.set("n", "]q", '<Plug>(qf_qf_next)')
        vim.keymap.set("n", "[q", '<Plug>(qf_qf_previous)')
        vim.keymap.set("n", "]Q", ":clast<cr>")
        vim.keymap.set("n", "[Q", ":cfirst<cr>")
    end,
}
