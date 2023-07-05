return {
    "hrsh7th/nvim-cmp",
    dependencies = {
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        'saadparwaiz1/cmp_luasnip',
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-nvim-lsp-signature-help",
        'hrsh7th/cmp-nvim-lua',
        'hrsh7th/cmp-omni',
        'onsails/lspkind.nvim',
    },
    event = "InsertEnter",
    config = function()
        vim.opt.completeopt = { "menuone", "noselect" }

        local cmp = require('cmp')
        local lspkind = require('lspkind')
        local luasnip = require('luasnip')
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
            -- snippets
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
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
                {name = 'nvim_lsp_signature_help'},
                {name = 'nvim_lua'},
                {name = 'luasnip'},
                {name = 'path', max_item_count=10},
                {name = 'buffer', max_item_count=10},
            },
            -- formatting
            formatting = {
                format = lspkind.cmp_format {
                    mode = 'symbol_text',
                }
            },
        }
    end,
}

-- local cmp_autopairs = require('nvim-autopairs.completion.cmp')
-- cmp.event:on(
--   'confirm_done',
--   cmp_autopairs.on_confirm_done()
-- )

-- Tab key mapping for snippets?
--  -- Check if there's a word before the cursor (used by <TAB> mapping)
-- local has_words_before = function()
--   local line, col = unpack(vim.api.nvim_win_get_cursor(0))
--   return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
-- end
-- Send feed keys with special codes (used by <S-TAB> mapping)
-- local feedkey = function(key, mode)
--   vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
-- end
-- ["<Tab>"] = cmp.mapping(function(fallback)
--   if cmp.visible() then
--     cmp.select_next_item()
--   elseif vim.fn["vsnip#available"]() == 1 then
--     feedkey("<Plug>(vsnip-expand-or-jump)", "")
--   elseif has_words_before() then
--     cmp.complete()
--   else
--     fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
--   end
-- end, { "i", "s" }),
-- ["<S-Tab>"] = cmp.mapping(function()
--   if cmp.visible() then
--     cmp.select_prev_item()
--   elseif vim.fn["vsnip#jumpable"](-1) == 1 then
--     feedkey("<Plug>(vsnip-jump-prev)", "")
--   end
-- end, { "i", "s" }),
--
--
