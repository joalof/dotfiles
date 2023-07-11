return {
    'kkoomen/vim-doge',
    build = ':call doge#install()',
    init = function()
        vim.g.doge_enable_mappings = 0
    end,
}
