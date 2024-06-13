return {
    'AckslD/swenv.nvim',
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    keys = {"<leader>fv"},
    config = function()
        vim.keymap.set('n', '<leader>fv', function() require('swenv.api').pick_venv() end)
    end
}
