return {
    "saghen/blink.cmp",
    -- dependencies = { 'rafamadriz/friendly-snippets' },
    build = "cargo build --release",
    dependencies = { "echasnovski/mini.icons" },

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
        keymap = {
            preset = "default",
            ["<C-i>"] = { "accept", "fallback" },
        },
        appearance = {
            nerd_font_variant = "normal",
        },
        completion = {
            documentation = { auto_show = true, window = { border = "rounded" } },
            list = { selection = { preselect = true, auto_insert = false } },
            accept = { auto_brackets = { enabled = true } },
            keyword = { range = "full" },
            ghost_text = { enabled = false },
            menu = {
                border = "rounded",
                draw = {
                    components = {
                        kind_icon = {
                            text = function(ctx)
                                local kind_icon = require('icons').kinds[ctx.kind]
                                if not kind_icon then
                                    kind_icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
                                end
                                return kind_icon
                            end,
                            -- (optional) use highlights from mini.icons
                            highlight = function(ctx)
                                local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
                                return hl
                            end,
                        },
                        kind = {
                            -- (optional) use highlights from mini.icons
                            highlight = function(ctx)
                                local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
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
        sources = {
            default = { "lazydev", "lsp", "path", "buffer", "cmdline" },
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
                ghost_text = { enabled = true },
                list = { selection = { preselect = true, auto_insert = false } },
            },
        },
    },
    config = function(_, opts)
        local blink = require("blink.cmp")
        blink.setup(opts)

        vim.api.nvim_create_autocmd("InsertLeave", {
            group = vim.api.nvim_create_augroup("joakim.blink_close", { clear = true }),
            desc = "Close blink completion menu",
            callback = function()
                require("blink.cmp").cancel()
            end,
        })
    end,
}
