# Neovim Config

Welcome to my Neovim configuration!

The `vimrc.vim` file contains base configurations that also should work for vanilla Vim.

## Plugins
I value practicality over minimalism so if I think a certain plugin is
going to help improve my workflow, I will be installing it.

### LSP + Developer Experience
- nvim-lspconfig
    - Database of sane default configuration for many LSP servers
    - Note: Prior to NeoVim 0.11, it also handles configuration of LSP for Neovim's built-in LSP client
- nvim-mason
    - Allows for easier installation and management of LSPs, Linters, etc.
- mason-lspconfig
    - Allows for predefined list of LSP servers to be automatically installed
- undotree
    - Browse undo history paths which is impractical (not possible?) without a plugin like this
- nvim-todo-comments
    - Highlight & navigate special comments (e.g. `#TODO`)
    - Deps: `nvim-plenary`

> Remember to have the **latest version** of `npm` and `nodejs` which some stable Linux distros do not provide in their repo
> e.g. `pyright` uses `npm` for installation and `nodejs` to run

#### Completion
- nvim-cmp
    - Completion engine (sources separately installed)
    - Responsible for the auto-completion popup
- lua-snip
    - Snippets engine (i.e. LuaSnip), supports VSCode Snippets and LuaSnippets (very powerful)
    - To be used with a completion engine (like `nvim-cmp` via `cmp-luasnip`)
- cmp-luasnip
    - nvim-cmp source for LuaSnip's snippets
    - Note that snippet expansion is done by LuaSnip, nvim-cmp just does the completion of the snippet triggers
- cmp-nvim-lsp
    - nvim-cmp source for NeoVim's built-in LSP client
    - Note that nvim-cmp adds extra capabilities (e.g. snippets support when used with a snippets engine) to NeoVim
      that can should be broadcasted to the LSP server (the capabilities are listed in `require("cmp_nvim_lsp").default_capabilities()`)
- cmp-buffer
    - nvim-cmp source for words within a buffer (like the built-in i_CTRL-N, but integrated into nvim-cmp)
- copilot-vim (opt)
    - Just to test out GitHub's Copilot, might remove in the future

### Project Navigation
- nvim-telescope
    - Deps: `nvim-plenary`

### Aesthetics
- nvim-catpuccin-theme
- vim-airline
- nvim-web-devicons
    - File icons support for other plugins
- nvim-treesitter
    - Mainly for improved syntax highlighting (replaces `:syntax`)

### Others
- nvim-plenary
    - Plenary dependancy for nvim-telescope


## Plugin Management
This configuration makes use of the package system that was introduced since Vim 8.0

To manage the plugins, I will be using Git's submodule feature.

To install plugins:
```sh
mydotfiles submodule add --name {abitrary-name} {https://github.com/.../plugin.git} {.config/pack/{abitrary-pkg-name}/{start|opt}/{repo-root-directory}}
```

> Note to **not** use a full path in the destination path, but rather start relative to the git directory (start with `.config/` for my case of whereby `mydotfiles` git repo is the home directory)
> This is because the destination path is saved in `.gitmodules`, saving the full path ties it to a specific username

> Plugins installed in the `opt` directory will not be auto-loaded in NeoVim and will have to be manually loaded with `:packadd {abitrary-pkg-name}

To clone to another machine (including all submodules), see how to clone recursively from the main `.dotfiles` repo documentation.

Remember to generate helptags in nvim with
```
:helptags ALL
```

To update all plugins, update all submodules, as per documentation in the main `.dotfiles` repo.

## Overriden Mappings
- <C-L> - Originally Redraw Screen
- Y - Originally yy
- <C-W> - Delete word in Insert Mode (remapped to maintain function but after setting an undo point)
- <C-U> - Delete till start in Insert Mode (remapped to maintain function but after setting an undo point)
- Q - Neovim's default is to replay last recorded macro instead of entering Ex mode, this .vimrc has code that mimicks Neovim's implementation

### Overriden in Plugins
#### nvim-cmp
- i_<C-N> - Replaced by auto-completion in nvim-cmp (default built-in completion by <C-N> can still be accessed with i_<C-X><C-N>)
- i_<C-P> - Replaced by auto-completion in nvim-cmp (default built-in completion by <C-N> can still be accessed with i_<C-X><C-N>)
- i_<C-Y> - Confirm choice in nvim-cmp (originally to copy the character directly above)

#### LuaSnip
- i_<C-K> - Expand / jump to next field in snippet (originally for inserting digraphs)
- i_<C-J> - Jump to previous field in snippet (originally to begin newline, like <CR>)
- i_<C-L> - Cycle through choices in snippet (originally not mapped)

## Dependencies
The current configuration would require the following dependencies
- git
    - For Mason to download & install various LSPs
- unzip
    - For Mason to download & install various LSPs
- gcc & g++ (same package)
    - For Mason to download & install various LSPs
- npm & nodejs (usually installed together)
    - For Mason to download, install, and run various LSPs

## To Do
- Perhaps separate NeoVim Plugin Management with my main dotfiles management, so that NeoVim plugins more conveniently with a "for each submodule pull".
  The current set up means that all other submodules as part of my dotfiles configuration will also be updated.
  This is **low priority**.
  Suggestion:
    - NeoVim in a separate submodule? But nested submodules are probably not the best idea
    - Using a third-party NeoVim plugin manager?
