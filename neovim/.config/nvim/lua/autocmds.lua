vim.api.nvim_create_autocmd("TextYankPost", {
    group = vim.api.nvim_create_augroup('joakim.highlight_yank', { clear = true }),
    desc = 'Highlight yanked text',
    callback = function()
        vim.highlight.on_yank()
    end,
})


local aug_cursorline = vim.api.nvim_create_augroup("joakim.toggle_cursorline", { clear = true })
vim.api.nvim_create_autocmd({ "WinEnter", "BufWinEnter" }, {
    group = aug_cursorline,
    desc = "Turn on cursorline when we enter a buffer/window",
    callback = function()
        vim.opt_local.cursorline = true
    end,
})
vim.api.nvim_create_autocmd({ "WinLeave" }, {
    group = aug_cursorline,
    desc = "Turn off cursorline when we leave a window",
    callback = function()
        vim.opt_local.cursorline = false
    end,
})


vim.api.nvim_create_autocmd("BufWritePre", {
    group = vim.api.nvim_create_augroup('joakim.remove_dos_cr', { clear = true }),
    desc = "Remove dos carriage returns on saving unix files",
    pattern = "*",
    callback = function()
        if vim.bo.fileformat == "unix" then
            vim.cmd([[%s/\r//ge]])
        end
    end,
})

vim.api.nvim_create_autocmd("WinLeave", {
    group = vim.api.nvim_create_augroup('joakim.close_float', { clear = true }),
    desc = "Close floating windows if we leave them with <c-w>hjkl etc",
    callback = function()
        local winid = vim.api.nvim_get_current_win()
        local config = vim.api.nvim_win_get_config(winid)

        -- Only close if it's a floating window (has a `relative` key set)
        if config.relative ~= "" then
            vim.api.nvim_win_close(winid, true)
        end
    end,
})


vim.api.nvim_create_autocmd('BufEnter', {
    group = vim.api.nvim_create_augroup('joakim.close_with_q', { clear = true }),
    desc = 'Close non-modifiable buffers with <q>',
    callback = function(args)
        if not vim.bo[args.buf].modifiable then
            vim.keymap.set('n', 'q', '<cmd>quit<cr>', { buffer = args.buf })
        end
    end,
})
