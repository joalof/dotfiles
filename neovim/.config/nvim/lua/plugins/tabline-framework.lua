return {
    "rafcamlet/tabline-framework.nvim",
    dependencies = {
        { "nvim-tree/nvim-web-devicons" },
        { "cbochs/grapple.nvim" },
    },
    config = function()
        local tabline_ext = require("extensions.tabline")

        local opts = {
            render = tabline_ext.render,
            hl_fill = { fg = tabline_ext.hls.fill.fg, bg = tabline_ext.hls.fill.bg },
        }
        require("tabline_framework").setup(opts)
        tabline_ext.toggle()

        -- local print_warn = require'tabline_framework.helpers'.print_warn
        -- local hi = require'tabline_framework.highlights'
        -- local functions = require'tabline_framework.functions'
        -- local Config = require'tabline_framework.config'
        -- local Tabline = require'tabline_framework.tabline'

        -- local function make_tabline()
        --     return Tabline.run(Config.render)
        -- end

        -- Config:new {
        --     hl = hi.tabline(),
        --     hl_sel = hi.tabline_sel(),
        --     hl_fill = hi.tabline_fill()
        -- }

        -- Config:merge(opts)

        -- vim.opt.tabline = [[%!v:lua.require'tabline_framework'.make_tabline()]]

        -- vim.api.nvim_create_augroup("tabline_conf", { clear = true })
        -- vim.api.nvim_create_autocmd({ "FocusGained" }, {
        --     callback = function()
        --         tabline_ext.toggle()
        --     end,
        --     group = "tabline_conf",
        --     desc = "Toggle tabline",
        -- })
    end,
}
