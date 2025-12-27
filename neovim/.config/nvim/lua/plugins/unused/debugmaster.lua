return {
    "PascalCaseFan/debugmaster.nvim",
    keys = {'<leader>dm'},
    dependencies = {
        "mfussenegger/nvim-dap",
        "mfussenegger/nvim-dap-python",
    },
    config = function()
        local dm = require("debugmaster")
        vim.keymap.set({ "n", }, "<leader>dm", dm.mode.toggle, { nowait = true })
        vim.keymap.set("n", "<Esc>", dm.mode.disable)
    end,
}
