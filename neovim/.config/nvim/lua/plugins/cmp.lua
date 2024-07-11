return {
    "hrsh7th/nvim-cmp",
    dependencies = {
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "saadparwaiz1/cmp_luasnip",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-nvim-lua",
        "hrsh7th/cmp-omni",
        "onsails/lspkind.nvim",
        "hrsh7th/cmp-cmdline",
        "octaltree/cmp-look",
        "micangl/cmp-vimtex",
    },
    event = "InsertEnter",
    config = function()
        local cmp = require("cmp")
        cmp.setup({
            sources = cmp.config.sources({ { name = "omni" } }),
        })

        local function check_back_space()
            local col = vim.fn.col(".") - 1
            if col == 0 or vim.fn.getline("."):sub(col, col):match("%s") then
                return true
            else
                return false
            end
        end

        cmp.setup({
            completion = {
                completeopt = "menuone,noselect",
            },
            -- snippets
            snippet = {
                expand = function(args)
                    require("luasnip").lsp_expand(args.body)
                end,
            },
            -- experimental = {
            --     ghost_text = true,
            -- },
            -- key mappings
            mapping = {
                ["<C-n>"] = cmp.mapping.select_next_item({
                    behavior = cmp.SelectBehavior.Insert,
                }),
                ["<C-p>"] = cmp.mapping.select_prev_item({
                    behavior = cmp.SelectBehavior.Insert,
                }),
                ["<C-u>"] = cmp.mapping.scroll_docs(-4),
                ["<C-d>"] = cmp.mapping.scroll_docs(4),
                -- ['<C-j'] = cmp.mapping.complete(),
                ["<C-c>"] = cmp.mapping.abort(),
                -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                ["<C-y>"] = cmp.mapping.confirm({ select = true }),
                -- ['<CR>'] = cmp.mapping.confirm({ select = true }),
                -- tab mapping
                ["<Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    elseif require("luasnip").jumpable(1) then
                        require("luasnip").jump(1)
                    elseif check_back_space() then
                        fallback()
                    else
                        cmp.complete()
                    end
                end, { "i", "s" }),
                -- reverse direction with shift-tab
                ["<S-Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    elseif require("luasnip").jumpable(-1) then
                        require("luasnip").jump(-1)
                    elseif check_back_space() then
                        fallback()
                    else
                        cmp.complete()
                    end
                end, { "i", "s" }),
            },
            sources = {
                -- { name = "codeium", max_item_count = 2, group_index = 1 },
                { name = "nvim_lsp", max_item_count = 20, group_index = 1 },
                { name = "luasnip", max_item_count = 4, group_index = 1 },
                { name = "buffer", max_item_count = 4, group_index = 1 },
                { name = "nvim_lua", max_item_count = 5, group_index = 1 },
                { name = "path", max_item_count = 20, group_index = 1 },
            },
            formatting = {
                format = require("lspkind").cmp_format({
                    mode = "symbol_text",
                    -- symbol_map = { Codeium = "" },
                }),
            },
        })
        -- completion for search /
        cmp.setup.cmdline({ "/", "?" }, {
            mapping = cmp.mapping.preset.cmdline(),
            sources = {
                { name = "buffer" },
            },
        })
        -- completion for commands :
        cmp.setup.cmdline(":", {
            mapping = cmp.mapping.preset.cmdline(),
            sources = cmp.config.sources({
                { name = "path", group_index = 1 },
                {
                    name = "cmdline",
                    option = {
                        ignore_cmds = { "Man", "!" },
                    },
                    group_index = 2,
                },
            }),
        })

        -- File-specific sources: these will override the default sources declared above
        local look_source = {
            name = "look",
            keyword_length = 2,
            option = {
                convert_case = true,
                loud = true,
                --dict = '/usr/share/dict/words'
            },
            max_item_count = 5,
        }

        -- Markup files
        local filetypes_markup = { "markdown", "rst" }
        for _, ft in ipairs(filetypes_markup) do
            cmp.setup.filetype(ft, {
                sources = cmp.config.sources({
                    { name = "nvim_lsp", max_item_count = 8 },
                    { name = "luasnip", max_item_count = 5 },
                    { name = "buffer", max_item_count = 5 },
                    look_source,
                }),
            })
        end

        -- TeX
        cmp.setup.filetype("tex", {
            sources = {
                { name = "vimtex", max_item_count = 8 },
                { name = "luasnip", max_item_count = 5 },
                { name = "buffer", max_item_count = 5 },
                look_source,
            },
        })

        -- special buffer local setup for the Cmdwin since
        -- it can't handle codeium
        local augrp_cmdwin = vim.api.nvim_create_augroup("augrp_cmdwin", { clear = true })
        vim.api.nvim_create_autocmd({ "CmdwinEnter" }, {
            group = augrp_cmdwin,
            callback = function()
                cmp.setup.buffer({
                    sources = {
                        { name = "buffer", max_item_count = 5, group_index = 1 },
                        { name = "nvim_lua", max_item_count = 5, group_index = 1 },
                        { name = "path", max_item_count = 20, group_index = 1 },
                    },
                })
            end,
        })
    end,
}
