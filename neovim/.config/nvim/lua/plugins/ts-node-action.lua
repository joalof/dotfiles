return {
    'ckolkey/ts-node-action',
    dependencies = { 'nvim-treesitter' },
    keys = {
        { '<leader>as', function() require('ts-node-action').node_action() end }
    },
}
