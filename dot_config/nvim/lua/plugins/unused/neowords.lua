return {
    "backdround/neowords.nvim",
    config = function()
        local neowords = require("neowords")
        local presets = neowords.pattern_presets

        local hops = neowords.get_word_hops(
            -- Vim-patterns or pattern presets separated by commas.
            -- Check `:magic` and onwards for patterns overview.
            presets.any_word
        )

        vim.keymap.set({ "n", "x", "o" }, "w", hops.forward_start)
        vim.keymap.set({ "n", "x", "o" }, "e", hops.forward_end)
        vim.keymap.set({ "n", "x", "o" }, "b", hops.backward_start)
        vim.keymap.set({ "n", "x", "o" }, "ge", hops.backward_end)
    end,
}
