-- highlight yank
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- autosaving
-- vim.api.nvim_create_autocmd("CursorHold", {
--     pattern = "*",
--     command = "update",
-- })

