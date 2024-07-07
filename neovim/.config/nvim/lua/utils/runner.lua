local overseer = require("overseer")

local interpreters = {
    python = "python",
    julia = "julia",
    mojo = "mojo"
}

local M = {}

local api = vim.api

function M.run_script()
    local file = vim.fn.expand("%:p")
    local name = "run_script"

    for _, task in ipairs(overseer.list_tasks()) do
        if task.name == name then
            task:dispose()
            task.strategy.term:shutdown()
            vim.cmd('cclose')
        end
    end

    local components = {
            { "coderunner.autoclose", grace_time = 5 },
            "default",
    }

    if vim.bo.errorformat ~= "" then
        components[#components + 1] = { "on_output_quickfix", errorformat = vim.bo.errorformat, open_on_match = true }
    end

    -- Runs file in a toggleterm, sending errors to quickfix
    local task = overseer.new_task({
        name = name,
        cmd = { interpreters[vim.bo.filetype] },
        args = { file },
        strategy = { "toggleterm", open_on_start = true },
        components = components,
    })
    task:start()
    -- Don't focus toggleterminal immediately
    api.nvim_cmd({ cmd = "KittyNavigateUp" }, {})
end

function M.run_lua()
    local lstr = require('lib.string')
    local Path = require('plenary.path')

    -- run lua file and capture output
    local run_file = vim.fn.expand('%')
    local out = api.nvim_cmd({cmd='luafile', args={run_file}}, {output = true})
    local out_lines = lstr.split(out, '\n')

    -- clear OUTPUT buffer if it already exists 
    local buf = nil
    local buf_info = vim.fn.getbufinfo({bufloaded = 1, buflisted = 1})
    for _, info in ipairs(buf_info) do
        local path = Path:new(info.name)
        if path:make_relative() == 'OUTPUT' then
            buf = info.bufnr
            api.nvim_buf_set_lines(buf, 0, 100, false, {})
            break
        end
    end
    
    -- create new scratch buffer in split and write output
    local split_size = math.max(5, #out_lines)
    if buf == nil then
        api.nvim_cmd({cmd = 'split', args = {'OUTPUT'}, range = {split_size}}, {})
        buf = vim.api.nvim_get_current_buf()
        api.nvim_cmd({ cmd = "KittyNavigateUp" }, {})
        local opts = {bufhidden = 'delete', buflisted = true, buftype = 'nofile', swapfile = false}
        for name, val in pairs(opts) do
            api.nvim_set_option_value(name, val, {buf=buf})
        end
    end
    api.nvim_buf_set_lines(buf, 0, 0, false, out_lines)
end

function M.run()
    vim.cmd.update()
    if vim.bo.filetype == 'lua' then
        M.run_lua()
    else
        M.run_script()
    end
end

return M
