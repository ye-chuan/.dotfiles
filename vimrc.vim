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
set incsearch       " Search incrementally (highlight as you search)

set termguicolors   " Enables 24-bit RBG, doesn't work on some builds
syntax on

set scrolloff=5     " Padding lines when scrolling
set nowrap          " Do not wrap lines
set sidescroll=1    " Each time we try to move out of screen to the right, we show 1 more character

set tabstop=4       " Width of `\t` character
set softtabstop=4   " Width of a "Tab" key (and Backspace)
set shiftwidth=4    " Width of a level of indent (e.g. >>)
set expandtab       " Expands `\t` to spaces whenever editing
set autoindent      " autoindent: Always maintain same indentation as previous line
set nosmartindent   " smartindent: Might add more indentation 
set nocindent       " cindent: Follow C syntax for indent (will be auto enabled for c files)

set noequalalways   " Prevents vim from auto-resizing all windows to equal size of closing a window (mainly to keep usual terminal window at the bottom from growing when I close a preview window)

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
nnoremap <Leader>ee :Lexplore<cr>|       " Opens Netrw on the left panel (in cwd)
nnoremap <Leader>ec :Lexplore %:h<cr>|   " Opens in current file directory (% gives path of current file, :h removes the filename leaving only the directory; see :h _% and :h ::h)

"" Terminal (Vim 8+)
nnoremap <F12> :call ToggleTerminal("default")<CR>|             " Create/Show the Terminal named "default"
tnoremap <F12> <C-\><C-N>:call ToggleTerminal("default")<CR>|   " Exit Terminal Mode and Hides Terminal Window
 
function! ToggleTerminal(name)                  " Note that VimScript scopes the argument `name` as `a:name`
    let bufferalias = "terminal_" . a:name      " Alias for this terminal's buffer name (. is the concat operator)
    let terminalheight = 6                      " Window height of the terminal
    let winnr = bufwinnr(bufferalias)           " Get Window Number of Terminal (-1 if doesn't exists, means Terminal is not visible)
    let buf = bufexists(bufferalias)            " Check if Terminal's buffer exists (we will show the same buffer if it exists)

    " Toggle Close
    if winnr > 0
        " Window is visible (so we toggle close the window)
        exe winnr "close"       | " Equivalent to :{winnr}close (Close Window Number {winnr})
        return
    endif

    " Toggle Open
    exe "botright horizontal split"     | " Split the Windows horizontally, flushed to the bottom
    exe "resize" terminalheight         | " Resize the Window
    if buf > 0
        " Terminal Buffer already exists, just show it
        exe "buffer" bufferalias        | " Show the Terminal's Buffer in this Window
        echo "Opened Terminal" bufferalias
    else
        " Terminal Buffer doesn't exists, will create one now
        exe "terminal"                  | " Start a new Terminal buffer in this Window (it will have a default name)
        exe "f" bufferalias             | " Alias for easier reference 
        echo "Created Terminal" bufferalias
    endif

    exe "normal" "i"    | " Go directly into Insert mode in the Terminal
endfunction


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


if !has('nvim') " Vim Specifics
    colorscheme catppuccin-mocha-vim
endif

endif

