local constants = require('overseer.constants')
local STATUS = constants.STATUS


local component = {
    desc = "Autocloses unused toggleterminals used for running code.",
    params = {
        grace_time = {
            type = "number",
            desc = "Grace time for killing unused terminals.",
            optional = true,
            default = 10,
        },
    },
    editable = false,
    serializable = false,
    -- The params passed in will match the params defined above
    constructor = function(params)
        return {
            ---@param status overseer.Status Can be CANCELED, FAILURE, or SUCCESS
            ---@param result table A result table.
            on_complete = function(self, task, status, result)
                -- Called when the task has reached a completed state.
                --
                local timer = vim.loop.new_timer()

                local function close_stale()
                    local term = task.strategy.term
                    if not term:is_open() then
                        timer:stop()
                        return
                    end
                    local bufnr = task.strategy.term.bufnr
                    local bufinfo = vim.fn.getbufinfo(bufnr)[1]
                    local stale = (os.time() - bufinfo.lastused) > params.grace_time
                    if stale then
                        term:shutdown()
                        task:dispose()
                        vim.cmd('cclose')
                        timer:stop()
                    end
                end

                if status == STATUS.CANCELED or status == STATUS.SUCCESS then
                    timer:start(0, 1000, vim.schedule_wrap(function() close_stale() end))
                end

            end,
        }
    end,
}

return component
