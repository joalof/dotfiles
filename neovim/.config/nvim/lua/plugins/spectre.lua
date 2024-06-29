return {
    'nvim-pack/nvim-spectre',
    keys = { "<leader>fs" },
    config = function()
        require('spectre').setup(
            {
                default = {
                    replace = {
                        cmd = "sed",
                    },
                },
            }
        )
        vim.keymap.set('n', '<leader>fs', function() require('spectre').open() end)
    end
}
