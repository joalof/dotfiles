return {
    "tpope/vim-fugitive",
    config = function()

        local tabline = require('utils.tabline')

        vim.api.nvim_create_autocmd({ "User" }, {
            pattern = "FugitiveChanged",
            callback = function()
                tabline.update_marks()
            end
        })
    end
}
