return {
    "HiPhish/rainbow-delimiters.nvim",
    config = function()
        -- make matched parentheses visible
        vim.api.nvim_set_hl(0, "MatchParen", {
            reverse = true,
            bold = true,
        })
    end,
}
