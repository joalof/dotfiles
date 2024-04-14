return {
    "numToStr/Comment.nvim",
    keys = {
        { "gcc", "gcb", "gcO", "gco", "gcA"},
        { "gc", mode = { "n", "x" } },
        { "gb", mode = { "n", "x" } },
        { "gy", mode = { "v" } },
    },
    config = function()
        require("Comment").setup(
            {
                ignore = '^$',
            }
        )
        -- Define a mapping that pastes the current selection
        -- below and then comments the original text
        -- https://www.reddit.com/r/neovim/comments/16s5azh/how_to_comment_selected_lines_and_paste_them/
        vim.keymap.set({ "v" }, "gy", function()
            local win = vim.api.nvim_get_current_win()
            local cur = vim.api.nvim_win_get_cursor(win)
            local vstart = vim.fn.getpos("v")[2]
            local current_line = vim.fn.line(".")
            local set_cur = vim.api.nvim_win_set_cursor

            if vstart == current_line then
                vim.cmd.yank()
                require("Comment.api").toggle.linewise.current()
                vim.cmd.put()
                set_cur(win, { cur[1] + 1, cur[2] })
            else
                if vstart < current_line then
                    vim.cmd(":" .. vstart .. "," .. current_line .. "y")
                    vim.cmd.put()
                    set_cur(win, { vim.fn.line("."), cur[2] })
                else
                    vim.cmd(":" .. current_line .. "," .. vstart .. "y")
                    set_cur(win, { vstart, cur[2] })
                    vim.cmd.put()
                    set_cur(win, { vim.fn.line("."), cur[2] })
                end
                require("Comment.api").toggle.linewise(vim.fn.visualmode())
            end
        end, { silent = true, desc = "Paste selection below then comment" })
    end,
}
