return {
    "L3MON4D3/LuaSnip",
    version = "2.*",
    ft = {'python', 'lua', 'tex'},
    build = "make install_jsregexp",
    config = function()
        require("luasnip.loaders.from_snipmate").lazy_load()
    end,
}
