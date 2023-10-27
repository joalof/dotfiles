return {
    "knubie/vim-kitty-navigator",
    build = "cp ./*.py ~/.config/kitty/",
    init = function()
        vim.g.kitty_navigator_no_mappings = 1
    end,
    config = function()
        local direction_cmds = {
            l = "KittyNavigateRight",
            h = "KittyNavigateLeft",
            j = "KittyNavigateDown",
            k = "KittyNavigateUp",
        }
        -- automatically enter terminal mode if we navigate
        -- to a terminal type buffer
        local function navigate_terminal_aware(direction)
            local cmd = direction_cmds[direction]
            vim.api.nvim_cmd({ cmd = cmd }, {})
            if vim.api.nvim_buf_get_option(0, "buftype") == "terminal" then
                vim.cmd.normal("i")
            end
        end

        local opts = { silent = true }
        for key, _ in pairs(direction_cmds) do
            vim.keymap.set({ "n", "i", "t" }, "<C-s>" .. key, function()
                navigate_terminal_aware(key)
            end, opts)
        end
    end,
}
