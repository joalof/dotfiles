local redir = require('utils.redir')

vim.api.nvim_create_user_command("Redir", redir.redir, {
    nargs = "+",
    complete = "command",
    range = true,
    bang = true,
})
