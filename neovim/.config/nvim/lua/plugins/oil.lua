return {
    'stevearc/oil.nvim',
    dependencies = { "nvim-tree/nvim-web-devicons" },
    -- keys = {'<leader>oo'},
    -- cmd = {'Oil'},
    config = function()
        require('oil').setup(
            {
                keymaps = {
                    ["<C-/>"] = "actions.select_vsplit",
                    ["<C-->"] = "actions.select_split",
                    -- ["<C-p>"] = "actions.preview",
                    -- ["<C-l>"] = "actions.refresh",
                    -- ["<leader>fe"] = "actions.open_cwd",
                    -- ["<C-l>"] = "actions.cd",
                    -- ["<C-t>"] = "actions.tcd",
                    ["<C-l>"] = "actions.select",
                    ["<C-t>"] = "actions.select_tab",
                    ["<C-c>"] = "actions.close",
                    ["<C-h>"] = "actions.parent",
                    ["g?"] = "actions.show_help",
                    ["gs"] = "actions.change_sort",
                    ["gx"] = "actions.open_external",
                    ["g."] = "actions.toggle_hidden",
                    ["gt"] = "actions.toggle_trash",
                },
            })
        vim.keymap.set('n', '<leader>oo', "<CMD>Oil<CR>", {desc = 'Open oil'})
    end
}
