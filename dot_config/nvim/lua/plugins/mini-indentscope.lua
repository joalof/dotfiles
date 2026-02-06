return {
    "nvim-mini/mini.indentscope",
    version = false, -- wait till new 0.7.0 release to put it back on semver
    event = { "BufReadPre", "BufNewFile" },
    init = function()
        vim.api.nvim_create_autocmd("FileType", {
            group = vim.api.nvim_create_augroup('joakim.indentscope', {clear = true}),
            desc = 'Disable mini-indentscope for special filetypes',
            pattern = {
                "help",
                "alpha",
                "Trouble",
                "lazy",
                "mason",
                "notify",
            },
            callback = function()
                vim.b.miniindentscope_disable = true
            end,
        })
    end,
    config = function()
        require("mini.indentscope").setup({
            symbol = "│",
            options = { try_as_border = true },
            draw = {
                animation = require("mini.indentscope").gen_animation.none(),
            },
        })
    end
}
