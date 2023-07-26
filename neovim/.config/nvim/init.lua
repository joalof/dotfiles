vim.g.mapleader = ","

-- bootstrap lazy.nvim package manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup(
  'plugins',
  {
    ui = {border = 'rounded'},
    dev = {path = "~/code"},
  }
)

require('profile.options')
require('profile.mappings')
require('profile.commands')
require('profile.autocmds')
