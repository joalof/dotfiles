return {
    "stevearc/aerial.nvim",
    -- Optional dependencies
    cmd = { "AerialToggle", "AerialOpen", "AerialOpenAll", "AerialNavOpen" },
    keys = { { "<leader>vv", "<cmd>AerialToggle!<CR>" } },
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-tree/nvim-web-devicons",
    },
    config = function()
        require("aerial").setup({
            layout = {
                default_direction = "prefer_left",
            },
            close_automatic_events = { "unsupported" },

            -- optionally use on_attach to set keymaps when aerial has attached to a buffer
            on_attach = function(bufnr)
                -- Jump forwards/backwards with '{' and '}'
                vim.keymap.set("n", "(", "<cmd>AerialPrev<CR>", { buffer = bufnr })
                vim.keymap.set("n", ")", "<cmd>AerialNext<CR>", { buffer = bufnr })
                vim.keymap.set("n", "{", function()
                    require("aerial").prev_up()
                end, { buffer = bufnr })
                vim.keymap.set("n", "}", function()
                    require("aerial").next_up()
                end, { buffer = bufnr })
            end,
        })
        -- You probably also want to set a keymap to toggle aerial
        -- vim.keymap.set("n", "<leader>vv", "<cmd>AerialToggle!<CR>")
    end,
}
