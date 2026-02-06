return {
    "stevearc/conform.nvim",
    keys = { "<leader>af" },
    config = function()
        require("conform").setup({
            formatters_by_ft = {
                lua = { "stylua" },
                python = { "isort", "black" },
                c = { name = "clangd", timeout_ms = 500, lsp_format = "prefer" },
                go = { name = "gopls", timeout_ms = 500, lsp_format = "prefer" },
                javascript = { "prettier", name = "dprint", timeout_ms = 500, lsp_format = "fallback" },
                javascriptreact = { "prettier", name = "dprint", timeout_ms = 500, lsp_format = "fallback" },
                json = { "prettier", name = "dprint", timeout_ms = 500, lsp_format = "fallback" },
                jsonc = { "prettier", name = "dprint", timeout_ms = 500, lsp_format = "fallback" },
                less = { "prettier" },
                markdown = { "prettier" },
                rust = { name = "rust_analyzer", timeout_ms = 500, lsp_format = "prefer" },
                scss = { "prettier" },
                sh = { "shfmt" },
                typescript = { "prettier", name = "dprint", timeout_ms = 500, lsp_format = "fallback" },
                typescriptreact = { "prettier", name = "dprint", timeout_ms = 500, lsp_format = "fallback" },
                yaml = { "prettier" },
                -- If there is no formatter
                ['_'] = { 'trim_whitespace', 'trim_newlines' },
            },
        })
        vim.keymap.set("n", "<leader>af", function()
            require("conform").format({ async = true })
        end)
    end,
}
