return {
    "joalof/cells.nvim",
    dev = true,
    config = function()
        -- move between cells
        vim.keymap.set("n", "]c", function()
            require("cells.delimiter").cursor_to_next_cell()
        end, { silent = true })
        vim.keymap.set("n", "[c", function()
            require("cells.delimiter").cursor_to_prev_cell()
        end, { silent = true })

        -- textobject
        vim.keymap.set({"o", "x"}, "ac", function()
            require("cells.textobject").cell("a")
        end, { silent = true })

        vim.keymap.set({"o", "x"}, "ic", function()
            require("cells.textobject").cell("i")
        end, { silent = true })
    end,
}
