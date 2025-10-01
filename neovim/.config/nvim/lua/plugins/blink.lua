return {
    "saghen/blink.cmp",
    -- dependencies = { 'rafamadriz/friendly-snippets' },
    -- version = "1.*",
    build = 'cargo build --release',
    dependencies = { "onsails/lspkind.nvim", "nvim-tree/nvim-web-devicons" },

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
        -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
        -- 'super-tab' for mappings similar to vscode (tab to accept)
        -- 'enter' for enter to accept
        -- 'none' for no mappings
        --
        -- All presets have the following mappings:
        -- C-space: Open menu or open docs if already open
        -- C-n/C-p or Up/Down: Select next/previous item
        -- C-e: Hide menu
        -- C-k: Toggle signature help (if signature.enabled = true)
        --
        -- See :h blink-cmp-config-keymap for defining your own keymap
        keymap = {
            preset = "default",
            ["<C-i>"] = { "accept", "fallback" },
        },
        appearance = {
            nerd_font_variant = "normal",
        },
        completion = {
            documentation = { auto_show = true },
            list = { selection = { preselect = true, auto_insert = true } },
            accept = { auto_brackets = { enabled = true } },
            keyword = { range = "full" },
            menu = {
                draw = {
                    components = {
                        kind_icon = {
                            text = function(ctx)
                                local icon = ctx.kind_icon
                                if vim.tbl_contains({ "Path" }, ctx.source_name) then
                                    local dev_icon, _ = require("nvim-web-devicons").get_icon(ctx.label)
                                    if dev_icon then
                                        icon = dev_icon
                                    end
                                else
                                    icon = require("lspkind").symbolic(ctx.kind, {
                                        mode = "symbol",
                                    })
                                end

                                return icon .. ctx.icon_gap
                            end,

                            -- Optionally, use the highlight groups from nvim-web-devicons
                            -- You can also add the same function for `kind.highlight` if you want to
                            -- keep the highlight groups in sync with the icons.
                            highlight = function(ctx)
                                local hl = ctx.kind_hl
                                if vim.tbl_contains({ "Path" }, ctx.source_name) then
                                    local dev_icon, dev_hl = require("nvim-web-devicons").get_icon(ctx.label)
                                    if dev_icon then
                                        hl = dev_hl
                                    end
                                end
                                return hl
                            end,
                        },
                    },
                },
            },
        },
        signature = {
            enabled = false,
        },
        -- Default list of enabled providers defined so that you can extend it
        -- elsewhere in your config, without redefining it, due to `opts_extend`
        -- -- can add snipper
        sources = {
            default = { "lsp", "path", "buffer", "cmdline", "lazydev" },
            providers = {
                lazydev = {
                    name = "LazyDev",
                    module = "lazydev.integrations.blink",
                    score_offset = 100, -- make lazydev completions top priority (see `:h blink.cmp`)
                },
            },
        },
        fuzzy = { implementation = "prefer_rust_with_warning" },
        cmdline = {
            keymap = {
                ["<C-i>"] = { "accept", "fallback" },
            },
            completion = {
                menu = { auto_show = true },
                ghost_text = { enabled = false },
                list = { selection = { preselect = true, auto_insert = true } },
            },
        },
    },
}
