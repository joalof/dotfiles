-- plugins that have to be set up before lspconfig
require("mason").setup({
    ui = { border = "rounded" },
})

require("mason-lspconfig").setup({})
-- require("neodev").setup({})

-- lspconfig
local lspconfig = require("lspconfig")

-- update default capabilities
local lsp_defaults = lspconfig.util.default_config
lsp_defaults.capabilities =
    vim.tbl_deep_extend("force", lsp_defaults.capabilities, require("cmp_nvim_lsp").default_capabilities())

-- define autocmds and mappings on lsp attach
vim.api.nvim_create_autocmd("LspAttach", {
    desc = "LSP mappings and autocmds",
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        local bufnr = args.buf

        -- disable semantic highlighting
        client.server_capabilities.semanticTokensProvider = nil

        -- vim.api.nvim_create_augroup("lsp_autocmds", { clear = true })
        -- vim.api.nvim_clear_autocmds { buffer = bufnr, group = "lsp_autocmds" }

        -- if client.server_capabilities.documentHighlightProvider then
        --     vim.api.nvim_create_autocmd("CursorHold", {
        --         callback = vim.lsp.buf.document_highlight,
        --         buffer = bufnr,
        --         group = "lsp_autocmds",
        --         desc = "Highlight all references",
        --     })
        --     vim.api.nvim_create_autocmd("CursorMoved", {
        --         callback = vim.lsp.buf.clear_references,
        --         buffer = bufnr,
        --         group = "lsp_autocmds",
        --         desc = "Clear all the reference highlights",
        --     })
        -- end

        local opts = { silent = true, buffer = bufnr, noremap = true }
        -- vim.keymap.set('n', '<leader>af', function() vim.lsp.buf.format { async = true } end, opts)
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "gK", vim.lsp.buf.signature_help, opts)
        vim.keymap.set("n", "[e", vim.diagnostic.goto_prev, opts)
        vim.keymap.set("n", "]e", vim.diagnostic.goto_next, opts)
        vim.keymap.set("n", "<leader>ar", vim.lsp.buf.rename, opts)
        vim.keymap.set("n", "<leader>aa", vim.lsp.buf.code_action, opts)
    end,
})

local function lsp_settings()
    vim.diagnostic.config({
        virtual_text = false,
        update_in_insert = true,
        underline = true,
        severity_sort = true,
        float = {
            focusable = false,
            style = "minimal",
            border = "rounded",
            source = "always",
            header = "",
            prefix = "",
        },
    })

    vim.api.nvim_create_autocmd("CursorHold", {
        callback = function()
            vim.diagnostic.open_float({ scope = "cursor" })
        end,
        desc = "Show diagnostics on hover",
    })

    -- handlers
    vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
        virtual_text = false,
        underline = true,
        signs = true,
        update_in_insert = true,
    })

    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = "rounded",
    })
end

-- load lsp settings
lsp_settings()

local sever_list = { "basedpyright", "lua_ls", "jsonls", "yamlls", "taplo", "mojo"}
local server_configs = require("plugins.lsp.server_configs")

for _, server in ipairs(sever_list) do
    local config = server_configs[server] or {}
    lspconfig[server].setup(config)
end
