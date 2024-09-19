return {
    "rafcamlet/tabline-framework.nvim",
    dependencies = {
        { "nvim-tree/nvim-web-devicons" },
        { "cbochs/grapple.nvim" },
    },
    config = function()
        local tabline_utils = require("utils.tabline")

        require("tabline_framework").setup({
            render = tabline_utils.render,
            hl_fill = { fg = tabline_utils.hls.fill.fg, bg = tabline_utils.hls.fill.bg },
        })

        tabline_utils.toggle()

        vim.api.nvim_create_augroup("tabline_conf", { clear = true })
        vim.api.nvim_create_autocmd({ "FocusGained" }, {
            callback = function()
                tabline_utils.toggle()
            end,
            group = "tabline_conf",
            desc = "Toggle tabline",
        })
    end,
}
