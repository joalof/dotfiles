return {
    'ckolkey/ts-node-action',
    dependencies = { 'nvim-treesitter' },
    keys = {
        { '<leader>ns', function() require('ts-node-action').node_action() end }
    },
}
