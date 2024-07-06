return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    -- stylua: ignore
    keys = {"M", "<c-l>", "<c-h>"},
    config = function()
        local harpoon = require('harpoon')
        harpoon:setup()

        local function toggle()
            local harp_list = harpoon:list()
            local fname = vim.fn.expand('%:t')
            local item = harp_list:get_by_value(fname)
            if item ~= nil then
                harp_list:remove(item)
            else
                harp_list:add()
        end
            
        end
        vim.keymap.set("n", "M", function() toggle() end)
        -- Toggle previous & next buffers stored within Harpoon list
        vim.keymap.set("n", "<c-l>", function() harpoon:list():next() end)
        vim.keymap.set("n", "<c-h>", function() harpoon:list():prev() end)
    end
}
