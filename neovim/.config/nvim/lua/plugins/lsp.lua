local Path = require("lib.path").Path

-- adapted from https://github.com/rijulkap/dotfiles/blob/master/nvim/lua/plugins/lsp.lua
vim.g.lsp_servers = {
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
                venvPath = Path(vim.env["VIRTUAL_ENV"]):parent().filename,
                venv = Path(vim.env["VIRTUAL_ENV"]):name(),
            },
        },
    },
    yamlls = {},
    taplo = {},
    bashls = {},
    jsonls = {
        settings = {
            json = {
                format = {
                    enable = true,
                },
                validate = { enable = true },
            },
        },
    },
    rust_analyzer = {
        settings = {
            ["rust-analyzer"] = {
                checkOnSave = {
                    enable = true,
                },
                diagnostics = {
                    enable = true, -- keep LSP semantic diagnostics
                },
            },
        },
    },
    lua_ls = {
        settings = {
            Lua = {
                completion = {
                    callSnippet = "Replace",
                },
            },
        },
    },
}

vim.g.other_mason_servers = { "stylua" }

return {

    {
        "mason-org/mason.nvim",
        opts = { ui = { border = "rounded" } },
    },
    {
        "mason-org/mason-lspconfig.nvim",
        dependencies = {
            "mason-org/mason.nvim",
            "neovim/nvim-lspconfig",
        },
        event = { "VeryLazy", "BufReadPre", "BufNewFile" },
        config = function(_)
            local mr = require("mason-registry")
            mr.refresh(function()
                for _, tool in ipairs(vim.g.other_mason_servers) do
                    local p = mr.get_package(tool)
                    if not p:is_installed() then
                        p:install()
                    end
                end
            end)

            -- Configure and get names of lsp servers
            local lsp_server_names = {}
            for lsp_server_name, _ in pairs(vim.g.lsp_servers) do
                -- Add custom config settings
                local lsp_server_settings = vim.g.lsp_servers[lsp_server_name] or {}
                vim.lsp.config(lsp_server_name, lsp_server_settings)

                table.insert(lsp_server_names, lsp_server_name)
            end

            local capabilities = require("blink.cmp").get_lsp_capabilities(nil, true)
            vim.lsp.config("*", { capabilities = capabilities })

            require("mason-lspconfig").setup({
                ensure_installed = lsp_server_names,
                automatic_enable = true,
            })

            local function setup_document_highlight(bufnr)
                local highlight_augroup = vim.api.nvim_create_augroup("LspDocumentHighlight", { clear = false })

                vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                    group = highlight_augroup,
                    buffer = bufnr,
                    callback = vim.lsp.buf.document_highlight,
                })

                vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
                    group = highlight_augroup,
                    buffer = bufnr,
                    callback = vim.lsp.buf.clear_references,
                })

                vim.api.nvim_create_autocmd("LspDetach", {
                    group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
                    callback = function(event2)
                        vim.lsp.buf.clear_references()
                        vim.api.nvim_clear_autocmds({ group = "LspDocumentHighlight", buffer = event2.buf })
                    end,
                })
            end

            -- hover is currently handled by Noice, but if we remove Noice
            -- we can enable this
            -- local hover = vim.lsp.buf.hover
            -- ---@diagnostic disable-next-line: duplicate-set-field
            -- vim.lsp.buf.hover = function()
            --     return hover({
            --         border = "rounded",
            --         max_height = math.floor(vim.o.lines * 0.5),
            --         max_width = math.floor(vim.o.columns * 0.4),
            --         silent = true,
            --     })
            -- end

            local function setup_document_autohover(bufnr)
                local hover_augroup = vim.api.nvim_create_augroup("LspDocumentHover", { clear = false })
                vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                    group = hover_augroup,
                    buffer = bufnr,
                    callback = function()
                        local cursor = vim.api.nvim_win_get_cursor(0)
                        local lnum, col = cursor[1] - 1, cursor[2]

                        -- Get diagnostics exactly under the cursor
                        local diagnostics = vim.diagnostic.get(0, { lnum = lnum })
                        local has_diagnostic_under_cursor = false

                        for _, diag in ipairs(diagnostics) do
                            if diag.col <= col and col < diag.end_col then
                                has_diagnostic_under_cursor = true
                                break
                            end
                        end

                        if not has_diagnostic_under_cursor then
                            vim.lsp.buf.hover()
                        end
                    end,
                })
            end

            -- Disable the new 0.11 default keybinds
            for _, bind in ipairs({ "grn", "gra", "gri", "grr" }) do
                pcall(vim.keymap.del, "n", bind)
            end

            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
                callback = function(event)
                    local map = function(keys, func, desc)
                        vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
                    end

                    local Snacks = require("snacks")

                    map("gd", function()
                        Snacks.picker.lsp_definitions()
                    end, "[g]oto [d]efinition")
                    map("gr", function()
                        Snacks.picker.lsp_references()
                    end, "[g]oto [r]eferences")
                    map("gI", function()
                        Snacks.picker.lsp_implementations()
                    end, "[g]oto [I]mplementation")
                    map("<leader>ll", vim.diagnostic.setloclist, "Open diagnostic [l]sp [l]oclist list")
                    map("<leader>lq", vim.diagnostic.setqflist, "Open diagnostic [l]sp [q]uickfix list")
                    map("<leader>ar", vim.lsp.buf.rename, "[a]ction [r]ename")
                    map("<leader>ac", vim.lsp.buf.code_action, "[a]ction [c] action")
                    map("gD", vim.lsp.buf.declaration, "[g]oto [D]eclaration")
                    map("K", vim.lsp.buf.hover, "Open hover")

                    local client = vim.lsp.get_client_by_id(event.data.client_id)
                    if client then

                        -- disable semantic highlights
                        client.server_capabilities.semanticTokensProvider = nil

                        if
                            client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf)
                        then
                            setup_document_highlight(event.buf)
                        end

                        -- if client:supports_method(vim.lsp.protocol.Methods.textDocument_hover, event.buf) then
                        --     setup_document_autohover(event.buf)
                        -- end

                        if client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
                            vim.lsp.inlay_hint.enable(false)
                            map("<leader>lti", function()
                                if vim.lsp.inlay_hint.is_enabled() then
                                    vim.lsp.inlay_hint.enable(false)
                                else
                                    vim.lsp.inlay_hint.enable(true)
                                end
                            end, "[l]sp [t]oggle [i]nlay hints")
                        end

                        if client.name == "ruff" then
                            client.server_capabilities.hoverProvider = false
                        end
                    end
                end,
            })

            vim.lsp.set_log_level("off")

            local signature_help = vim.lsp.buf.signature_help
            ---@diagnostic disable-next-line: duplicate-set-field
            vim.lsp.buf.signature_help = function()
                return signature_help({
                    border = "rounded",
                    max_height = math.floor(vim.o.lines * 0.5),
                    max_width = math.floor(vim.o.columns * 0.4),
                })
            end

            local function truncate_message(message, max_length)
                if #message > max_length then
                    return message:sub(1, max_length) .. "..."
                end
                return message
            end

            local diagnostic_symbols = {
                [vim.diagnostic.severity.ERROR] = { " ", "DiagnosticError" },
                [vim.diagnostic.severity.WARN] = { " ", "DiagnosticWarn" },
                [vim.diagnostic.severity.INFO] = { " ", "DiagnosticInfo" },
                [vim.diagnostic.severity.HINT] = { " ", "DiagnosticHint" },
            }

            -- wrappers to allow for toggling
            local virtual_text = {
                on = {
                    severity = { max = "Error" },
                    source = "if_many",
                    spacing = 4,
                    prefix = function(diagnostic, i, total)
                        -- show prefix only once even if there are many error
                        if i == 1 then
                            return unpack(diagnostic_symbols[diagnostic.severity] or { "", "" })
                        end
                    end,
                },
                off = false,
            }
            local virtual_lines = {
                on = {
                    current_line = true,
                    severity = { min = "ERROR" },
                    format = function(diagnostic)
                        local max_length = 100 -- Set your preferred max length
                        return "  " .. truncate_message(diagnostic.message, max_length)
                    end,
                },
                off = false,
            }

            local default_diagnostic_config = {
                update_in_insert = false,
                virtual_lines = virtual_lines.off,
                virtual_text = virtual_text.off,
                underline = true,
                severity_sort = true,
                float = {
                    focusable = false,
                    style = "minimal",
                    border = "rounded",
                    source = "always",
                    header = "",
                    prefix = function(diagnostic)
                        -- return diagnostic_symbols[diagnostic.severity] or ""
                        return unpack(diagnostic_symbols[diagnostic.severity] or { "", "" })
                    end,
                },
                signs = {
                    text = {
                        [vim.diagnostic.severity.ERROR] = "",
                        [vim.diagnostic.severity.WARN] = "",
                        [vim.diagnostic.severity.INFO] = "",
                        [vim.diagnostic.severity.HINT] = "",
                    },
                    numhl = {
                        [vim.diagnostic.severity.ERROR] = "ErrorMsg", -- Just cause its also bold
                        [vim.diagnostic.severity.WARN] = "DiagnosticWarn",
                        [vim.diagnostic.severity.INFO] = "DiagnosticInfo",
                        [vim.diagnostic.severity.HINT] = "DiagnosticHint",
                    },
                },
            }
            vim.diagnostic.config(default_diagnostic_config)

            local diagnostic_augroup = vim.api.nvim_create_augroup("VimDiagnostic", { clear = false })
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                group = diagnostic_augroup,
                callback = function()
                    vim.diagnostic.open_float(nil, { focusable = false, scope = "cursor" })
                end,
            })

            -- Set Toggles
            Snacks.toggle
                .new({
                    id = "Virtual diagnostics (Lines)",
                    name = "Virtual diagnostics (Lines)",
                    get = function()
                        if vim.diagnostic.config().virtual_lines then
                            return true
                        else
                            return false
                        end
                    end,
                    set = function(state)
                        if state == true then
                            vim.diagnostic.config({ virtual_lines = virtual_lines.on })
                        else
                            vim.diagnostic.config({ virtual_lines = virtual_lines.off })
                        end
                    end,
                })
                :map("<leader>dtl")

            Snacks.toggle
                .new({
                    id = "Virtual diagnostics (Text)",
                    name = "Virtual diagnostics (Text)",
                    get = function()
                        if vim.diagnostic.config().virtual_text then
                            return true
                        else
                            return false
                        end
                    end,
                    set = function(state)
                        if state == true then
                            vim.diagnostic.config({ virtual_text = virtual_text.on })
                        else
                            vim.diagnostic.config({ virtual_text = virtual_text.off })
                        end
                    end,
                })
                :map("<leader>dtt")
        end,
    },
}
