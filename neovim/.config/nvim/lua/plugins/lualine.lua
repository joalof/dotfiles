return {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    init = function()
        vim.g.lualine_laststatus = vim.o.laststatus
        if vim.fn.argc(-1) > 0 then
            -- set an empty statusline until lualine loads
            vim.o.statusline = " "
        else
            -- hide the statusline on the starter page
            vim.o.laststatus = 0
        end
    end,
    opts = function()
        -- PERF: we don't need this lualine require madness
        local lualine_require = require("lualine_require")
        lualine_require.require = require

        local project = require("extensions.project")
        local fallback = "cwd"
        project.setup_root_caching(fallback)

        vim.o.laststatus = vim.g.lualine_laststatus

        local opts = {
            options = {
                theme = "auto",
                globalstatus = vim.o.laststatus == 3,
                disabled_filetypes = { statusline = { "alpha" } },
            },
            sections = {
                lualine_a = { "mode" },
                lualine_b = {
                    {
                        function()
                            return vim.fs.basename(vim.g.project_root)
                        end,
                        separator = "",
                        padding = { left = 1, right = 0 },
                    },
                    { "branch" },
                },
                lualine_c = {
                    { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
                    { "filename", path = 4, separator = "" },
                },
                lualine_x = {
                    { require('recorder').recordingStatus, separator = " "},
                    { "lsp_status" },
                },
                lualine_y = {
                    { "progress", separator = " ", padding = { left = 1, right = 0 } },
                    { "location", padding = { left = 0, right = 1 } },
                },
                lualine_z = {
                    function()
                        return " " .. os.date("%R")
                    end,
                },
            },
            -- extensions = { "lazy" },
        }
        return opts
    end,
}
