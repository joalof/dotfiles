return {
    'ckolkey/ts-node-action',
    dependencies = {'nvim-treesitter'},
    config = function()
        vim.keymap.set('n', '<leader>S', require('ts-node-action').toggle_multiline)
    end,
}
