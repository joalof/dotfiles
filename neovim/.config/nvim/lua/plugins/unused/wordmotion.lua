return {
    'chaoren/vim-wordmotion',
    init = function()
        vim.g.wordmotion_spaces = {'_', '-', '[', ']', '(', ')', '{', '}', "'", '"', ',', '.', '='}
        -- vim.g.wordmotion_spaces = {'_', '-', '[', ']', '(', ')', '{', '}', "'", '"', ',', '='}
    end
}
