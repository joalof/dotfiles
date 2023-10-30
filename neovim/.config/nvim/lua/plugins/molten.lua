local rocks_spec = {
    "theHamsta/nvim_rocks",
    build = "wget https://raw.githubusercontent.com/luarocks/hererocks/master/hererocks.py && python3 hererocks.py . -j2.1.0-beta3 -r3.9.2 && cp nvim_rocks.lua lua",
    config = function()
        local nvim_rocks = require("nvim_rocks")
        nvim_rocks.ensure_installed("magick")
    end,
}

local image_spec = {
    "3rd/image.nvim",
    dependencies = { rocks_spec },
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
    -- keys = {"<leader>rs"},
    -- cmd = {"MoltenMaybeInit", "MoltenInit"},
    dependencies = image_spec,
    ft = { "python" },
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

        local function auto_init()
            local filename = vim.api.nvim_buf_get_name(0)
            local ft = vim.filetype.match({ filename = filename })
            local kern = kernels[ft]
            vim.api.nvim_cmd({ cmd = "MoltenInit", args = { kern } }, {})
        end

        vim.keymap.set("n", "rs", function()
            auto_init()
        end, { silent = true, desc = "Initialize kernel if necessary" })

        vim.api.nvim_create_user_command("MoltenAutoInit", function()
            auto_init()
        end, { bar = true })

        vim.keymap.set("n", "gr", ":MoltenEvaluateOperator<cr>", { silent = true, desc = "Run operator selection" })
        vim.keymap.set(
            "n",
            "<leader>rv",
            ":<C-u>MoltenEvaluateVisual<CR>",
            { silent = true, desc = "Evaluate visual selection" }
        )
        vim.keymap.set("n", "<leader>rl", ":MoltenEvaluateLine<cr>", { silent = true, desc = "Evaluate line" })
        vim.keymap.set("n", "<leader>re", ":MoltenReevaluateCell<cr>", { silent = true, desc = "Re-evaluate molten cell" })
        vim.keymap.set("n", "<leader>rn", ":MoltenRestart!<cr>", { silent = true, desc = "Restart kernel" })

        -- keep track of active kernels
        -- local active_kernels = {}
        -- for _, kern in pairs(kernels) do
        --     active_kernels[kern] = false
        -- end

        -- Wraps a molten command with a lazy initialization that only calls MoltenInit
        -- for inactive kernels.
        -- local function with_init(cmd_table)
        --     cmd_table = cmd_table or {}
        --     local filename = vim.api.nvim_buf_get_name(0)
        --     local ft = vim.filetype.match({ filename = filename })
        --     local kern = kernels[ft]
        --     if not active_kernels[kern] then
        --         vim.api.nvim_cmd({ cmd = "MoltenInit", args = { kern } }, {})
        --         active_kernels[kern] = true
        --     end
        --     if cmd_table.cmd then
        --         vim.api.nvim_cmd(cmd_table, {})
        --     end
        -- end

        -- Add a user command for lazy initialization
        -- (primarily for use with MoltenEvaluateVisual)
        -- vim.api.nvim_create_user_command("MoltenMaybeInit", function()
        --     with_init()
        -- end, { bar = true })

        -- vim.keymap.set("n", "rs", function()
        --     with_init()
        -- end, { silent = true, desc = "Initialize kernel if necessary" })
        --
        -- vim.keymap.set("n", "gr", function()
        --     with_init({ cmd = "MoltenEvaluateOperator" })
        -- end, { silent = true, desc = "Run operator selection" })
        --
        -- vim.keymap.set(
        --     "n",
        --     "<leader>rc",
        --     "<C-u>MoltenMaybeInit | MoltenEvaluateVisual<CR>",
        --     { silent = true, desc = "Evaluate visual selection" }
        -- )
        --
        -- vim.keymap.set("n", "<leader>rl", function()
        --     with_init({ cmd = "MoltenEvaluateLine" })
        -- end, { silent = true, desc = "Evaluate line" })
        --
        -- vim.keymap.set("n", "<leader>re", function()
        --     with_init({ cmd = "MoltenReevaluateCell" })
        -- end, { silent = true, desc = "Re-evaluate molten cell" })
        --
        -- vim.keymap.set(
        --     "v",
        --     "<leader>rv",
        --     ":<C-u>MoltenMaybeInit | MoltenEvaluateVisual<CR>",
        --     { silent = true, desc = "Evaluate visual selection" }
        -- )
    end,
}
