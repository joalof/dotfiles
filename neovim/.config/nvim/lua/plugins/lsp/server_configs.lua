local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

local M = {
    ruff_lsp = {
        on_attach = function(client, _)
            client.server_capabilities.hoverProvider = false
        end,
        init_options = {
            settings = {
                args = {},
            },
        },
    },

    pyright = {
        -- capabilities = (function()
        --     local capabilities = vim.lsp.protocol.make_client_capabilities()
        --     capabilities.textDocument.publishDiagnostics.tagSupport.valueSet = { 2 }
        --     return capabilities
        -- end)(),
        settings = {
            python = {
                analysis = {
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
                runtime = {
                    version = "LuaJIT",
                    -- Setup your lua path
                    path = runtime_path,
                },
                diagnostics = {
                    -- Get the language server to recognize the `vim` global
                    globals = { "vim" },
                },
                workspace = {
                    -- Make the server aware of Neovim runtime files
                    library = vim.api.nvim_get_runtime_file("", true),
                    checkThirdParty = false,
                },
                telemetry = {
                    enable = false,
                },
                completion = {
                    callSnippet = "Disable", -- Disable, Both, Replace
                },
            },
        },
    },
    r_language_server = {
        flags = { debounce_text_changes = 150 },
    },
}
return M
