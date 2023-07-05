sniprun = require('sniprun')

sniprun.setup({
    selected_interpreters = { 'Python3_fifo' },
    repl_enable = {'Python3_fifo'},
    display = {'NvimNotify'},
    display_options = {notification_timeout = 5000},
})

vim.keymap.set('n', 'gs', '<Plug>SnipRunOperator', {silent = true})
vim.keymap.set('v', 'gs', '<Plug>SnipRun', {silent = true})

-- run line, accepts a count
vim.keymap.set('n', 'gss',
    function()
        if vim.v.count <= 1 then
            vim.cmd(':SnipRun')
        else 
            local cmd_str = ':normal gs' .. vim.v.count - 1 .. 'j'
            vim.cmd(cmd_str)
        end
    end, {silent = true})
