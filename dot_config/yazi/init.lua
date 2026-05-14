-- DuckDB plugin configuration
require("duckdb"):setup({
    mode = "summarized",
    cache_size = 500,
    row_id = false,
    minmax_column_width = 21,
    column_fit_factor = 10.0,
})
