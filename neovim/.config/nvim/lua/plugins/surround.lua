return {
    {
        "kylechui/nvim-surround",
        version = "*", -- Use for stability; omit to use `main` branch for the latest features
        event = "VeryLazy",
        config = function()
            require("nvim-surround").setup({})
        end
    },
    -- {
    --     'Matt-A-Bennett/vim-surround-funk',
    --     event = "VeryLazy",
    --     init = function()
    --         vim.g.surround_funk_create_mappings = 0
    --     end,
    --     config = function()
    --         vim.keymap.set('n', 'dsf', '<Plug>DeleteSurroundingFUNCTION', {silent = true})
    --         vim.keymap.set('n', 'ysf', '<Plug>YankSurroundingFUNCTION', {silent = true})
    --         vim.keymap.set('n', 'csf', '<Plug>ChangeSurroundingFUNCTION', {silent = true})
    --
    --         vim.keymap.set({'x', 'o'}, 'an', '<Plug>SelectFunctionNAME', {silent = true})
    --         vim.keymap.set({'x', 'o'}, 'in', '<Plug>SelectFunctionNAME', {silent = true})
    --     end,
    -- }
}
