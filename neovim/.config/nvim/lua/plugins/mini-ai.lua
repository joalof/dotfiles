return {
    "nvim-mini/mini.ai",
    event = "VeryLazy",
    -- dependencies = { "nvim-treesitter-textobjects" },
    config = function()
        local ai = require("mini.ai")
        ai.setup({
            n_lines = 500,
            mappings = {
                goto_left = "",
                goto_right = "",
                around_next = "",
                inside_next = "",
                around_last = "",
                inside_last = "",
            },
            custom_textobjects = {
                o = ai.gen_spec.treesitter({
                    a = { "@block.outer", "@conditional.outer", "@loop.outer" },
                    i = { "@block.inner", "@conditional.inner", "@loop.inner" },
                }, {}),
                f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
                c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
                -- u = function(ai_type, _, opts)
                --     local ts_utils = require("nvim-treesitter.ts_utils")
                --
                --     -- Get cursor position from mini.ai options
                --     local cursor_pos = opts.reference_region.from
                --     -- Treesitter APIs use 0-based row/col
                --     local r = cursor_pos.line - 1
                --     local c = cursor_pos.col - 1
                --
                --     local root = ts_utils.get_root_for_position(r, c)
                --     if not root then
                --         return nil
                --     end
                --
                --     local node = root:named_descendant_for_range(r, c, r, c)
                --     if not node then
                --         return nil
                --     end
                --
                --     -- This is the logic from `get_main_node` in treesitter-unit.lua.
                --     -- It finds the outermost node that starts on the same line.
                --     local parent = node:parent()
                --     local start_row = node:start()
                --     while parent and parent ~= root and parent:start() == start_row do
                --         node = parent
                --         parent = node:parent()
                --     end
                --
                --     -- Get the 0-based range from the final node
                --     local s_row, s_col, e_row, e_col = node:range()
                --
                --     -- `i` textobject: the precise node
                --     if ai_type == "i" then
                --         return {
                --             from = { line = s_row + 1, col = s_col + 1 },
                --             -- end_col from node:range() is exclusive, mini.ai is inclusive
                --             to = { line = e_row + 1, col = e_col },
                --         }
                --     end
                --
                --     -- `a` textobject: the whole lines spanned by the node
                --     if ai_type == "a" then
                --         local bufnr = vim.api.nvim_get_current_buf()
                --         local end_line_text = vim.api.nvim_buf_get_lines(bufnr, e_row, e_row + 1, false)[1] or ""
                --         return {
                --             from = { line = s_row + 1, col = 1 },
                --             to = { line = e_row + 1, col = #end_line_text + 1 },
                --             vis_mode = "V", -- Force linewise selection
                --         }
                --     end
                -- end,
            },
        })
    end,
}
