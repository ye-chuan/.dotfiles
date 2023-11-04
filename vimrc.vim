" This should work with original Vim, some plugins might need to be swapped for Vim versions
" NeoVim specifics are in `init.lua`

if exists('g:vscode')
    " VSCode Neovim Config (using the Neovim Extension)
    " line numbering are handled by VSCode: Settings>Editor>Line Numbers

else
" Normal Neovim Config
set number
set relativenumber

set hlsearch
set incsearch      " Search incrementally (highlight as you search)

set scrolloff=5    " Padding lines when scrolling
set termguicolors  " Enables 24-bit RBG, doesn't work on some builds

set nowrap         " Do not wrap lines
set sidescroll=1   " Each time we try to move out of screen to the right, we show 1 more character

set tabstop=4       " Width of `\t` character
set softtabstop=4   " Width of a "Tab" key (and Backspace)
set shiftwidth=4    " Width of a level of indent (e.g. >>)
set expandtab       " Expands `\t` to spaces whenever editing
set autoindent      " autoindent: Always maintain same indentation as previous line
set nosmartindent   " smartindent: Might add more indentation 
set nocindent       " cindent: Follow C syntax for indent (will be auto enabled for c files)

set formatoptions+=/	" This makes it such that // won't be auto-inserted in cindent for inline comments (only for line comments)

" Mappings
let mapleader = " "

"" System Clipboard
nnoremap <Leader>y "+y
vnoremap <Leader>y "+y
nnoremap <Leader>Y "+Y

nnoremap <Leader>p "+p
vnoremap <Leader>p "+p

"" Scrolling
nnoremap <C-L> zL| " Overrides Redraw Screen but should be fine
nnoremap <C-H> zH

"" Explorer (Netrw)
nnoremap <Leader>ec :Lexplore<cr>|       " Opens Netrw on the left panel (in cwd)
nnoremap <Leader>ee :Lexplore %:h<cr>|   " Opens in current file directory (% gives path of current file, :h removes the filename leaving only the directory; see :h _% and :h ::h

" Plugins Related Stuff
"" Netrw Config (built-in so not exactly a plugin but still)
let g:netrw_winsize = 20
let g:netrw_banner = 0      " Hide the top banner (press I to show)


"" vim-airline
set noshowmode                      " Since we are already using airline to show the mode
let g:airline_extensions = []       " Disable searching for non-existent plugins for integration
let g:airline_powerline_fonts = 1   " For vim-airline pluging to load Powerline fonts
if !exists('g:airline_symbols')
     let g:airline_symbols = {}
endif
" let g:airline_left_sep = '' " '' ''
" let g:airline_left_alt_sep = '' " ''
" let g:airline_right_sep = '' " '' ''
" let g:airline_right_alt_sep = '' " ''
" let g:airline_symbols.branch = ''
let g:airline_symbols.colnr = ' ' " ' ℅:'
" let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ' ' " ' :'
let g:airline_symbols.maxlinenr = ' ' " '☰ '
" let g:airline_symbols.dirty='⚡'
let g:airline_theme = "catppuccin"  " For vim-airline to use Catpuccin Theme (currently using neovim-catpuccin)

endif

