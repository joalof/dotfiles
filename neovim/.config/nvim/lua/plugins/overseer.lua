return {
    "stevearc/overseer.nvim",
    dependencies = { "akinsho/toggleterm.nvim", version = "*", opts = {} },
    cmd = { "OverseerRun", "OverseerToggle" },
    keys = { "<leader>rr" },
    opts = {
        templates = { "builtin" },
    },
    config = function(_, opts)
        local overseer = require("overseer")
        overseer.setup(opts)

        local interpreters = {
            python = "python",
            julia = "julia",
        }

        local run_script = function()
            local file = vim.fn.expand("%:p")
            local name = "run_script"

            for _, task in ipairs(overseer.list_tasks()) do
                if task.name == name then
                    task:dispose()
                    task.strategy.term:shutdown()
                    vim.cmd('cclose')
                end
            end

            -- Runs file in a toggleterm, sending errors to quickfix
            local task = overseer.new_task({
                name = name,
                cmd = { interpreters[vim.bo.filetype] },
                args = { file },
                strategy = { "toggleterm", open_on_start = true },
                components = {
                    { "on_output_quickfix", errorformat = vim.bo.errorformat, open_on_match = true },
                    { "coderunner.autoclose", grace_time = 5 },
                    "default",
                },
            })
            task:start()
            -- Don't focus toggleterminal immediately
            vim.api.nvim_cmd({ cmd = "KittyNavigateUp" }, {})
        end

        -- set keymap to run in toggleterm and autoclose
        vim.keymap.set("n", "<leader>rr", function()
            if vim.bo.filetype == 'lua' then
                vim.cmd("luafile %")
            else
                vim.cmd.update()
                run_script()
            end
        end, { silent = true })

    end,
}
