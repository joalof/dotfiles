return {
    "hrsh7th/nvim-cmp",
    dependencies = {
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        'saadparwaiz1/cmp_luasnip',
        "hrsh7th/cmp-nvim-lsp",
        'hrsh7th/cmp-nvim-lua',
        'hrsh7th/cmp-omni',
        'onsails/lspkind.nvim',
        "hrsh7th/cmp-cmdline",
    },
    event = "InsertEnter",
    config = function()
        local cmp = require('cmp')
        cmp.setup {
            sources = cmp.config.sources { { name = 'omni', }, }
        }

        local function check_back_space()
            local col = vim.fn.col('.') - 1
            if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
                return true
            else
                return false
            end
        end

        cmp.setup {
            completion = {
                completeopt = 'menuone,noselect'
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
                ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
                ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
                ['<C-u>'] = cmp.mapping.scroll_docs(-4),
                ['<C-d>'] = cmp.mapping.scroll_docs(4),
                -- ['<C-j'] = cmp.mapping.complete(),
                ['<C-c>'] = cmp.mapping.abort(),
                -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                ['<C-y>'] = cmp.mapping.confirm({ select = true }),
                -- ['<CR>'] = cmp.mapping.confirm({ select = true }),
                -- tab mapping
                ['<Tab>'] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    elseif require("luasnip").jumpable(1) then
                        require("luasnip").jump(1)
                    elseif check_back_space() then
                        fallback()
                    else
                        cmp.complete()
                    end
                end, { 'i', 's' }),
                -- reverse direction with shift-tab
                ['<S-Tab>'] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    elseif require("luasnip").jumpable(-1) then
                        require("luasnip").jump(-1)
                    elseif check_back_space() then
                        fallback()
                    else
                        cmp.complete()
                    end
                end, { 'i', 's' }),
            },
            sources = {
                { name = 'nvim_lsp', max_item_count = 5 },
                { name = "codeium",  max_item_count = 5 },
                { name = 'buffer',   max_item_count = 5 },
                { name = 'luasnip', max_item_count = 5 },
                { name = 'nvim_lua' },
                { name = 'path',     max_item_count = 10 },
            },
            formatting = {
                format = require('lspkind').cmp_format {
                    mode = 'symbol_text',
                    symbol_map = { Codeium = "", },
                }
            },
        }
        -- completion for search /
        cmp.setup.cmdline('/', {
            mapping = cmp.mapping.preset.cmdline(),
            sources = {
                { name = 'buffer' }
            }
        })
        -- completion for commands :
        cmp.setup.cmdline(':', {
            mapping = cmp.mapping.preset.cmdline(),
            sources = cmp.config.sources({
                { name = 'path' }
            }, {
                {
                    name = 'cmdline',
                    option = {
                        ignore_cmds = { 'Man', '!' }
                    }
                }
            })
        })
    end,
}
