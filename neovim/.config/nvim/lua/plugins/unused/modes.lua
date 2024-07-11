return { 'mvllow/modes.nvim' ,
    config = function()

        local hl = require('lualine.themes.tokyonight-moon')
        
        require('modes').setup({
            colors = {
                bg = "", -- Optional bg param, defaults to Normal hl group
                copy = "#f5c359",
                delete = hl.replace.a.bg,
                replace = hl.replace.a.bg,
                insert = hl.insert.a.bg,
                visual = hl.visual.a.bg,
            },

            -- Set opacity for cursorline and number background
            line_opacity = 0.15,

            -- Enable cursor highlights
            set_cursor = true,

            -- Enable cursorline initially, and disable cursorline for inactive windows
            -- or ignored filetypes
            set_cursorline = true,

            -- Enable line number highlights to match cursorline
            set_number = true,

            -- ignore_filetypes = { 'NvimTree', 'TelescopePrompt' }
            ignore_filetypes = {},
        })
    end
}
