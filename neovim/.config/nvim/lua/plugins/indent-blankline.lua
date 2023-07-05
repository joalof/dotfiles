return {
    'lukas-reineke/indent-blankline.nvim',
    config = function()
        require("indent_blankline").setup {
            -- show_current_context = true,
            -- show_current_context_start = true,
            show_first_indent_level = true,
            max_indent_increase=1,
        }
    end,
}
