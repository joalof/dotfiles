return {
    "ThePrimeagen/harpoon",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    keys = {
        {
            "M",
            function()
                local mark = require("harpoon.mark")
                local i = mark.get_current_index()
                mark.toggle_file(i)
            end,
        },
        {
            "L",
            function()
                require("harpoon.ui").nav_next()
            end,
        },
        {
            "H",
            function()
                require("harpoon.ui").nav_prev()
            end,
        },
    },
    opts = {
        global_settings = {
            mark_branch = true,
        },
    },
}
