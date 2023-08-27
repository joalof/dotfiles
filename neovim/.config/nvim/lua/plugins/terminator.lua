return {
    'erietz/vim-terminator',
    branch = 'main',
    init = function()
        vim.g.terminator_clear_default_mappings = "foo bar"
        vim.g.terminator_repl_delimiter_regex = '%%'
        vim.g.terminator_runfile_map = {
            python = "python -u",
            julia = "julia",
            lua = "luajit",
            R = 'Rscript',
        }
        vim.g.terminator_split_fraction = 0.3
        vim.g.terminator_auto_shrink_output = true
    end,
    keys = {'<leader>rr', '<leader>rx'},
    config = function()

        vim.keymap.set('n', '<leader>rx', ':update | TerminatorStopRun<cr>',
            { silent = true, noremap = true })

        -- Create a function that will run our script in an output buffer
        -- and start a timer with a scheduled  task that monitors the output
        -- buffer and closes it if it has not been touched in grace_time seconds.
        -- Note that the timer is stopped after the buffer is closed.
        local function run_and_autoclose()
            vim.cmd('update | TerminatorRunFileInOutputBuffer')

            local grace_time = 5
            local timer = vim.loop.new_timer()
            if not timer then return end

            local function scheduled_output_close()
                local open_buffers = vim.fn.getbufinfo()
                for _, buf in pairs(open_buffers) do
                    if vim.fs.basename(buf.name) == 'OUTPUT_BUFFER' then
                        local recently_used = (os.time() - buf.lastused) < grace_time
                        if not recently_used then
                            timer:stop()
                            vim.api.nvim_buf_delete(buf.bufnr, { force = false, unload = false })
                        end
                    end
                end
            end

            timer:start(
                grace_time * 1000,
                10000,
                vim.schedule_wrap(function() scheduled_output_close() end)
            )
        end

        -- temporarily disable
        -- vim.keymap.set('n', '<leader>rr', function() run_and_autoclose() end,
        --     { silent = true, noremap = true }
        -- )
        vim.keymap.set('n', '<leader>rr', ':update | TerminatorRunFileInOutputBuffer<cr>')

        -- close output buffer if it's the last open buffer
        local function output_close_if_last()
            if vim.fs.basename(vim.api.nvim_buf_get_name(0)) == 'OUTPUT_BUFFER' and
                vim.api.nvim_win_get_number(0) == 1 then
                vim.cmd("quit")
            end
        end

        vim.api.nvim_create_autocmd("WinEnter", {
            desc = "Auto-close output buffer if it's the last remaning window.",
            pattern = "*",
            callback = function()
                output_close_if_last()
            end,
        })
    end,
}
