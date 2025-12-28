return {
    "waiting-for-dev/ergoterm.nvim",
    keys = { "<leader>ri", "<leader>rr", "<leader>rx" },
    dependencies = {
        "carbon-steel/detour.nvim",
    },
    config = function()
        local ergoterm = require("ergoterm")

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

        local runner_name = 'coderunner'
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
                vim.fn.setqflist({}, "a", {
                    lines = data,
                    efm = efm,
                })
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
            local popup_id = require("detour").Detour()
            if not popup_id then
                return
            end
            local filename = vim.api.nvim_buf_get_name(0)
            local cmd = "ipython --no-banner --no-confirm-exit"
            local term = ergoterm:new({ cmd = cmd, cleanup_on_success = false })
            term:open("window")
            vim.cmd.startinsert() -- needed since ergoterm insert_on_start doesnt work with detour
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
    end,
}
