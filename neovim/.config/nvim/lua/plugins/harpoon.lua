return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dev = true,
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    -- stylua: ignore
    keys = {"M", "<c-l>", "<c-h>"},
    config = function()
        local harpoon = require('harpoon')
        local project = require('utils.project')
        local harp_utils = require('utils.harpoon')

        harpoon:setup({
            settings = {
                key = function()
                    local res = project.get_root('cwd')
                    return res
                end
            },
            default = {
                create_list_item = function(config, name)
                    name = name or vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf())
                    local bufnr = vim.fn.bufnr(name, false)
                    local pos = { 1, 0 }
                    if bufnr ~= -1 then
                        pos = vim.api.nvim_win_get_cursor(0)
                    end
                    return {
                        value = name,
                        context = {
                            row = pos[1],
                            col = pos[2],
                        },
                    }
                end,
            }
        })

        vim.keymap.set("n", "M", function()
            harpoon:list(harp_utils.curr_branch_list):add()
            -- harpoon:list():add()
        end)
        -- Toggle previous & next buffers stored within Harpoon list
        vim.keymap.set(
            "n",
            "<c-l>",
            function() harpoon:list(harp_utils.curr_branch_list):next() end
            -- function() harpoon:list():next() end
        )
        vim.keymap.set(
            "n",
            "<c-h>",
            function() harpoon:list(harp_utils.curr_branch_list):prev() end
            -- function() harpoon:list():prev() end
        )

        vim.api.nvim_create_augroup("harpoon_config", { clear = true })
        vim.api.nvim_create_autocmd({"DirChanged", "TabEnter"}, {
            group = "harpoon_config",
            desc = "Update the current project list",
            callback = harp_utils.update_current_list,
        })
    end
}
