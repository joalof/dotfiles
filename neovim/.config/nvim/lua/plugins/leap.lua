return {
    'ggandor/leap.nvim',
    config = function ()
        vim.keymap.set({'n', 'x', 'o'}, 's', '<Plug>(leap-forward-to)')
    end,
}
