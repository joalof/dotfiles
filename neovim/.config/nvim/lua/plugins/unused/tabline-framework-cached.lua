local hi = require("tabline_framework.highlights")
local functions = require("tabline_framework.functions")
local Config = require("tabline_framework.config")
local Tabline = require("tabline_framework.tabline")

local tabline_utils = require('utils.tabline')


hi.clear()
functions.clear()

Config:new({
    hl = hi.tabline(),
    hl_sel = hi.tabline_sel(),
    render = tabline_utils.render,
    hl_fill = { fg = tabline_utils.hls.fill.fg, bg = tabline_utils.hls.fill.bg },
})

local function make_tabline()
    return Tabline.run(Config.render)
end

vim.opt.tabline = [[%!v:lua.require'tabline_framework'.make_tabline()]]

tabline_utils.toggle()

vim.api.nvim_create_augroup("tabline_conf", { clear = true })
vim.api.nvim_create_autocmd({ "FocusGained" }, {
    callback = function()
        tabline_utils.toggle()
    end,
    group = "tabline_conf",
    desc = "Toggle tabline",
})
