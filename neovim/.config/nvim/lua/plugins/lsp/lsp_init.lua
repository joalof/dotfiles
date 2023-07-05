-- set up mason and then mason-lspconfig
require("mason").setup({
    ui = {border = 'none'},
})

-- require("mason-lspconfig").setup {
--     ensure_installed = {'pyright', 'sumneko_lua'},
-- }

-- handlers
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    underline = true,
    virtual_text = false,
    signs = true,
    update_in_insert = false,
  }
)

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = "rounded",
    width = 60,
})

-- neodev: make sure to setup before lspconfig
require("neodev").setup({
})

-- set up lspconfig
local capabilities = require('cmp_nvim_lsp').default_capabilities()

local on_attach = function(client, bufnr)

    -- require "lsp_signature".on_attach({
    --     floating_window = true,
    --     bind = true, -- This is mandatory, otherwise border config won't get registered.
    --     handler_opts = {
    --         border = "rounded"
    --     },
    --     hint_enable = true,  -- turn off virtual text hints
    -- }, bufnr)
    --
    
    vim.api.nvim_create_autocmd("CursorHold", {
        callback = function()
            vim.diagnostic.open_float(bufnr, {scope = 'cursor', focus = false})
        end,
        buffer = bufnr,
    })

    if client.server_capabilities.documentHighlightProvider then

        vim.api.nvim_create_augroup("lsp_document_highlight", { clear = true })
        vim.api.nvim_clear_autocmds {buffer = bufnr, group = "lsp_document_highlight"}

        vim.api.nvim_create_autocmd("CursorHold", {
                callback = vim.lsp.buf.document_highlight,
                buffer = bufnr,
                group = "lsp_document_highlight",
                desc = "Document Highlight",
            })
        vim.api.nvim_create_autocmd("CursorMoved", {
                callback = vim.lsp.buf.clear_references,
                buffer = bufnr,
                group = "lsp_document_highlight",
                desc = "Clear All the References",
            })
    end

    local opts = {silent = true, buffer = bufnr}
    vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)

end

-- Pyright
local lspconfig = require('lspconfig')
lspconfig['pyright'].setup {
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        python = {
            analysis = {
                -- typeCheckingMode = "basic",
                useLibraryCodeForTypes = true,
                diagnosticMode = 'openFilesOnly',
                autoSearchPaths = true,
                stubPath = '/home/joalof/.local/share/typings'
            }
        }
    }
}

-- sumneko: lua
lspconfig['lua_ls'].setup({
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        Lua = {
            completion = {
                -- Whether to show call snippets or not. When disabled, only
                -- the function name will be completed. When enabled, a
                -- "more complete" snippet will be offered.
                callSnippet = "Disable" -- Disable, Both, Replace
            },
        },
    },
})

lspconfig['r_language_server'].setup({
  on_attach = on_attach,
  flags = { debounce_text_changes = 150 },
})
