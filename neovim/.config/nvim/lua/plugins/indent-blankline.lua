return {
    "lukas-reineke/indent-blankline.nvim",
    event = "BufReadPre",
    config = function()
        require("ibl").setup({
            scope = {
                enabled = false,
                show_start = false,
                show_end = false,
            },
            exclude = {
                filetypes = {
                    "help",
                    "alpha",
                    "dashboard",
                    "Trouble",
                    "lazy",
                    "mason",
                    "notify",
                },
            },
        })
    end,
}
