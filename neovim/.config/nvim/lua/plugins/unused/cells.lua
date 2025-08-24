return {
    "joalof/cells.nvim",
    -- dev=true,
    filetype = {'python', 'julia', 'R'},
    config = function()
        require("cells").setup({
            textobject = "c",
        })
        -- move between cells
        vim.keymap.set("n", "]c", function()
            require("cells.editing").cursor_to_next_cell()
        end, { silent = true })
        vim.keymap.set("n", "[c", function()
            require("cells.editing").cursor_to_prev_cell()
        end, { silent = true })
    end,
}
