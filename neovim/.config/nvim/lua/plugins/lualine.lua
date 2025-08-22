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
        project.setup_root_caching()

        local root_icon = require("extensions.icons").kinds.Package

        vim.o.laststatus = vim.g.lualine_laststatus
        
        local function tab_name(tabnr)
            local name = vim.t[tabnr].name
            if name then
                return name
            end
            -- fallback: show buffer name
            local bufnr = vim.fn.tabpagebuflist(tabnr)[vim.fn.tabpagewinnr(tabnr)]
            return vim.fn.fnamemodify(vim.fn.bufname(bufnr), ":t")
        end
        
        local opts = {
            options = {
                component_separators = { left = "", right = "" },
                theme = "auto",
                globalstatus = vim.o.laststatus == 3,
                disabled_filetypes = { statusline = { "alpha" } },
            },
            sections = {
                lualine_a = { "mode" },
                lualine_b = {
                    {
                        function()
                            local proj = vim.fs.basename(vim.g.project_root)
                            if proj then
                                return root_icon .. proj
                            else
                                return ""
                            end
                        end,
                        padding = { left = 1, right = 0 },
                    },
                    { "branch" },
                },
                lualine_c = {
                    {
                        function()
                            return vim.fs.basename(vim.env.PWD)
                        end,
                        separator = "",
                    },
                    { "filetype", icon_only = true, padding = { left = 1, right = 0 } },
                    { "filename", path = 4 },
                },
                lualine_x = {
                    { require("recorder").recordingStatus, separator = " " },
                    { "diagnostics", sources = { "nvim_diagnostic" } },
                    { "lsp_status", symbols = { spinner = "", done = "" } },
                },
                lualine_y = {
                    { "progress", padding = { left = 1, right = 0 } },
                    { "location", padding = { left = 0, right = 1 } },
                },
                lualine_z = {
                    --     {
                    --         function()
                    --             return " " .. os.date("%R")
                    --         end,
                    --     },
                },
            },
            -- tabline = {
            --     lualine_a = { 'grapple' },
            --     lualine_z = {
            --         {
            --             function()
            --                 local s = ''
            --                 for tabnr = 1, vim.fn.tabpagenr('$') do
            --                     local hl = (tabnr == vim.fn.tabpagenr()) and '%#TabLineSel#' or '%#TabLine#'
            --                     s = s .. hl .. ' ' .. tab_name(tabnr) .. ' '
            --                 end
            --                 return s .. '%#TabLineFill#'
            --             end,
            --             separator = '',
            --         }
            --     },
            -- },
        }
        return opts
    end
}
