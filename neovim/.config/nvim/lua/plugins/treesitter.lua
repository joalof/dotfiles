return {
    "nvim-treesitter/nvim-treesitter",
    version = false,
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
        {
            "nvim-treesitter/nvim-treesitter-textobjects",
            init = function()
                -- disable rtp plugin, as we only need its queries for mini.ai
                -- In case other textobject modules are enabled, we will load them
                -- once nvim-treesitter is loaded
                require("lazy.core.loader").disable_rtp_plugin("nvim-treesitter-textobjects")
                load_textobjects = true
            end,
        },
        {
            'nvim-treesitter/playground',
        },
        -- { "RRethy/nvim-treesitter-endwise" },
    },
    cmd = { "TSUpdateSync" },
    opts = {
        highlight = { enable = true },
        indent = { enable = true, disable = { "python" } },
        ensure_installed = {
            "bash",
            "c",
            "cpp",
            "html",
            "json",
            "lua",
            "luadoc",
            "luap",
            "markdown",
            "markdown_inline",
            "python",
            "query",
            "regex",
            "vim",
            "vimdoc",
            "yaml",
        },
        playground = { enable = true },
    },
    config = function(_, opts)
        if type(opts.ensure_installed) == "table" then
            local added = {}
            opts.ensure_installed = vim.tbl_filter(function(lang)
                if added[lang] then
                    return false
                end
                added[lang] = true
                return true
            end, opts.ensure_installed)
        end

        -- endwise
        -- TODO: fix collision with ultimate autopairs cr mapping
        -- opts["endwise"] = { enable = true }

        require("nvim-treesitter.configs").setup(opts)

        if load_textobjects then
            -- PERF: no need to load the plugin, if we only need its queries for mini.ai
            if opts.textobjects then
                for _, mod in ipairs({ "move", "select", "swap", "lsp_interop" }) do
                    if opts.textobjects[mod] and opts.textobjects[mod].enable then
                        local Loader = require("lazy.core.loader")
                        Loader.disabled_rtp_plugins["nvim-treesitter-textobjects"] = nil
                        local plugin = require("lazy.core.config").plugins["nvim-treesitter-textobjects"]
                        require("lazy.core.loader").source_runtime(plugin.dir, "plugin")
                        break
                    end
                end
            end
        end
    end,
}
