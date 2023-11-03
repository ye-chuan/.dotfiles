Each folder here represents a "package" to Vim.
Each package should have a
- "start" folder (with plugins to run at startup)
- "opt" folder (with plugins to be optionally loaded with :packadd)

Of course, do check the "nvim/after/" directory for configurations to be ran after these plugins are loaded.

Let's try to keep plug-ins minimal (might not be Github name):
- nvim-treesitter
- catpuccin-theme
- nvim-telescope
- nvim-plenary (plenary functions for nvim-telescope)
- vim-airline
- nvim-web-devicons (for file icons support in other plugins)
