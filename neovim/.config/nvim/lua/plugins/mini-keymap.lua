return {
    "nvim-mini/mini.keymap",
    version = "*",
    config = function()
        require('mini.keymap').setup()
        local map_combo = require("mini.keymap").map_combo
        local mode = {"i", "c"}
        map_combo(mode, "jk", "<BS><BS><Esc>")
        map_combo('t', 'jk', '<BS><BS><C-\\><C-n>')
    end,
}
