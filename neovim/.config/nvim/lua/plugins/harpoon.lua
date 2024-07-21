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

        harpoon:setup({
            settings = {
                key = function()
                    return project.get_root('cwd')
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

        -- local function toggle(list_name)
        --     local harp_list = harpoon:list(list_name)
        --     local fname = vim.fn.expand('%')
        --     local item = harp_list:get_by_value(fname)
        --     if item ~= nil then
        --         harp_list:remove(item)
        --     else
        --         harp_list:add()
        --     end
        -- end

        local function notify_mark(action)
            local pos = vim.api.nvim_win_get_cursor(0)
            local pos_disp = string.format('%d:%d', pos[1], pos[2])
            local msg = string.format('Harpoon mark %s at %s', action, pos_disp)
            vim.notify(msg)
        end

        local tabline = require('utils.tabline')

        vim.keymap.set("n", "ma", function()
            local branch = project.get_git_branch()
            harpoon:list(branch):add()
            notify_mark('added')
            tabline.update_marks(branch)
        end)

        vim.keymap.set("n", "md", function()
            local branch = project.get_git_branch()
            harpoon:list(branch):remove()
            notify_mark('removed')
            tabline.update_marks(branch)
        end)
        
        -- Toggle previous & next buffers stored within Harpoon list
        vim.keymap.set(
            "n",
            "<c-l>",
            function() harpoon:list(project.get_git_branch()):next() end
            -- function() harpoon:list():next() end
        )
        vim.keymap.set(
            "n",
            "<c-h>",
            function() harpoon:list(project.get_git_branch()):prev() end
            -- function() harpoon:list():prev() end
        )
    end
}
