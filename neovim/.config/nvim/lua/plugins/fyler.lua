return {
    "A7Lavinraj/fyler.nvim",
    dependencies = { "echasnovski/mini.icons" },
    lazy = false, -- Necessary for `default_explorer` to work properly
    config = function()
        local fyler = require("fyler")
        fyler.setup({
            views = {
                finder = {
                    columns = {
                        git = { enabled = false },
                        diagnostic = { enabled = false },
                    },
                    mappings = {
                        ["q"] = "CloseView",
                        ["<CR>"] = "Select",
                        ["<C-j>"] = "Select",
                        ["<C-t>"] = "SelectTab",
                        ["|"] = "SelectVSplit",
                        ["-"] = "SelectSplit",
                        ["<C-h>"] = "GotoParent",
                        ["="] = "GotoCwd",
                        ["<C-l>"] = "GotoNode",
                        ["#"] = "CollapseAll",
                        ["<BS>"] = "CollapseNode",
                    },
                    win = {
                        kinds = {
                            split_left_most = {
                                width = "20%",
                            },
                        },
                    },
                },
            },
        })
        vim.keymap.set("n", "<leader>of", function()
            fyler.toggle({
                -- dir = vim.fn.expand("%:p:h"),
                dir = vim.uv.cwd(),
                kind = "split_left_most",
            })
        end)
    end,
}
