return {
    'kkoomen/vim-doge',
    build = ':call doge#install()',
    init = function()
        vim.g.doge_enable_mappings = 0
    end,
    config = function()
        vim.g.doge_python_settings = {omit_redundant_param_types=0, single_quotes=0}
    end
}
