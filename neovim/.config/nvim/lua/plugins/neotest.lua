return {
    "nvim-neotest/neotest",
    dependencies = {
        "nvim-neotest/nvim-nio",
        "nvim-lua/plenary.nvim",
        "antoinemadec/FixCursorHold.nvim",
        "nvim-neotest/neotest-python",
    },
    opts = {
        -- Can be a list of adapters like what neotest expects,
        -- or a list of adapter names,
        -- or a table of adapter names, mapped to adapter configs.
        -- The adapter will then be automatically loaded with the config.
        adapters = { "neotest-python" },
        status = { virtual_text = true },
        output = { open_on_run = true },
        quickfix = {
            enable = true,
            open = true,
            -- open = function()
            --     if require("lazyvim.util").has("trouble.nvim") then
            --         require("trouble").open({ mode = "quickfix", focus = false })
            --     else
            --         vim.cmd("copen")
            --     end
            -- end,
        },
    },
    config = function(_, opts)
        local neotest_ns = vim.api.nvim_create_namespace("neotest")
        vim.diagnostic.config({
            virtual_text = {
                format = function(diagnostic)
                    -- Replace newline and tab characters with space for more compact diagnostics
                    local message = diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
                    return message
                end,
            },
        }, neotest_ns)

        -- if require("lazyvim.util").has("trouble.nvim") then
        --     opts.consumers = opts.consumers or {}
        --     -- Refresh and auto close trouble after running tests
        --     ---@type neotest.Consumer
        --     opts.consumers.trouble = function(client)
        --         client.listeners.results = function(adapter_id, results, partial)
        --             if partial then
        --                 return
        --             end
        --             local tree = assert(client:get_position(nil, { adapter = adapter_id }))
        --
        --             local failed = 0
        --             for pos_id, result in pairs(results) do
        --                 if result.status == "failed" and tree:get_key(pos_id) then
        --                     failed = failed + 1
        --                 end
        --             end
        --             vim.schedule(function()
        --                 local trouble = require("trouble")
        --                 if trouble.is_open() then
        --                     trouble.refresh()
        --                     if failed == 0 then
        --                         trouble.close()
        --                     end
        --                 end
        --             end)
        --             return {}
        --         end
        --     end
        -- end

        if opts.adapters then
            local adapters = {}
            for name, config in pairs(opts.adapters or {}) do
                if type(name) == "number" then
                    if type(config) == "string" then
                        config = require(config)
                    end
                    adapters[#adapters + 1] = config
                elseif config ~= false then
                    local adapter = require(name)
                    if type(config) == "table" and not vim.tbl_isempty(config) then
                        local meta = getmetatable(adapter)
                        if adapter.setup then
                            adapter.setup(config)
                        elseif meta and meta.__call then
                            adapter(config)
                        else
                            error("Adapter " .. name .. " does not support setup")
                        end
                    end
                    adapters[#adapters + 1] = adapter
                end
            end
            opts.adapters = adapters
        end

        require("neotest").setup(opts)
    end,
    -- stylua: ignore
    keys = {
        { "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Test: Run File" },
        { "<leader>ts", function()
            require("neotest").run.run(vim.uv.cwd())
            require("neotest").summary.toggle()
        end, desc = "Test: Run All Test Files" },
        { "<leader>tn", function() require("neotest").run.run() end, desc = "Test: Run Nearest" },
        -- { "<leader>ts", function()
        --     require("neotest").summary.toggle()
        -- end, desc = "Test: Toggle Summary" },
        { "<leader>to", function() require("neotest").output.open({ enter = true, auto_close = true }) end, desc = "Show Output" },
        { "<leader>tO", function() require("neotest").output_panel.toggle() end, desc = "Test: Toggle Output Panel" },
        { "<leader>tx", function() require("neotest").run.stop() end, desc = "Test: Stop" },
    },
}
