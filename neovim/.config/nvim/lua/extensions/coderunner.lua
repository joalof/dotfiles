local overseer = require("overseer")

local interpreters = {
    python = "python",
    julia = "julia",
    mojo = "mojo",
    markdown = "glow",
    r = "R",
    sh = "bash",
}

local M = {}

local api = vim.api

function M.run_script(opts)
    local file_name = vim.fn.expand("%:p")
    local task_name = "run_script"
    opts = opts or { grace_time = 60 }

    -- close any old tasks
    for _, task in ipairs(overseer.list_tasks()) do
        if task.name == task_name then
            task:dispose()
            task.strategy.term:shutdown()
            vim.cmd("cclose")
        end
    end

    local components
    if opts.grace_time ~= nil then
        components = {
            { "coderunner.autoclose", grace_time = opts.grace_time },
            "default",
        }
    else
        components = {
            "default",
        }
    end

    if vim.bo.errorformat ~= "" then
        components[#components + 1] = { "on_output_quickfix", errorformat = vim.bo.errorformat, open_on_match = true }
    end

    -- Runs file in a toggleterm, sending errors to quickfix
    local task = overseer.new_task({
        name = task_name,
        cmd = { interpreters[vim.bo.filetype] },
        args = { file_name },
        strategy = { "toggleterm", open_on_start = true },
        components = components,
    })
    task:start()
    -- Don't focus toggleterminal immediately
    -- vim.cmd.wincmd('k')
end

function M.abort_script()
    local task_name = "run_script"
    for _, task in ipairs(overseer.list_tasks()) do
        if task.name == task_name then
            task:dispose()
            task.strategy.term:shutdown()
            vim.cmd("cclose")
        end
    end
end

function M.run_lua()
    api.nvim_cmd({ cmd = "Redir", args = { "luafile", "%" } }, {})
end

function M.run(opts)
    vim.cmd.update()
    if vim.bo.filetype == "lua" then
        M.run_lua()
    else
        M.run_script(opts)
    end
end

return M
