return {
    "waiting-for-dev/ergoterm.nvim",
    keys = { "<leader>ri", "<leader>re" },
    dependencies = {
        "carbon-steel/detour.nvim",
    },
    config = function()

        local ergoterm = require("ergoterm")
        local stringx = require("lib.stringx")

        local interpreters = {
            python = "python",
            julia = "julia",
            mojo = "mojo",
            r = "R",
            lua = 'nvim -l',
            sh = "bash",
        }

        vim.keymap.set("n", "<leader>re", function()
            local filename = vim.api.nvim_buf_get_name(0)
            local cmd = (interpreters[vim.bo.filetype] .. ' %s'):format(filename)
            local term = ergoterm:new(
                {
                    cmd = cmd,
                    cleanup_on_success = false,
                    start_in_insert = false,
                    sticky = false,
                    on_job_stderr = function(t, channel_id, data, name)
                        vim.notify(stringx.join(data))
                        -- vim.fn.setqflist({}, "r", { lines = data })
                        -- vim.cmd("copen")
                    end,
                }
            )
            term:open("below")
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
