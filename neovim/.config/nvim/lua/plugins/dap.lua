return {
    "mfussenegger/nvim-dap",
    config = function()
        vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })
        local signs = {
            DapBreakpoint = { text = "●", texthl = "LspDiagnosticsDefaultError" },
            DapLogPoint = { text = "◉", texthl = "LspDiagnosticsDefaultError" },
            DapStopped = { text = "🞂", texthl = "LspDiagnosticsDefaultInformation", linehl = "CursorLine" },
        }
        for sign, options in pairs(signs) do
            vim.fn.sign_define(sign, options)
        end
    end,
}
