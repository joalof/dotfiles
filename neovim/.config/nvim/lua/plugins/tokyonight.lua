return {
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 1000,
    config = function()

        Color = require('lib.color').Color
        require("tokyonight").setup({
            style = "moon",
            on_highlights = function(hl, c)
                hl.Constant = { fg = c.orange }
                hl.Number = { fg = c.yellow }
                hl.Boolean = { fg = c.yellow }
                hl.Float = { fg = c.yellow }
                hl.Comment = { fg = Color.from_css(c.fg_gutter):brighten(25):to_css(false)}
                hl["@constant.builtin"] = { fg = c.yellow }
                hl["@variable.builtin"] = { fg = c.blue1 }
                hl["@parameter"] = { fg = c.fg }
                hl["@variable.parameter"] = { fg = c.fg }
                hl["@variable.extra"] = { fg = c.fg }
                -- python doctrings are captured as string.documentation
                hl["@string.documentation"] = { fg = c.green }
                hl.Visual = { bg = Color.from_css(c.magenta):shade(-0.65):to_css(false) }
            end
        })
        vim.cmd.colorscheme "tokyonight"
    end,
}
