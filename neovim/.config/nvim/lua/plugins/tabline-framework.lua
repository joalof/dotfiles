return {
    "rafcamlet/tabline-framework.nvim",
    dependencies = {
        { "nvim-tree/nvim-web-devicons" },
        { "cbochs/grapple.nvim" },
    },
    config = function()
        local tabline = require("utils.tabline")

        require("tabline_framework").setup({
            render = tabline.render,
            hl_fill = { fg = tabline.hls.fill.fg, bg = tabline.hls.fill.bg },
        })

        tabline.toggle()

        vim.api.nvim_create_augroup("tabline_conf", { clear = true })
        vim.api.nvim_create_autocmd({ "FocusGained" }, {
            callback = function()
                tabline.toggle()
            end,
            group = "tabline_conf",
            desc = "Toggle tabline",
        })
    end,
}
