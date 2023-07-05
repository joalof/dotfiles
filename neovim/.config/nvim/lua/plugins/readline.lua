return {
    'linty-org/readline.nvim',
    event = 'VeryLazy',
    config = function ()
        vim.keymap.set('!', '<M-f>', require('readline').forward_word)
        vim.keymap.set('!', '<M-b>', require('readline').backward_word)
        vim.keymap.set('!', '<C-a>', require('readline').beginning_of_line)
        vim.keymap.set('!', '<C-e>', require('readline').end_of_line)
        vim.keymap.set('!', '<C-w>', require('readline').unix_word_rubout)
        vim.keymap.set('!', '<C-u>', require('readline').backward_kill_line)
        vim.keymap.set('!', '<C-f>', '<Right>')
        vim.keymap.set('!', '<C-b>', '<Left>')
    end,
}
