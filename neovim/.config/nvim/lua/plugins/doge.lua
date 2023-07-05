return {
    'kkoomen/vim-doge',
    build = ':call doge#install()',
    config = function()
        vim.g.doge_doc_standard_python = 'numpy'
        vim.g.doge_enable_mappings = 0
        vim.keymap.set('n', '<leader>dg', '<Plug>(doge-generate)')
        -- nmap <silent> <leader>dg <Plug>(doge-generate)
        -- nmap <silent> <leader>dn <Plug>(doge-comment-jump-forward)
        -- imap <silent> <leader>dn <Plug>(doge-comment-jump-forward)
        -- smap <silent> <leader>dn <Plug>(doge-comment-jump-forward)
        -- nmap <silent> <leader>dp <Plug>(doge-comment-jump-backward)
        -- imap <silent> <leader>dp <Plug>(doge-comment-jump-backward)
        -- smap <silent> <leader>dp <Plug>(doge-comment-jump-backward)
    end,
}
