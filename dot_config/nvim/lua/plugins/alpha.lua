return {
    'goolord/alpha-nvim',
    event = "VimEnter",
    config = function ()
        local alpha = require('alpha')
        local theme = require('alpha.themes.theta')
        local dashboard = require('alpha.themes.dashboard')
        local buttons = {
            type = "group",
            val = {
                { type = "text", val = "Quick links", opts = { hl = "SpecialComment", position = "center" } },
                { type = "padding", val = 1 },
                dashboard.button("e", "  New file", "<cmd>ene<CR>"),
                dashboard.button("<leader>ff", "󰈞  Find file"),
                dashboard.button("<leader>fg", "󰊄  Live grep"),
                dashboard.button("c", "  Configuration", "<cmd>cd ~/.config/nvim/ <CR>"),
                dashboard.button("u", "  Update plugins", "<cmd>Lazy sync<CR>"),
                dashboard.button("q", "󰅚  Quit", "<cmd>qa<CR>"),
            },
            position = "center",
        }
        theme.config.layout[6] = buttons
        alpha.setup(theme.config)
    end
}
