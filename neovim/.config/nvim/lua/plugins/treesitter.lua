return {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
        "nvim-treesitter/nvim-treesitter-context",
        {
            "nvim-treesitter/nvim-treesitter-textobjects",
            branch = "main",
        },
    },
    event = "VeryLazy",
    branch = "main",
    build = ":TSUpdate",
    opts = {
        highlight = { disable = {} },
        indent = { disable = { python = true } },
        ensure_installed = {
            "bash",
            "c",
            "comment",
            "cpp",
            "css",
            "diff",
            "git_config",
            "git_rebase",
            "gitcommit",
            "gitignore",
            "html",
            "javascript",
            "json",
            "julia",
            "lua",
            "luadoc",
            "luap",
            "make",
            "markdown",
            "markdown_inline",
            "python",
            "query",
            "regex",
            "toml",
            "tsx",
            "typescript",
            "vim",
            "vimdoc",
            "xml",
            "yaml",
        },
    },
    config = function(_, opts)
        local ts = require("nvim-treesitter")
        ts.install(opts.ensure_installed)

        local ignore_filetypes = {
            checkhealth = true,
            lazy = true,
            mason = true,
            snacks_dashboard = true,
            snacks_notif = true,
            snacks_win = true,
            snacks_input = true,
            prompt = true,
        }

        -- Enable highlighting/indent on FileType
        vim.api.nvim_create_autocmd("FileType", {
            group = vim.api.nvim_create_augroup("joakim.treesitter_setup", { clear = true }),
            desc = "Enable treesitter highlighting and indentation",
            callback = function(event)
                if ignore_filetypes[event.match] then
                    return
                end

                local lang = vim.treesitter.language.get_lang(event.match)
                local ft = vim.bo[event.buf].ft

                ts.install({ lang }):await(function(err)
                    if err then
                        vim.notify("Treesitter install error for ft: " .. ft .. " err: " .. err)
                        return
                    end

                    if not opts.highlight.disable.lang then
                        pcall(vim.treesitter.start, event.buf)
                    end
                    if not opts.indent.disable.lang then
                        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                        -- vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
                    end
                end)
            end,
        })
    end,
}
