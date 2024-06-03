return {
    'sainnhe/everforest',
    lazy = false,
    priority = 1000,
    config = function()
        -- Optionally configure and load the colorscheme
        -- directly inside the plugin declaration.
        vim.g.everforest_enable_italic = false
        vim.cmd.colorscheme('everforest')
        vim.o.background = "light"
        vim.g.everforest_background = 'soft'
        vim.g.everforest_better_performance = 1
    end
}
