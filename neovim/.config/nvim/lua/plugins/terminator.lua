return {
    'erietz/vim-terminator',
    branch = 'main',
    init = function()
        vim.g.terminator_clear_default_mappings = "foo bar"
        vim.g.terminator_repl_delimiter_regex = '%%'
        vim.g.terminator_runfile_map = {
            python = "python -u",
            julia = "julia",
            lua = "luajit",
            R = 'Rscript',
        }
        vim.g.terminator_split_fraction = 0.3
        vim.g.terminator_auto_shrink_output = true
    end,
    config = function()
        vim.keymap.set('n', '<leader>rr', ':update | TerminatorRunFileInOutputBuffer<cr>',
            { silent = true, noremap = true })
        vim.keymap.set('n', '<leader>rx', ':update | TerminatorStopRun<cr>',
            { silent = true, noremap = true })
        vim.cmd [[
        function CloseRemainingOutput()
            if winnr() == 1 && bufname() == 'OUTPUT_BUFFER'
                quit
            endif
        endfunction
        au WinEnter * call CloseRemainingOutput()
        ]]
    end,
}
