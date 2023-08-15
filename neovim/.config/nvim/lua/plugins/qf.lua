return {
    'ten3roberts/qf.nvim',
    config = function()
        require('qf').setup({
            pretty = true,
            c = {
                auto_follow = false,
            },
        })
        vim.keymap.set("n", "]q", function() require('qf').next('c', true) end)
        vim.keymap.set("n", "[q", function() require('qf').prev('c', true) end)
        vim.keymap.set("n", "<leader>qq", function() require('qf').toggle('c', true) end)

        -- general qf stuff
        vim.keymap.set("n", "]Q", ":clast<cr>")
        vim.keymap.set("n", "[Q", ":cfirst<cr>")

        -- autoclose functionality
        local function get_win_type()
            local wid = vim.api.nvim_get_current_win()
            local winfo = vim.fn.getwininfo(wid)[1]
            if winfo.loclist == 1 then
                return "l"
            elseif winfo.quickfix == 1 then
                return 'c'
            end
        end

        local function list_autoclose()
            local list_type = get_win_type()
            if list_type and vim.tbl_count(vim.api.nvim_list_wins()) == 1 then
                vim.cmd("quit")
            end
        end

        vim.api.nvim_create_autocmd("WinEnter", {
            desc = "Auto-close tab or neovim if quickfix/loclist is the last remaining window",
            pattern = "*",
            callback = function()
                list_autoclose()
            end,
        })
    end
}
