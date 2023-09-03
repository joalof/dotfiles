return {
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
                diagnosticMode = 'openFilesOnly',
                autoSearchPaths = true,
                stubPath = '/home/joalof/.local/share/typings',
                -- diagnosticSeverityOverrides = {
                --     reportUnusedVariable = "warning",
                -- },
            },
        },
    },
}
