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

        local tasks_list = {}
        
        local run_script = function()
            local file = vim.fn.expand("%:p")
            local name = "run_script"

            -- If there's already a run_script task for the file, dispose it
            -- local task_list = require("overseer.task_list").list_tasks()
            -- for _, task in pairs(task_list) do
            --     if task.cmd[2] == file then
            --         task.strategy:dispose()
            --         break
            --     end
            -- end
            
            local task_old = tasks_list[file]
            if task_old then
                task_old:dispose()
                task_old.strategy.term:shutdown()
                tasks_list[file] = nil
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

            tasks_list[file] = task

            task:start()
            -- overseer.run_action(task, "open hsplit")
            -- Don't focus terminal
            vim.api.nvim_cmd({ cmd = "KittyNavigateUp" }, {})
        end

        vim.keymap.set("n", "<leader>rr", function()
            run_script()
        end, { silent = true })
    end,
}
