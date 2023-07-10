return {
    'ckolkey/ts-node-action',
    dependencies = {'nvim-treesitter'},
    opts = {},
    config = function()
        require("ts-node-action").setup({})
        vim.keymap.set('n', '<leader>S', require('ts-node-action').node_action)
    end,
}
