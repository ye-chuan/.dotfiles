This is where we store configurations for plugins that are to be done early, before the plugin is loaded.

The sourcing of these configs is the responsibility of `init.lua` for NeoVim and `vimrc` for Vim.

(For now, `sharedrc.vim` should not source anything here to keep plugin usage separate)

Configurations that are to be done after the plugin is loaded exists under `after/plugin/`
