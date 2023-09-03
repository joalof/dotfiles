return {
    'jose-elias-alvarez/null-ls.nvim',
    dependencies = {'nvim-lua/plenary.nvim'},
    event = {"BufReadPre", "BufNewFile"},
    opts = function()
        local nls = require("null-ls")
        return {
            root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git"),
            sources = {
                -- nls.builtins.formatting.stylua,
                nls.builtins.formatting.shfmt,
                nls.builtins.formatting.isort,
                nls.builtins.formatting.black,
            },
        }
    end,
}
