return {
    "benlubas/molten-nvim",
    dependencies = { "3rd/image.nvim" },
    build = ":UpdateRemotePlugins",
    init = function()
        vim.g.molten_image_provider = "image.nvim"
        vim.g.molten_output_win_max_height = 50
        vim.g.molten_auto_open_output = true
    end,
    config = function()
        -- Below we add some functionality for kernel auto-initialization

        -- map fts to available kernels
        local kernels = {
            python = "python3",
        }

        -- keep track of active kernels
        local active_kernels = {}
        for _, kern in pairs(kernels) do
            active_kernels[kern] = false
        end

        -- Wraps a molten command with a lazy initialization that only calls MoltenInit
        -- for inactive kernels.
        local function with_init(cmd_table)
            cmd_table = cmd_table or {}
            local filename = vim.api.nvim_buf_get_name(0)
            local ft = vim.filetype.match({ filename = filename })
            local kern = kernels[ft]
            if not active_kernels[kern] then
                vim.api.nvim_cmd({ cmd = "MoltenInit", args = { kern } }, {})
                active_kernels[kern] = true
            end
            if cmd_table.cmd then
                vim.api.nvim_cmd(cmd_table, {})
            end
        end

        -- Add a user command for lazy initialization
        -- (primarily for use with MoltenEvaluateVisual)
        vim.api.nvim_create_user_command("MoltenMaybeInit", function()
            with_init()
        end, { bar = true })

        vim.keymap.set("n", "gr", function()
            with_init({ cmd = "MoltenEvaluateOperator" })
        end, { silent = true, desc = "Run operator selection" })

        vim.keymap.set(
            "n",
            "<leader>rc",
            "<C-u>MoltenMaybeInit | MoltenEvaluateVisual<CR>",
            { silent = true, desc = "Evaluate visual selection" }
        )

        vim.keymap.set("n", "<leader>rl", function()
            with_init({ cmd = "MoltenEvaluateLine" })
        end, { silent = true, desc = "Evaluate line" })

        vim.keymap.set("n", "<leader>re", function()
            with_init({ cmd = "MoltenReevaluateCell" })
        end, { silent = true, desc = "Re-evaluate molten cell" })

        vim.keymap.set(
            "v",
            "<leader>rv",
            ":<C-u>MoltenMaybeInit | MoltenEvaluateVisual<CR>",
            { silent = true, desc = "Evaluate visual selection" }
        )

        vim.keymap.set("n", "<leader>rn", ":MoltenRestart!", { silent = true, desc = "Restart kernel" })
    end,
}
