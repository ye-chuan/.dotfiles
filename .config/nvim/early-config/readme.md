This is where we store configurations for plugins that are to be done early, before the plugin is loaded.

The sourcing of these configs is the responsibility of `init.lua` for NeoVim and `sharedrc.vim` for Vim (and NeoVim).

Configurations that are to be done after the plugin is loaded exists under `after/plugin/`
