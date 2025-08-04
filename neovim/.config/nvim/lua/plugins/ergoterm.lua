return {
    'waiting-for-dev/ergoterm.nvim',
    keys = {'<C-s>c', '<C-s>/', '<C-s>_'},
    config = function()
        require('ergoterm').setup({})
        local terminal = require('ergoterm.terminal')
        vim.keymap.set({'n', 't'}, '<C-s>c', function()
            local term = terminal.Terminal:new({layout='tab'})
            term:focus()
        end)
        vim.keymap.set({'n', 't'}, '<C-s>/', function()
            local term = terminal.Terminal:new({layout='right'})
            term:focus()
        end)
        vim.keymap.set({'n', 't'}, '<C-s>_', function()
            local term = terminal.Terminal:new({layout='below'})
            term:focus()
        end)
    end,
}
