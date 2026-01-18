return {
    "HiPhish/rainbow-delimiters.nvim",
    
    config = function()
        require('rainbow-delimiters.setup').setup({
            highlight = {
                '@punctuation.bracket',
                'RainbowDelimiterYellow',
                'RainbowDelimiterViolet',
                'RainbowDelimiterOrange',
                'RainbowDelimiterBlue',
                'RainbowDelimiterRed',
                'RainbowDelimiterCyan',
                -- 'RainbowDelimiterGreen',
            },
        })
        -- make matched parentheses visible
        vim.api.nvim_set_hl(0, "MatchParen", {
            -- reverse = true,
            underline = true,
            bold = true,
        })
    end,
}
