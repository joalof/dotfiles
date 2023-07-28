return {
    'ten3roberts/qf.nvim',
    config = function()
        require('qf').setup{}
        vim.keymap.set("n", "]q", function() require('qf').below('visible') end)
        vim.keymap.set("n", "[q", function() require('qf').above('visible') end)
        vim.keymap.set("n", "]Q", ":clast<cr>")
        vim.keymap.set("n", "[Q", ":cfirst<cr>")
    end,
}
