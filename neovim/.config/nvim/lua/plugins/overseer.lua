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

        -- cache run_script tasks per filename so we can delete an existing
        -- terminal if we rerun the script
        local task_list = {}

        local run_script = function()
            local file = vim.fn.expand("%:p")
            local name = "run_script"

            local task_old = task_list[file]
            if task_old then
                task_old:dispose()
                task_old.strategy.term:shutdown()
                vim.cmd('cclose')
                task_list[file] = nil
            end

            -- Runs file in a toggleterm, sending errors to quickfix
            local task = overseer.new_task({
                name = name,
                cmd = { interpreters[vim.bo.filetype] },
                args = { file },
                strategy = { "toggleterm", open_on_start = true },
                components = {
                    { "on_output_quickfix", errorformat = vim.bo.errorformat, open_on_match = true },
                    "default",
                },
            })
            task_list[file] = task
            task:start()
            -- Don't focus terminal immediately
            vim.api.nvim_cmd({ cmd = "KittyNavigateUp" }, {})
        end

        vim.keymap.set("n", "<leader>rr", function()
            if vim.bo.filetype == 'lua' then
                vim.cmd("luafile %")
            else
                vim.cmd.update()
                run_script()
            end
        end, { silent = true })

        -- vim.api.nvim_create_autocmd("WinEnter", {
        --     desc = "Auto-close toggle term if it is the last remaining window",
        --     pattern = "*",
        --     callback = function()
        --         if vim.tbl_count(vim.api.nvim_list_wins()) == 1 and
        --         end
        --     end,
        -- })


    end,
}
