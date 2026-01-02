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
        highlight = { disable = { csv = true } },
        indent = { disable = { python = true } },
        parsers = {
            bash=true,
            c=true,
            comment=true,
            cpp=true,
            css=true,
            diff=true,
            git_config=true,
            git_rebase=true,
            gitcommit=true,
            gitignore=true,
            go=true,
            html=true,
            javascript=true,
            json=true,
            julia=true,
            lua=true,
            luadoc=true,
            luap=true,
            make=true,
            markdown=true,
            markdown_inline=true,
            python=true,
            query=true,
            regex=true,
            rust=true,
            toml=true,
            tsx=true,
            typescript=true,
            vim=true,
            vimdoc=true,
            xml=true,
            yaml=true,
            zig=true,
        },
    },
    config = function(_, opts)
        local ts = require("nvim-treesitter")

        local ensure_installed = vim.tbl_filter(function(val) return val end, opts.parsers)
        ts.install(ensure_installed)

        -- Enable highlighting/indent on FileType
        vim.api.nvim_create_autocmd("FileType", {
            group = vim.api.nvim_create_augroup("joakim.treesitter_setup", { clear = true }),
            desc = "Enable treesitter highlighting and indentation",
            callback = function(event)
                local lang = vim.treesitter.language.get_lang(event.match) or event.match
                if not opts.parsers[lang] then
                    return
                end
                
                if not opts.highlight.disable.lang then
                    pcall(vim.treesitter.start, event.buf)
                end
                if not opts.indent.disable.lang then
                    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                    -- vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
                end
            end,
        })
    end,
}
