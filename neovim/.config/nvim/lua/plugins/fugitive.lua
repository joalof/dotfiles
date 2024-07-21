return {
    "tpope/vim-fugitive",
    config = function()

        local project = require('utils.project')
        local tabline = require('utils.tabline')

        vim.cmd[[autocmd User FugitiveChanged lua require('utils.tabline').update_marks()]]
        -- vim.api.nvim_create_autocmd({ "FugitiveChanged" }, {
        --     group = "User",
        --     callback = function()
        --         tabline.cache_display_marks(project.get_git_branch())
        --     end
        -- })
    end
}
