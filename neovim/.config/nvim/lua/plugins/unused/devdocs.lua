return  {
    "maskudo/devdocs.nvim",
    lazy = false,
    dependencies = {
        "folke/snacks.nvim",
    },
    cmd = { "DevDocs" },
    keys = {
        {
            "<leader>ho",
            mode = "n",
            "<cmd>DevDocs get<cr>",
            desc = "Get Devdocs",
        },
        {
            "<leader>hi",
            mode = "n",
            "<cmd>DevDocs install<cr>",
            desc = "Install Devdocs",
        },
        {
            "<leader>hv",
            mode = "n",
            function()
                local devdocs = require("devdocs")
                local installedDocs = devdocs.GetInstalledDocs()
                vim.ui.select(installedDocs, {}, function(selected)
                    if not selected then
                        return
                    end
                    local docDir = devdocs.GetDocDir(selected)
                    -- prettify the filename as you wish
                    Snacks.picker.files({ cwd = docDir })
                end)
            end,
            desc = "Get Devdocs",
        },
        {
            "<leader>hd",
            mode = "n",
            "<cmd>DevDocs delete<cr>",
            desc = "Delete Devdoc",
        }
    },
    opts = {
        ensure_installed = {
            -- "lua~5.1",
        },
    },
}
