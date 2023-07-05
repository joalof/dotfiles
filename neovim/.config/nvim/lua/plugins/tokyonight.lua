return {
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 1000,
    config = function()
        require("tokyonight").setup({
            style = "moon",
            on_highlights = function(hl, c)
                hl.Constant = {fg = c.orange}
                hl.Number = {fg = c.yellow}
                hl.Boolean = {fg = c.yellow}
                hl.Float = {fg = c.yellow}
                hl.Comment = {fg = c.fg_gutter}
                hl["@constant.builtin"] = {fg = c.yellow}
                hl["@variable.builtin"] = {fg = c.blue1}
                hl["@parameter"] = {fg = c.fg}
                hl["@variable.extra"] = {fg = c.fg}
                -- python doctrings are captured as string.documentation
                hl["@string.documentation"] = {fg = c.green}
            end
        })
        vim.cmd[[colorscheme tokyonight]]
    end,
}
