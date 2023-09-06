return {
    'lukas-reineke/indent-blankline.nvim',
    -- branch = "v3",
    event = "BufReadPre",
    config = function()
        -- require("ibl").setup()
        require("indent_blankline").setup {
            -- show_current_context = true,
            -- show_current_context_start = true,
            show_first_indent_level = true,
            max_indent_increase=1,
            filetype_exclude = {
                "help",
                "alpha",
                "dashboard",
                "Trouble",
                "lazy",
                "mason",
                "notify",
            }
        }
    end,
}
