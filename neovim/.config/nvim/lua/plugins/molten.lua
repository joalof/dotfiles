return {
    "benlubas/molten-nvim",
    dependencies = { "3rd/image.nvim" },
    build = ":UpdateRemotePlugins",
    init = function()
        -- these are examples, not defaults. Please see the readme
        vim.g.molten_image_provider = "image.nvim"
        vim.g.molten_output_win_max_height = 50
        vim.g.molten_auto_open_output = true
    end,
    config = function()
        -- some functionality for kernel auto-initialization
        local kernels = {
            python = "python3",
        }

        local active_kernels = {}
        for _, kern in pairs(kernels) do
            active_kernels[kern] = false
        end

        local function with_init(cmd)
            cmd = cmd or {}
            local filename = vim.api.nvim_buf_get_name(0)
            local ft = vim.filetype.match({ filename = filename })
            local kern = kernels[ft]
            if not active_kernels[kern] then
                vim.api.nvim_cmd({ cmd = "MoltenInit", args = { kern } }, {})
                active_kernels[kern] = true
            end
            if #cmd > 0 then
                vim.api.nvim_cmd(cmd, {})
            end
        end

        vim.api.nvim_create_user_command("MoltenMaybeInit", function()
            with_init()
        end, {bar=true})

        vim.keymap.set("n", "gr", function()
            with_init("MoltenEvaluateOperator")
        end, { silent = true, noremap = true, desc = "Run operator selection" })

        vim.keymap.set("n", "<leader>rl", function()
            with_init({ cmd = "MoltenEvaluateLine" })
        end, { silent = true, noremap = true, desc = "Evaluate line" })

        vim.keymap.set("n", "<leader>rc", function()
            with_init({ cmd = "MoltenReevaluateCell" })
        end, { silent = true, noremap = true, desc = "Re-evaluate cell" })

        vim.keymap.set("v", "<leader>rv", ":<C-u>MoltenMaybeInit | MoltenEvaluateVisual<CR>",
            { silent = true, noremap = true, desc = "Evaluate visual selection" })

        vim.keymap.set("n", "<leader>rn", ":MoltenRestart!",
            { silent = true, noremap = true, desc = "Restart kernel" })

    end,
}
