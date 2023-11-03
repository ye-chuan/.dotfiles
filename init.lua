-- NeoVim-Only Configurations --

-- Import Vim Compatible Config File
local vimrc = vim.fn.stdpath("config") .. "/vimrc.vim"
vim.cmd.source(vimrc)

require "mainmodule"