local M = {}

local units = {
    ["seconds"] = 1,
    ["milliseconds"] = 1000,
    ["microseconds"] = 1000000,
    ["nanoseconds"] = 1000000000,
}

function M.benchmark(f, opts)
    local defaults = { unit = "seconds", repeats = 1, decimals = 5, args = nil }
    opts = opts or {}
    opts = vim.tbl_extend("keep", opts, defaults)
    local elapsed = 0
    local multiplier = units[opts.unit]
    for _ = 1, opts.repeats do
        local now = os.clock()
        f(opts.args)
        elapsed = elapsed + (os.clock() - now)
    end
    print(
        string.format(
            "Benchmark results:\n  - %d function calls\n  - %."
                .. opts.decimals
                .. "f %s elapsed\n  - %."
                .. opts.decimals
                .. "f %s avg execution time.",
            opts.repeats,
            elapsed * multiplier,
            opts.unit,
            (elapsed / opts.repeats) * multiplier,
            opts.unit
        )
    )
end

return M
