return {
    "theHamsta/nvim_rocks",
    event = "VeryLazy",
    build = "wget https://raw.githubusercontent.com/luarocks/hererocks/master/hererocks.py && python3 hererocks.py . -j2.1.0-beta3 -r3.9.2 && cp nvim_rocks.lua lua",
    config = function()
        local nvim_rocks = require("nvim_rocks")
        nvim_rocks.ensure_installed("magick")
    end,
}
