return {
    "rafcamlet/tabline-framework.nvim",
    dependencies = {
        { "nvim-tree/nvim-web-devicons" },
        { "ThePrimeagen/harpoon", dependencies = { "nvim-lua/plenary.nvim" } },
    },
    config = function()

        local project = require('utils.project')
        local tabline = require('utils.tabline')

        require("tabline_framework").setup({
            render = tabline.render,
            hl_fill = { fg = tabline.hls.fill.fg, bg = tabline.hls.fill.bg },
        })

        tabline.cache_display_marks(project.get_git_branch())
        tabline.toggle_tabline()

        vim.api.nvim_create_augroup("tabline_conf", { clear = true })
        vim.api.nvim_create_autocmd({"DirChanged", "TabEnter"}, {
            callback = tabline.toggle_tabline,
            group = "tabline_conf",
            desc = "Toggle tabline",
        })
        vim.api.nvim_create_autocmd({"DirChanged", "TabEnter"}, {
            callback = function() tabline.cache_display_marks(project.get_git_branch()) end,
            group = "tabline_conf",
            desc = "Toggle tabline",
        })
    end,
}
