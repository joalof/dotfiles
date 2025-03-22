return {
    "chrisgrieser/nvim-various-textobjs",
    opts = { useDefaultKeymaps = true },
    -- opts = {
    --     useDefaultKeymaps = false,
    -- },
    -- keys = {
    --     { "an", '<cmd>lua require("various-textobjs").number("outer")<CR>', mode = { "o", "x" } },
    --     { "in", '<cmd>lua require("various-textobjs").number("outer")<CR>', mode = { "o", "x" } },
    -- },
    -- config = function()
    --     require("various-textobjs").setup{
    --         lookForwardSmall = 5,
    --         lookForwardBig = 15,
    --         useDefaultKeymaps = false,
    --         disabledKeymaps = {},
    --         notifyNotFound = true,
    --     }
    --     vim.keymap.set({ "o", "x" }, "an", '<cmd>lua require("various-textobjs").number("outer")<CR>')
    --     vim.keymap.set({ "o", "x" }, "in", '<cmd>lua require("various-textobjs").number("inner")<CR>')
    -- end,
}
