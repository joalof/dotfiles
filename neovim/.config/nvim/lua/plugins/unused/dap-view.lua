return {
    "igorlfs/nvim-dap-view",
    keys = { "<leader>dm" },
    dependencies = {
        "mfussenegger/nvim-dap",
    },
    config = function()
        local dap_view = require("dap-view")
        dap_view.setup({
            -- Enable "smart" layout that uses a vertical layout if there's only
            -- a single window in the current tab
            windows = {
                position = function()
                    return vim.tbl_count(vim.iter(vim.api.nvim_tabpage_list_wins(0))
                        :filter(function(win)
                            local buf = vim.api.nvim_win_get_buf(win)
                            -- extui has some funky windows
                            return vim.bo[buf].buftype == ""
                        end)
                        :totable()) > 1 and "below" or "right"
                end,
                terminal = {
                    -- `pos` is the position for the regular window
                    position = function(pos)
                        return pos == "below" and "right" or "below"
                    end,
                },
            },
        })


        local layers = require("layers")
        debug_mode = layers.mode.new
        
        vim.keymap.set("n", "<leader>dm", function() end)
    end,
}
