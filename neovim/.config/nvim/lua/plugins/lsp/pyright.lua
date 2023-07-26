local settings = {
    python = {
        analysis = {
            -- typeCheckingMode = "basic",
            useLibraryCodeForTypes = true,
            diagnosticMode = 'openFilesOnly',
            autoSearchPaths = true,
            stubPath = '/home/joalof/.local/share/typings'
        },
    },
}

return settings
