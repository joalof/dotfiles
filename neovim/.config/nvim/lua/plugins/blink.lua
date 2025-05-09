return {
    'saghen/blink.cmp',
    -- dependencies = { 'rafamadriz/friendly-snippets' },
    version = '1.*',

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
            preset = 'default',
            ["<C-i>"] = {'select_next', 'fallback'},
            ["<C-y>"] = {'accept', 'fallback'},
        },

        appearance = {
            nerd_font_variant = 'normal'
        },

        completion = {
            documentation = { auto_show = true },
            list = { selection = { preselect = false, auto_insert = true } },
            accept = { auto_brackets = { enabled = true }, },
        },
        signature = {
            enabled = false
        },

        -- Default list of enabled providers defined so that you can extend it
        -- elsewhere in your config, without redefining it, due to `opts_extend`
        -- -- can add snipper
        sources = {
            default = { 'lsp', 'path', 'buffer', 'cmdline', 'lazydev'},
            providers = {
                lazydev = {
                    name = 'LazyDev',
                    module = 'lazydev.integrations.blink',
                    score_offset = 100, -- make lazydev completions top priority (see `:h blink.cmp`)
                },
            }
        },
        fuzzy = { implementation = "prefer_rust_with_warning" }
    },
    opts_extend = { "sources.default" }
}
