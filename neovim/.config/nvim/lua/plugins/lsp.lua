local Path = require('lib.path')

local server_configs = {
    ruff_lsp = {
        on_attach = function(client, _)
            client.server_capabilities.hoverProvider = false
        end,
    },
    basedpyright = {
        settings = {
            basedpyright = {
                analysis = {
                    autoImportCompletions = true,
                    typeCheckingMode = "basic",
                    useLibraryCodeForTypes = true,
                    diagnosticMode = "openFilesOnly",
                    autoSearchPaths = true,
                    stubPath = vim.uv.os_homedir() .. "/.local/share/stubs",
                },
            },
            python = {
                venvPath = Path(vim.env['VIRTUAL_ENV']):parent().filename,
                venv = Path(vim.env['VIRTUAL_ENV']):name(),
            }
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
    },
    r_language_server = {
        flags = { debounce_text_changes = 150 },
    },
    julials = {
        on_new_config = function(new_config, _)
            local julia = vim.fn.expand("~/.julia/environments/nvim-lspconfig/bin/julia")
            -- if require("lspconfig").util.path.is_file(julia) then
            if (vim.loop.fs_stat(julia) or {}).type == "file" then
                new_config.cmd[1] = julia
            end
        end,
    },
}

return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "onsails/lspkind.nvim",
    },
    config = function()
        -- plugins that have to be set up before lspconfig
        require("mason").setup({
            ui = { border = "rounded" },
        })

        require("mason-lspconfig").setup({})

        -- lspconfig
        local lspconfig = require("lspconfig")

        -- update default capabilities
        local lsp_defaults = lspconfig.util.default_config
        -- lsp_defaults.capabilities =
        --     vim.tbl_deep_extend("force", lsp_defaults.capabilities, require("cmp_nvim_lsp").default_capabilities())
        --
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
            vim.lsp.handlers["textDocument/publishDiagnostics"] =
            vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
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

        local sever_list = { "basedpyright", "lua_ls", "jsonls", "yamlls", "taplo", "julials", "bashls" }

        for _, server in ipairs(sever_list) do
            local config = server_configs[server] or {}
            -- config.capabilities = require('blink.cmp').get_lsp_capabilities(config.capabilities)
            lspconfig[server].setup(config)
        end
    end,
}
