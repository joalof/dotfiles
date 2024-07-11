local M = {}

local units = {
    ['seconds'] = 1,
    ['milliseconds'] = 1000,
    ['microseconds'] = 1000000,
    ['nanoseconds'] = 1000000000
}

function M.benchmark(f, opts)
    local defaults = {unit='seconds', repeats=1, decimals=5, args=nil}
    opts = opts or {}
    opts = vim.tbl_extend('keep', opts, defaults)
    local elapsed = 0
    local multiplier = units[opts.unit]
    for _ = 1, opts.repeats do
        local now = os.clock()
        f(opts.args)
        elapsed = elapsed + (os.clock() - now)
    end
    print(string.format('Benchmark results:\n  - %d function calls\n  - %.'.. opts.decimals ..'f %s elapsed\n  - %.'.. opts.decimals ..'f %s avg execution time.', opts.repeats, elapsed * multiplier, opts.unit, (elapsed / opts.repeats) * multiplier, opts.unit))
end

function M.bind_args(func, ...)
    local bound_args = { ... }

    return function(...)
        return func(M.unpack(bound_args), ...)
    end
end

function M.switch(param, t)
    local case = t[param]
    if case then
        return case()
    end
    local default_fn = t["default"]
    return default_fn and default_fn() or nil
end

function M.debounce(fn, ms)
    local timer = vim.loop.new_timer()

    local function wrapped_fn(...)
        local args = { ... }
        timer:stop()
        timer:start(ms, 0, function()
            pcall(
                vim.schedule_wrap(function(...)
                    fn(...)
                    timer:stop()
                end),
                select(1, M.unpack(args))
            )
        end)
    end
    return wrapped_fn, timer
end

function M.isinstance(object, class)
    local mt = getmetatable(object)

    if mt and object then
        return type(object) == "table" and mt.__index == class
    end

    return false
end

return M
