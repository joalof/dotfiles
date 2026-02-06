return {
    "carbon-steel/detour.nvim",
    cmd = 'Detour',
    -- config = function()
    --     require("detour").setup({
    --         -- Put custom configuration here
    --     })
    --     -- vim.keymap.set('n', '<c-w><enter>', ":Detour<cr>")
    --     -- vim.keymap.set('n', '<c-w>.', ":DetourCurrentWindow<cr>")
    --   
    --     vim.keymap.set("n", "<leader>T", function()
    --         local popup_id = require("detour").Detour() -- open a detour popup
    --         if not popup_id then
    --             return
    --         end
    --
    --         vim.cmd.terminal("ipython --no-banner --no-confirm-exit") -- open a terminal buffer
    --         vim.bo.bufhidden = "delete" -- close the terminal when window closes
    --
    --         -- It's common for people to have `<Esc>` mapped to `<C-\><C-n>` for terminals.
    --         -- This can get in the way when interacting with TUIs.
    --         -- This maps the escape key back to itself (for this buffer) to fix this problem.
    --         vim.keymap.set("t", "<Esc>", "<Esc>", { buffer = true })
    --         vim.cmd.startinsert() -- go into insert mode
    --
    --         vim.api.nvim_create_autocmd({ "TermClose" }, {
    --             buffer = vim.api.nvim_get_current_buf(),
    --             callback = function()
    --                 -- This automated keypress skips for you the "[Process exited 0]" message
    --                 -- that the embedded terminal shows.
    --                 vim.api.nvim_feedkeys("i", "n", false)
    --             end,
    --         })
    --     end)
    --
    --
    --     
    -- end,
}
