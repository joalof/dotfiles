-- highlight yank
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank()
    end,
})

-- Enter terminal mode when movinng to/opening terminal
local augroup_term = vim.api.nvim_create_augroup("augroup_term", { clear = true })
vim.api.nvim_create_autocmd({ "WinEnter", "TermOpen" }, {
    group = augroup_term,
    pattern = 'term://*',
    -- command = 'startinsert'
    callback = function()
        vim.cmd.normal("i")
        -- if vim.api.nvim_buf_get_option(0, "buftype") == "terminal" then
            -- vim.cmd.normal("i")
        -- end
    end
})
