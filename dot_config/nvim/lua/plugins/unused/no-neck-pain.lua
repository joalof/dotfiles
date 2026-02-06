return {
    "shortcuts/no-neck-pain.nvim",
    version = "*",
    cmd = { "NoNeckPain" },
    config = function()
        require("no-neck-pain").setup({
            width = 125,
            buffers = {
                setNames = true,
                colors = {blend = -0.1},
            },
        })
    end,
}
