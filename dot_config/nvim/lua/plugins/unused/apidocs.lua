return {
    "emmanueltouzery/apidocs.nvim",
    cmd = { "ApidocsInstall", "ApidocsOpen", "ApidocsSearch", "ApidocsSelect", "ApidocsUninstall" },
    config = function()
        require("apidocs").setup()
    end,
}
