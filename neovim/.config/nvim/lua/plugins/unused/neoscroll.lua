return {
    'karb94/neoscroll.nvim',
    keys = { '<C-u>', '<C-d>', '<C-b>', '<C-f>', '<C-y>', '<C-e>', 'zt', 'zz', 'zb' },
    config = function()
        require('neoscroll').setup({
            stop_eof = true,
            pre_hook = function()
                vim.opt.eventignore:append({
                    'WinScrolled',
                    'CursorMoved',
                 })
            end,
                post_hook = function()
                vim.opt.eventignore:remove({
                    'WinScrolled',
                    'CursorMoved',
                })
            end,
        })

        local t = {}
        -- Syntax: t[keys] = {function, {function arguments}}
        t['<C-u>'] = {'scroll', {'-vim.wo.scroll', 'true', '150'}}
        t['<C-d>'] = {'scroll', { 'vim.wo.scroll', 'true', '150'}}
        t['<C-b>'] = {'scroll', {'-vim.api.nvim_win_get_height(0)', 'true', '250'}}
        t['<C-f>'] = {'scroll', { 'vim.api.nvim_win_get_height(0)', 'true', '250'}}
        t['<C-y>'] = {'scroll', {'-0.10', 'false', '50'}}
        t['<C-e>'] = {'scroll', { '0.10', 'false', '50'}}
        t['zt']    = {'zt', {'150'}}
        t['zz']    = {'zz', {'150'}}
        t['zb']    = {'zb', {'150'}}

        require('neoscroll.config').set_mappings(t)
            end,
        }
