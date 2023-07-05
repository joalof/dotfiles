return {
    'dccsillag/magma-nvim',
    build = ':UpdateRemotePlugins',
    config = function()
        vim.g.magma_image_provider = "kitty"
    end,
}
