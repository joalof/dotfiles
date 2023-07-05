return {
    'echasnovski/mini.ai',
    config = function ()
        local MiniAi = require('mini.ai')
        -- local cells = require('lib.cells')
        -- cells.setup('%%')
        -- vim.keymap.set('n', ']d', cells.cursor_to_next_cell, {silent=true})
        -- vim.keymap.set('n', '[d', cells.cursor_to_previous_cell, {silent=true})
        -- MiniAi.setup({
        --     custom_textobjects = {
        --         d = cells.get_cell_region
        --     }
        -- })
        -- vim.keymap.del({'o', 'x', 'n'}, 'g]')
        -- vim.keymap.del({'o', 'x', 'n'}, 'g[')
    end,
}
