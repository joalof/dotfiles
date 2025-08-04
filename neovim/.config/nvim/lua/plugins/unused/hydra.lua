return {
    "nvimtools/hydra.nvim",
    dependencies = {
        'waiting-for-dev/ergoterm.nvim',
    },
    config = function()
        local hydra = require("hydra")
        -- require('ergoterm').setup({})
        -- local terminal = require('ergoterm.terminal')
        -- vim.keymap.set({'n'}, '<C-s>c', function()
        --     local term = terminal.Terminal:new({layout='right'})
        --     term:focus()
        -- end)

        
        -- hydra({
        --     -- Window navigation + terminal management
        --     name = "ErgoTerm",
        --     mode = "n",
        --     body = "<C-s>",
        --     heads = { 
        --         {'n', ':tabnext<cr>'},
        --         {'p', ':tabprevious<cr>'},
        --         {'c', ':tabprevious<cr>'},
        --         {'/', ':tabprevious<cr>'},
        --         {'_', ':tabprevious<cr>'},
        --     },
        -- })
    end,
}
