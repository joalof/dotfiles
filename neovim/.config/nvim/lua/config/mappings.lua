vim.keymap.set("n", "j", "gj")
vim.keymap.set("n", "k", "gk")

vim.keymap.set("n", "'", "`")
vim.keymap.set("n", "`", "'")
vim.keymap.set("n", "0", "^")
vim.keymap.set("n", "^", "0")

-- vim.keymap.set("n", "<c-l>", "i<space><esc>l")
-- vim.keymap.set("n", "<c-k>", "O<esc>")
vim.keymap.set("n", "<c-j>", "o<esc>")

-- vim.keymap.set("n", "gh", "^")
-- vim.keymap.set("n", "gl", "$")
-- vim.keymap.set({"n", "x", "o"}, "gj", "}")
-- vim.keymap.set({"n", "x", "o"}, "gk", "{")

-- Add empty lines before and after cursor line
-- vim.keymap.set('n', '[<space>', "<Cmd>call append(line('.') - 1, repeat([''], v:count1))<CR>")
-- vim.keymap.set('n', ']<space>', "<Cmd>call append(line('.'),     repeat([''], v:count1))<CR>")

vim.keymap.set("n", "]t", ":tabnext<cr>", { silent = true })
vim.keymap.set("n", "[t", ":tabprevious<cr>", { silent = true })

vim.keymap.set("n", "]b", ":bnext<cr>", { silent = true })
vim.keymap.set("n", "[b", ":bprevious<cr>", { silent = true })
vim.keymap.set("n", "]B", ":blast<cr>", { silent = true })
vim.keymap.set("n", "[B", ":bfirst<cr>", { silent = true })

-- terminal

-- splitline
vim.keymap.set("n", "S", function()
    return [[:keeppatterns substitute/\s*\%#\s*/\r/e <bar> normal! ==k$<CR>]]
end, { expr = true })

if vim.env.TERM_PROGRAM == "WezTerm" then
    local nav = {
        h = "Left",
        j = "Down",
        k = "Up",
        l = "Right",
    }

    local function navigate(dir)
        return function()
            local win = vim.api.nvim_get_current_win()

            vim.cmd.wincmd(dir)

            local pane = vim.env.WEZTERM_PANE

            if pane and win == vim.api.nvim_get_current_win() then
                local pane_dir = nav[dir]

                vim.system({ "wezterm", "cli", "activate-pane-direction", pane_dir }, { text = true }, function(p)
                    if p.code ~= 0 then
                        vim.notify("Failed to move to pane " .. pane_dir .. "\n" .. p.stderr, vim.log.levels.ERROR, { title = "Wezterm" }
)
                    end
                end)
            end
        end
    end
    for key, dir in pairs(nav) do
        vim.keymap.set("n", "<" .. dir .. ">", navigate(key))
        vim.keymap.set("n", "<C-" .. key .. ">", navigate(key))
    end
end
