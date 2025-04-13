local image_spec = {
    "3rd/image.nvim",
    opts = {
        backend = "kitty", -- Kitty will provide the best experience, but you need a compatible terminal
        integrations = {}, -- do whatever you want with image.nvim's integrations
        max_width = 100, -- tweak to preference
        max_height = 12, -- ^
        max_height_window_percentage = math.huge, -- this is necessary for a good experience
        max_width_window_percentage = math.huge,

        window_overlap_clear_enabled = true,
        window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
    },
}

return {
    "benlubas/molten-nvim",
    dependencies = image_spec,
    ft = { "python" },
    build = ":UpdateRemotePlugins",
    init = function()
        vim.g.molten_image_provider = "image.nvim"
        vim.g.molten_output_win_max_height = 50
        vim.g.molten_auto_open_output = true
    end,
    config = function()
        -- map fts to available kernels
        local kernels = {
            python = "python3",
            julia = "julia",
        }

        local function auto_init()
            local filename = vim.api.nvim_buf_get_name(0)
            local ft = vim.filetype.match({ filename = filename })
            local kern = kernels[ft]
            vim.api.nvim_cmd({ cmd = "MoltenInit", args = { kern } }, {})
        end

        vim.keymap.set("n", "<leader>rm", function()
            auto_init()
            vim.keymap.set(
                "n",
                "s",
                ":MoltenEvaluateOperator<cr>",
                { buffer = 0, silent = true, desc = "Run operator selection" }
            )
            vim.keymap.set(
                "v",
                "s",
                ":<C-u>MoltenEvaluateVisual<CR>gv",
                { buffer = 0, silent = true, desc = "evaluate visual selection" }
            )
            vim.keymap.set(
                "n",
                "<leader>re",
                ":MoltenReevaluateCell<cr>",
                { buffer = 0, silent = true, desc = "Re-evaluate molten cell" }
            )
            vim.keymap.set(
                "n",
                "<leader>rk",
                ":MoltenRestart!<cr>",
                { buffer = 0, silent = true, desc = "Restart kernel" }
            )
            vim.keymap.set(
                "n",
                "<leader>rM",
                ":MoltenDeinit<cr>",
                { buffer = 0, silent = true, desc = "Shut down current kernel" }
            )
        end, { silent = true, desc = "Initialize appropriate kernel and set keymaps" })
    end,
}
