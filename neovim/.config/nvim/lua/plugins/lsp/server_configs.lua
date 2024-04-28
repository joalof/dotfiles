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
        on_init = function(client)
            local path = client.workspace_folders[1].name
            if not vim.loop.fs_stat(path .. "/.luarc.json") and not vim.loop.fs_stat(path .. "/.luarc.jsonc") then
                client.config.settings = vim.tbl_deep_extend("force", client.config.settings, {
                    Lua = {
                        runtime = {
                            version = "LuaJIT",
                        },
                        workspace = {
                            checkThirdParty = false,
                            library = vim.api.nvim_get_runtime_file("", true),
                        },
                        completion = {
                            callSnippet = "Disable",
                        },
                        diagnostics = {
                            globals = { "vim" },
                        },
                    },
                })
                client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
            end
            return true
        end,
    },
    r_language_server = {
        flags = { debounce_text_changes = 150 },
    },
}
return M
