-- highlight yank
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank()
    end,
})

-- Enter terminal mode when moving to/opening terminal
-- local augroup_term = vim.api.nvim_create_augroup("augroup_term", { clear = true })
-- vim.api.nvim_create_autocmd({ "WinEnter", "TermOpen" }, {
--     group = augroup_term,
--     pattern = 'term://*',
--     callback = function()
--         -- vim.cmd.normal("i")
--         if vim.api.nvim_buf_get_option(0, "buftype") == "terminal" then
--             vim.cmd.normal("i")
--         end
--     end
-- })

local augroup = vim.api.nvim_create_augroup("augroup_cursorline", { clear = true })
vim.api.nvim_create_autocmd({ "WinEnter", "BufWinEnter" }, {
    group = augroup,
    callback = function()
        vim.opt_local.cursorline = true
    end,
})
vim.api.nvim_create_autocmd({ "WinLeave" }, {
    group = augroup,
    callback = function()
        vim.opt_local.cursorline = false
    end,
})

-- remove dos carriage returns on save (only in unix files)
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    callback = function()
        if vim.bo.fileformat == "unix" then
            vim.cmd([[%s/\r//ge]])
        end
    end,
})

-- autoclose floating windows if we hop out of them with <c-w>hjkl etc
vim.api.nvim_create_autocmd("WinLeave", {
    callback = function()
        local winid = vim.api.nvim_get_current_win()
        local config = vim.api.nvim_win_get_config(winid)

        -- Only close if it's a floating window (has a `relative` key set)
        if config.relative ~= "" then
            vim.api.nvim_win_close(winid, true)
        end
    end,
})


vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup('close_with_q', { clear = true }),
    desc = 'Close with <q>',
    pattern = {
        'git',
        'help',
        'man',
        'qf',
        'scratch',
    },
    callback = function(args)
        if args.match ~= 'help' or not vim.bo[args.buf].modifiable then
            vim.keymap.set('n', 'q', '<cmd>quit<cr>', { buffer = args.buf })
        end
    end,
})
