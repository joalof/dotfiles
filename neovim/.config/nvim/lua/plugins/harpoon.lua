return {
    'ThePrimeagen/harpoon',
    dependencies = { 'nvim-lua/plenary.nvim' },
    keys = {
        {"<leader>mm", function() require('harpoon.mark').add_file() end},
        {"<leader>mn", function() require('harpoon.ui').nav_next() end},
        {"<leader>mp", function() require('harpoon.ui').nav_prev() end},
    },
}
