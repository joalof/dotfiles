return {
    'chrisgrieser/nvim-spider',
    config = function()
        local modes = {"n", "o", "x"}
        vim.keymap.set(modes, "w", "<cmd>lua require('spider').motion('w')<CR>")
        vim.keymap.set(modes, "e", "<cmd>lua require('spider').motion('e')<CR>")
        vim.keymap.set(modes, "b", "<cmd>lua require('spider').motion('b')<CR>")
        vim.keymap.set(modes, "ge", "<cmd>lua require('spider').motion('ge')<CR>")
    end
}
