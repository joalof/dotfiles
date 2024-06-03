-- local lsp_defaults = require("lspconfig").util.default_config
-- local pyright_capabilities = vim.tbl_deep_extend("force", {}, lsp_defaults.capabilities)
-- -- local capabilities = vim.lsp.protocol.make_client_capabilities()
-- pyright_capabilities.textDocument.publishDiagnostics.tagSupport.valueSet = { 2 }


local M = {
    ruff_lsp = {
        on_attach = function(client, _)
            client.server_capabilities.hoverProvider = false
        end,
    },
    pyright = {
        -- capabilities = pyright_capabilities,
        settings = {
            python = {
                analysis = {
                    typeCheckingMode = "basic",
                    useLibraryCodeForTypes = true,
                    diagnosticMode = "openFilesOnly",
                    autoSearchPaths = true,
                    stubPath = "/home/joalof/.local/share/stubs",
                    -- diagnosticSeverityOverrides = {
                    --     reportUnusedVariable = "warning",
                    -- },
                },
            },
        },
    },
    basedpyright = {
        -- capabilities = pyright_capabilities,
        settings = {
            basedpyright = {
                analysis = {
                    autoImportCompletions = true,
                    typeCheckingMode = "basic",
                    useLibraryCodeForTypes = true,
                    diagnosticMode = "openFilesOnly",
                    autoSearchPaths = true,
                    stubPath = "/home/joalof/.local/share/typings",
                    -- diagnosticSeverityOverrides = {
                    --     reportUnusedVariable = "warning",
                    -- },
                },
            },
        },
    },
    lua_ls = {
        settings = {
            Lua = {
                workspace = {
                    checkThirdParty = false,
                },
                completion = {
                    callSnippet = "Replace",
                },
                hint = {
                    enable = true,
                    setType = false,
                    paramType = true,
                    paramName = "Disable",
                    semicolon = "Disable",
                    arrayIndex = "Disable",
                },
            },
        },
        r_language_server = {
            flags = { debounce_text_changes = 150 },
        },
    },
}
return M
