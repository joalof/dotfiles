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
    },
    event = "InsertEnter",
    config = function()
        local cmp = require('cmp')
        cmp.setup {
            sources = cmp.config.sources { { name = 'omni', }, }
        }

        local function check_back_space ()
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
                    require('luasnip').lsp_expand(args.body)
                end,
            },
            -- key mappings
            mapping = {
                ["<C-n>"] = cmp.mapping.select_next_item({behavior = cmp.SelectBehavior.Insert}),
                ["<C-p>"] = cmp.mapping.select_prev_item({behavior = cmp.SelectBehavior.Insert}),
                ['<C-u>'] = cmp.mapping.scroll_docs(-4),
                ['<C-d>'] = cmp.mapping.scroll_docs(4),
                -- ['<C-j'] = cmp.mapping.complete(),
                -- ['<C-e>'] = cmp.mapping.abort(),
                -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                ['<C-y>'] = cmp.mapping.confirm({select = true}), 
                -- ['<CR>'] = cmp.mapping.confirm({ select = true }),
                -- tab mapping
                ['<Tab>'] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item(select_opts)
                    elseif check_back_space() then
                        fallback()
                    else
                        cmp.complete()
                    end
                end, {'i', 's'}),
            },
            -- sources
            sources = {
                {name = 'nvim_lsp', max_item_count=10},
                {name = 'path', max_item_count=10},
                {name = 'buffer', max_item_count=10},
                {name = 'nvim_lua'},
                {name = 'luasnip'},
            },
            -- formatting
            formatting = {
                format = require('lspkind').cmp_format {
                    mode = 'symbol_text',
                }
            },
        }
    end,
}
