return {
    "dmtrKovalenko/caps-word.nvim",
    lazy = true,
    opts = {},
    keys = {
        {
            mode = { "i", "n" },
            "<leader>mc",
            "<cmd>lua require('caps-word').toggle()<CR>",
        },
    },
}
