local routes = {
    -- route various messages to mini view instead of notification
    -- buffer write messages
    { filter = { event = "msg_show", find = "%d+B written$" }, view = "mini" },
    { filter = { event = "msg_show", find = "%d+L, %d+B$" }, view = "mini" },

    -- undo
    { filter = { event = "msg_show", find = "%d+ more line" }, view = "mini" },
    { filter = { event = "msg_show", find = "1 line less" }, view = "mini" },
    { filter = { event = "msg_show", find = "%d+ fewer lines" }, view = "mini" },
    { filter = { event = "msg_show", find = "%d+ lines yanked" }, view = "mini" },

    -- { filter = { cmdline = true}, view = "split" },

    { -- nvim-early-retirement
        filter = {
            event = "notify",
            cond = function(msg)
                return msg.opts and msg.opts.title == "Auto-Closing Buffer"
            end,
        },
        view = "mini",
    },

    -- Treesitter
    { filter = { event = "msg_show", find = "^%[nvim%-treesitter%]" }, view = "mini" },
    { filter = { event = "notify", find = "All parsers are up%-to%-date" }, view = "mini" },

    -- Mason
    { filter = { event = "notify", find = "%[mason%-tool%-installer%]" }, view = "mini" },
    {
        filter = {
            event = "notify",
            cond = function(msg)
                return msg.opts and msg.opts.title and msg.opts.title:find("mason.*.nvim")
            end,
        },
        view = "mini",
    },

    -- Searching
    { filter = { event = "msg_show", find = "^E486: Pattern not found" }, view = "mini" },

    -- code actions, especially annoying with ruff where the fixall code action
    -- is triggered on every format
    { filter = { event = "notify", find = "^No code actions available$" }, skip = true },

    -- dap
    { filter = { event = "notify", find = "^Session terminated$" }, view = "mini" },

    -- { filter = { event = "msg_show", find = "E5108" }, view = "split" },
    -- { filter = { event = "msg_show", min_height = 10 }, view = "popup" },
    -- { filter = { event = "notify", min_height = 10 }, view = "popup" },
}

return {
    "folke/noice.nvim",
    event = "VeryLazy",
    -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
    dependencies = {
        "MunifTanjim/nui.nvim",
        "rcarriga/nvim-notify",
    },
    opts = {
        routes = routes,
        lsp = {
            -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
            override = {
                ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                ["vim.lsp.util.stylize_markdown"] = true,
                ["cmp.entry.get_documentation"] = true,
            },
        },
        -- you can enable a preset for easier configuration
        presets = {
            bottom_search = false, -- use a classic bottom cmdline for search
            long_message_to_split = true, -- long messages will be sent to a split
            inc_rename = false, -- enables an input dialog for inc-rename.nvim
            lsp_doc_border = true, -- add a border to hover docs and signature help
        },
        -- messages = {
        --     view_error = "split",
        -- },
        views = {
            cmdline_popup = {
                position = { row = "20%", col = "50%" },
            },
        },
    },
}
