" Note that vimtex uses the filetype plugin to only load on .tex or .bib files
" See `vimtex/ftplugin/`, we can also check if vimtex is enabled via the
" global var `g:vimtex_enabled` that it sets

" This is necessary for VimTeX to load properly. The "indent" is optional.
" Note: Most plugin managers will do this automatically!
filetype plugin indent on

" This enables Vim's and neovim's syntax-related features. Without this, some
" VimTeX features will not work (see ":help vimtex-requirements" for more
" info).
" Note: Most plugin managers will do this automatically!
"syntax enable

" Set `g:vimtex_syntax_enabled = 0` if we want to use purely something like TreeSitter for syntax highlighting
" However, we could also have both run by specifying `syntax=on` (see
" `treesitter.lua` config for more details)
"let g:vimtex_syntax_enabled = 0

" Viewer options: One may configure the viewer either by specifying a built-in
" viewer method (supported natively by VimTeX):
let g:vimtex_view_method = "zathura"
" Or a generic command
"let g:vimtex_view_general_viewer = 'okular'
"let g:vimtex_view_general_options = '--unique file:@pdf\#src:@line@tex'

" VimTeX uses latexmk as the default compiler backend. If you use it, which is
" strongly recommended, you probably don't need to configure anything. If you
" want another compiler backend, you can change it as follows. The list of
" supported backends and further explanation is provided in the documentation,
" see ":help vimtex-compiler".
"let g:vimtex_compiler_method = 'latexrun'

" Most VimTeX mappings rely on localleader.
" The default is usually fine and is the symbol "\".
"let maplocalleader = ","
