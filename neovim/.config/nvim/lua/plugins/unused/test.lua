return {
    'vim-test/vim-test',
    dependencies = {
        {'JoshMcguigan/estream',  build = 'bash install.sh v0.2.0'},
        'skywind3000/asyncrun.vim',
    },
    config = function()
        vim.keymap.set('n', '<leader>tn', ':TestNearest | copen | wincmd p<cr>')
        vim.keymap.set('n', '<leader>tf', ':TestFile | copen | wincmd p<cr>')
        vim.keymap.set('n', '<leader>ts', ':TestSuite | copen | wincmd p<cr>')
        vim.keymap.set('n', '<leader>tl', ':TestLast | copen | wincmd p<cr>')
        vim.keymap.set('n', '<leader>tv', ':TestVisit')

        -- Set errorformat to estream's format
        vim.opt.errorformat = [[%f\|%l\|%c,%f\|%l\|,%f\|\|]]

        -- Define custom estream strategy for vim-test
        vim.cmd[[
        let $PYTHONUNBUFFERED=1
        let g:asyncrun_local = 0
        command! -nargs=1 Async execute "AsyncRun <args> |& $HOME/.vim/plugged/estream/bin/estream"

        function! EstreamStrategy(cmd)
        execute 'Async '.a:cmd
        endfunction
        let g:test#custom_strategies = {'estream': function('EstreamStrategy')}
        let g:test#strategy = 'estream'
        ]]
    end,
}
