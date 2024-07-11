return {
    "svampkorg/moody.nvim",
    -- event = { "ModeChanged" },
    opts = {
        -- you can set different blend values for your different modes.
        -- Some colours might look better more dark.
        blend = {
            normal = 0.28,
            insert = 0.2,
            visual = 0.35,
            command = 0.3,
            replace = 0.2,
            select = 0.3,
            terminal = 0.2,
            terminal_n = 0.2,
        },
    },
    config = function(_, opts)
        vim.opt.cursorline = true
        local tn_lualine = require('lualine.themes.tokyonight-moon')
        local groups = {
            NormalMoody = { fg = tn_lualine.normal.a.bg},
            InsertMoody = { fg = tn_lualine.normal.a.bg},
            VisualMoody = { fg = tn_lualine.visual.a.bg},
            CommandMoody = { fg = tn_lualine.command.a.bg},
            ReplaceMoody = { fg = tn_lualine.replace.a.bg},
            SelectMoody = { fg = tn_lualine.replace.b.bg},
            TerminalMoody = { fg = tn_lualine.terminal.a.bg },
            TerminalNormalMoody = { fg = tn_lualine.terminal.b.bg},
        }
        for name, val in pairs(groups) do
            vim.api.nvim_set_hl(0, name, val)
        end
        require('moody').setup(opts)
    end
}
