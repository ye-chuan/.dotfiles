-- Import shared config file (shared with vanilla Vim)
local sharedrc = vim.fn.stdpath("config") .. "/sharedrc.vim"
vim.cmd.source(sharedrc)

-- Plugins that needs to be configured early
vim.cmd.source(vim.fn.stdpath("config") .. "/airlinerc.vim")

require "mainmodule"
