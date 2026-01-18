return {
    "waiting-for-dev/ergoterm.nvim",
    keys = { "<leader>ri", "<leader>rr", "<leader>rx", "<leader>cc", "<leader>ot", "<leader>oi" },
    config = function()
        local ergoterm = require("ergoterm")

        -- open a terminal
        vim.keymap.set("n", "<leader>ot", function()
            local term = ergoterm.new({ name = "bash", start_in_insert = true, size = { below = "30%" } })
            term:focus('float')
        end)

        -- Lightwieght coderunner
        local is_wsl = type(os.getenv("WSL_DISTRO_NAME")) == "string"

        local interpreters = {
            python = "python",
            julia = "julia",
            mojo = "mojo",
            r = "R",
            lua = "nvim -l",
            sh = "bash",
        }

        local runner_name = "coderunner"
        local default_runner = ergoterm.with_defaults({
            name = runner_name,
            cleanup_on_success = false,
            start_in_insert = false,
            size = { below = "30%" },
            on_job_stdout = function(t, channel_id, data, name)
                -- if we're on wsl the stdout data from the terminal may
                -- contain windows carriage returns
                if is_wsl and t.meta.fileformat == "unix" then
                    for i, line in ipairs(data) do
                        data[i] = line:gsub("\r\n?", "\n")
                    end
                end

                local efm = t.meta.efm
                if efm ~= "" then
                    vim.fn.setqflist({}, "a", { lines = data, efm = efm })
                end
                -- vim.cmd("copen")
            end,
        })

        vim.keymap.set("n", "<leader>rr", function()
            local term = ergoterm.get_by_name(runner_name)
            if term ~= nil then
                term:cleanup()
            end

            local filename = vim.api.nvim_buf_get_name(0)
            local cmd = (interpreters[vim.bo.filetype] .. " %s"):format(filename)

            term = default_runner:new({
                cmd = cmd,
                meta = {
                    efm = vim.api.nvim_get_option_value("errorformat", { buf = 0 }),
                    fileformat = vim.bo.fileformat,
                },
            })
            term:open()
        end)

        vim.keymap.set("n", "<leader>rx", function()
            local term = ergoterm.get_by_name(runner_name)
            if term ~= nil then
                term:cleanup()
            end
        end)

        vim.keymap.set("n", "<leader>ri", function()
            local filename = vim.api.nvim_buf_get_name(0)
            local cmd = "ipython --no-banner --no-confirm-exit"
            local term = ergoterm:new{ cmd = cmd, cleanup_on_success = false, start_in_insert=true, layout = "float" }
            term:send({ string.format("run %s", filename) })
            vim.bo.bufhidden = "delete" -- close the terminal when window closes

            -- Skips the "[Process exited 0]" message from the embedded terminal
            vim.api.nvim_create_autocmd({ "TermClose" }, {
                buffer = vim.api.nvim_get_current_buf(),
                callback = function()
                    vim.api.nvim_feedkeys("i", "n", false)
                end,
            })
        end)

        vim.keymap.set("n", "<leader>oi", function()
            -- local filename = vim.api.nvim_buf_get_name(0)
            local cmd = "ipython --no-banner --no-confirm-exit"
            local term = ergoterm:new{ cmd = cmd, cleanup_on_success = false, start_in_insert=true, layout = "float" }
            -- term:send({ string.format("run %s", filename) })
            term:focus()
            vim.bo.bufhidden = "delete" -- close the terminal when window closes

            -- Skips the "[Process exited 0]" message from the embedded terminal
            vim.api.nvim_create_autocmd({ "TermClose" }, {
                buffer = vim.api.nvim_get_current_buf(),
                callback = function()
                    vim.api.nvim_feedkeys("i", "n", false)
                end,
            })
        end)

        --
        -- AI CLI agent integrations
        --
        local ai_chats = ergoterm.with_defaults({
            layout = "right",
            auto_list = false,
            bang_target = false,
            sticky = true,
            watch_files = true,
            tags = { "ai_chat" },
        })

        local claude = ai_chats:new({
            cmd = "claude --model sonnet",
            name = "claude",
            on_focus = function()
                vim.print("Focused")
            end,
            meta = {
                add_file = function(file)
                    return "@" .. file
                end,
            },
        })

        vim.keymap.set("n", "<leader>cc", function()
            claude:toggle()
        end, { desc = "Toggle Claude" })

        vim.keymap.set("n", "<leader>ca", function()
            local file = vim.fn.expand("%:p")
            claude:send({ "@" .. file .. " " }, { new_line = false })
        end)

        vim.keymap.set("n", "<leader>cl", function()
            claude:send("single_line")
        end)

        vim.keymap.set("v", "<leader>cs", function()
            claude:send("visual_selection", { trim = false })
        end)
    end,
}
