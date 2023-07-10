return {
    'kkoomen/vim-doge',
    build = ':call doge#install()',
    init = function()
        vim.g.doge_doc_standard_python = 'numpy'
        vim.g.doge_enable_mappings = 0
    end,
    config = function()
        vim.keymap.set('n', '<leader>dg', '<Plug>(doge-generate)')
    end,
}
