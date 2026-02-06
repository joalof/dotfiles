return {
    "knubie/vim-kitty-navigator",
    commit = '2aafc20a0a4eb3efa757db51868a2ab181e88690',
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
        local function navigate(direction)
            local cmd = direction_cmds[direction]
            vim.api.nvim_cmd({ cmd = cmd }, {})
        end

        local opts = { silent = true }
        for key, _ in pairs(direction_cmds) do
            vim.keymap.set({ "n", "i", "t" }, "<C-s>" .. key, function()
                navigate(key)
            end, opts)
        end
    end,
}
