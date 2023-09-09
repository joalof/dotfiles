return {
    'stevearc/conform.nvim',
    keys = { "<leader>af" },
    config = function ()
        require("conform").setup({
            formatters_by_ft = {
                lua = { "stylua" },
                python = {
                    formatters = { "isort", "black" },
                    -- Run formatters one after another instead of stopping at the first success
                    run_all_formatters = true,
                },
            },
        })
        vim.keymap.set('n', '<leader>af', function() require("conform").format({async = true}) end)
    end
}
