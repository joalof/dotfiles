return {
    "nvim-mini/mini.keymap",
    version = "*",
    config = function()
        require("mini.keymap").setup()
        local map_combo = require("mini.keymap").map_combo
        local mode = { "i", "c" }
        map_combo(
            mode,
            "jk",
            function()
                -- require("blink.cmp").cancel()
                vim.api.nvim_feedkeys(
                    vim.api.nvim_replace_termcodes(
                        "<BS><BS><Esc>",
                        true,
                        false,
                        true
                    ),
                    "n",
                    false
                )
            end
        )
        map_combo(
            "t",
            "jk",
            function()
                -- require("blink.cmp").cancel()
                vim.api.nvim_feedkeys(
                    vim.api.nvim_replace_termcodes(
                        "<BS><BS><C-\\><C-n>",
                        true,
                        false,
                        true
                    ),
                    "n",
                    false
                )
            end
        )
    end,
}
