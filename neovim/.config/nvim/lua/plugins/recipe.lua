return {
    'ten3roberts/recipe.nvim',
    dependencies = {
        'nvim-lua/plenary.nvim',
        "MunifTanjim/nui.nvim",
    },
    config = function ()
        require("recipe").setup{}
    end
}
