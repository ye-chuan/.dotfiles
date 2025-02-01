" This config is meant to be sharable between Vim and NeoVim

" if has("nvim") here doesn't mean that the option is only available for
" NeoVim, but rather that Debian stable (and hence Ubuntu) hasn't caught up
" with a version of Vim that supports that feature

" Paths (should detect Windows/Linux, Vim/NeoVim)
"" CONFIG_DIR for storing Vim/NeoVim Configurations
"" Usually ~/.config/nvim for NeoVim, ~/.vim for Vim,
"" for both Windows and Linux
let CONFIG_HOME=$HOME."/.config"
if exists("$XDG_CONFIG_HOME")
    let CONFIG_HOME=$XDG_CONFIG_HOME
endif
let CONFIG_DIR=$HOME."/.vim"
if has("nvim")
    let CONFIG_DIR=CONFIG_HOME."/nvim"
endif

"" STATE_DIR for storing state data (e.g. swap, undos)
"" Usually ~/.local/state/nvim on Linux, ~/AppData/Local/nvim-data on Windows; 
"" Vim doesn't have such a dedicated directory by default, it shares the same
"" location has the Configuration Directory
if has("win32")
    let STATE_DIR=$LOCALAPPDATA."/nvim-data"
else
    let STATE_DIR=$HOME."/.local/state/nvim"
endif
if exists("$XDG_STATE_HOME")
    let STATE_DIR=$XDG_STATE_HOME."/nvim"
endif
if !has("nvim")
    let STATE_DIR=CONFIG_DIR
endif

" Sane Defaults
set encoding=utf-8  " Even though Vim might set to UTF-8 based on locale, but we will put this here just in case

set number
set relativenumber

set backspace=indent,eol,start " Allows backspacing autoindents, /n /r etc, and the start location of the Insert

set hlsearch
set incsearch       " Search incrementally (highlight as you search)

set nrformats=bin,hex   " Number formats supported by CTRL-A and CTRL-X

syntax on           " Syntax Highlighting
set termguicolors   " Enables 24-bit RBG, doesn't work on some builds
set laststatus=2    " Always show status line (even when there's only 1 window open)
set ruler           " Show Col & Lines No. in bottom right of the status line
set showcmd         " Show the little pending normal mode commands at bottom right of status line

set scrolloff=3         " Padding lines when scrolling
set sidescroll=1        " Each time we try to move out of screen to the right, we show 1 more character
set nowrap              " Do not wrap lines
set display=lastline    " Try to show as much of the last line as possible, but with "@@@" at the last col to denote that the line continues on below (doesn't affect when `set nowrap`)
set nostartofline       " Do not move cursor back to the start of the line when scrolling, deleting lines, etc.

set tabstop=4       " Width of `\t` character
set softtabstop=4   " Width of a "Tab" key (and Backspace)
set shiftwidth=4    " Width of a level of indent (e.g. >>)
set expandtab       " Expands `\t` to spaces whenever editing
set autoindent      " autoindent: Always maintain same indentation as previous line
set nosmartindent   " smartindent: Might add more indentation (we will be using the better `filetype indent on`
set nocindent       " cindent: Follow C syntax for indent (will be auto enabled for c files if we use `filetype indent on`)

" Built-in Filetype Plugin (use `:filetype` to view which features are enabled, `:h filetype` for help)
filetype on         " Enables filetype detection (a bit redundant since it is on by default and when setting `filetype indent on` etc)
filetype indent on  " Enables indentation based on filetype by setting `indentexpr` using built-in scripts for each filetype (see `$VIMRUNTIME/indent/<filetype>.vim` which might redirect to a function in `$VIMRUNTIME/autoload/<filetype>.vim`)
filetype plugin on  " Enables filetype plugins (located in `$VIMRUNTIME/ftplugin/<filetype>.vim`); we can write our own additions best saved to `~/.vim/after/ftplugin` (reason in `:h ftplugin-overrule)
" Of course external plugins would override these. e.g. treesitter for indentation, LSP for omnifunc (which ftplugin might have set)

set noequalalways   " Prevents vim from auto-resizing all windows to equal size of closing a window (mainly to keep usual terminal window at the bottom from growing when I close a preview window)

set complete=       " Options for what is included in Vim's built-in completion i_<CTRL-N> (see :h cpt)
set complete+=.     " Scan current buffer
set complete+=w     " Scan buffers from other windows
set complete+=b     " Scan other loaded buffers in the buffer list
set complete+=u     " Scan unloaded buffers in buffer list
set complete+=t     " Scan tags (tag completion)
set complete+=i     " Scan also included files (best effort basis)
set wildmenu        " Enable completion menu in the command line
if has("nvim")
    set wildoptions=pum,tagfile     " Uses pop-up menu for `wildmenu`, also include completions from tagfiles
endif

set formatoptions=      " Remove all format options first, we will them them one by one (see :help fo)
set formatoptions+=o    " Auto insert comment leader (eg. //) on `o` or `O` in Normal Mode (CTRL-U is meant to quickly undo this auto-addition)
set formatoptions+=r    " Auto insert comment leader (eg. //) after <CR> in Insert Mode
if has("nvim")
    set formatoptions+=/    " This makes it such that // won't be auto-inserted in cindent for inline comments (only for line comments)
endif
set formatoptions+=j    " Auto remove comment leader when `J` (joining lines) in Normal Mode (where appropriate)
set formatoptions+=c    " Auto hard-wraps comments once it is longer than `textwidth` (Which isn't currently set; Don't really use it but was default so will keep first)
set formatoptions+=q    " Enable `gq` for manually triggering the wraps, once again no use unless `textwidth` is set
set formatoptions+=l	" Long lines not broken / auto-wrapped if it was already long when entering insert mode (once again not used)

set listchars=tab:>\ ,trail:·,nbsp:+    " For rendering in the `:list` command

set nojoinspaces    " People used to like to put 2 spaces after e.g. '.', we don't do that shit no more
set belloff=all

set hidden      " Allows for buffers to be kept in the background without being saved to disk (multitasking)
set history=10000   " Maximum undo history
set undofile    " Persistent undo history
if !isdirectory(STATE_DIR."/undo")
    call mkdir(STATE_DIR."/undo", "", 0700) " Create with 0700 permissions
endif
let &undodir=STATE_DIR."/undo//" " This is equivalent to `set undodir=...` but with variables
" PRIVACY WARNING: Vim/NeoVim doesn't clear undofiles, we need to manually clear them
" `setlocal noundofile` before writing (:w) to prevent the writing of undo file

set path+=**    " Allows :find to search recursively from the cwd (for large projects, undo this can add specifically the sources e.g. +=src/**)

" Just to be consistent with NeoVim
set commentstring=
set autoread                    " (Only works for GUI Vim so...) Automatically read files that have been changed outside of Vim
set fillchars=vert:│,fold:·     " See `:h fillchars`
set nofsync                     " fsync attempts to flush to disk every `:write`, NeoVim have this off by default probably to speed up editing large files
set nolangremap
set mouse=nvi                   " Enable mouse support for Normal, Visual, and Insert Modes
set mousemodel=popup_setpos     " Right-Click will move cursor to position and trigger popup
set smarttab                    " Redundant in this config, only affects when `shiftwidth` is different from `tabstop` or `softtabstop`
set tabpagemax=50
set switchbuf=uselast           " Use last used window when jumping from quickfix list
set ttyfast                     " Terminals do have fast connection now don't they
set ttimeoutlen=50
set viminfo+=!                  " Stores also any GLOBAL_VARIABLES in .viminfo for persistence

" Mappings
let mapleader = " "

"" Other Remaps (Overriden Defaults)
nnoremap Y y$|  " To be consistent with D and C (even Vim recommends this remap)
inoremap <C-W> <C-G>u<C-W>|     " Allows undoing C-W (Delete word in insert mode)
inoremap <C-U> <C-G>u<C-U>|     " Allows undoing C-U (Delete till start of line in insert mode)
nnoremap <BS> <C-^>

"" Text Navigation
nnoremap ]t vat<Esc>|       " HTML End Tag Navigation
nnoremap [t vato<Esc>|      " HTML Start Tag Navigation

"" QuickFix
nnoremap [q <Cmd>cprevious<CR>
nnoremap ]q <Cmd>cnext<CR>

"" System Clipboard
nnoremap <Leader>y "+y
vnoremap <Leader>y "+y
nnoremap <Leader>Y "+Y

nnoremap <Leader>p "+p| " (Visual Mode remap for this because I'd like that to do something else)
nnoremap <Leader>P "+P

"" Non-Register-Overriding Operations
vnoremap <Leader>p "_dP|    " Paste without over selection without overriding register (Different behaviour in Normal Mode)
nnoremap <Leader>d "_d|     " Deletes to void register
vnoremap <Leader>d "_d|     " Deletes to void register

"" Scrolling
nnoremap <C-L> zL| " Overrides Redraw Screen but should be fine
nnoremap <C-H> zH

"" Explorer (Netrw)
nnoremap <Leader>ee <Cmd>Lexplore<CR>|              " Opens Netrw on the left panel (in cwd)
nnoremap <Leader>ec <Cmd>silent Lexplore %:h<CR>|   " Opens in current file directory (% gives path of current file, :h removes the filename leaving only the directory; see :h _% and :h ::h), the `silent` is to fix an annoying bug that requires us to press enter.

"" Implement Neovim's Q (play last recorded macro)
nnoremap q <Cmd>call QImplementation()<CR>
nnoremap Q <Cmd>exe "normal! " . v:count1 . "@" . g:qreg<CR>

let g:qreg = "@"
function! QImplementation()
    if reg_recording() == ""
        " Start Recording
        let g:qreg = getcharstr()
        exe "normal! q" . g:qreg
    else
        " End Recording
        exe "normal! q"
        " Note that the `q` used to activate this function is recorded in the macro which we need to remove
        call setreg(g:qreg, substitute(getreg(g:qreg), "q$", "", ""))
    endif
endfunction

"" Terminal (Vim 8+)
tnoremap <C-]> <C-\>|                                           " Prevent class with tmux leader <C-\>
nnoremap <F12> <Cmd>call ToggleTerminal("default")<CR>|         " Create/Show the Terminal named "default"
tnoremap <F12> <C-\><C-N>:call ToggleTerminal("default")<CR>|   " Exit Terminal Mode and Hides Terminal Window
 
function! ToggleTerminal(name)                  " Note that VimScript scopes the argument `name` as `a:name`
    " Note that existing Terminal Buffer will only be restored if `:set nohidden`, else a new one is created every time
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
        if has("nvim")
            exe "terminal"              | " Start a new Terminal buffer in this Window (it will have a default name)
        else
            exe "terminal ++curwin"     | " Vanilla vim auto split panes which we do not want
        endif
        exe "f" bufferalias             | " Alias for easier reference (essentially creates another buffer that links to this)
        exe "set nobuflisted"           | " Unlist the buffer (so we can :bn & :bp without seeing the terminal)
        echo "Created Terminal" bufferalias
    endif

    if has("nvim")
        exe "normal" "i"    | " Go directly into Insert mode in the Terminal (Vanilla Vim auto puts us in Insert Mode)
    endif
endfunction

" Plugins Related Stuff
"" Netrw Config (built-in so not exactly a plugin but still)
let g:netrw_winsize = 20
let g:netrw_banner = 0      " Hide the top banner (press I to show)

"" Filetype Config (also built-in plugin)
""" indentexpr which is set by the filetype plugin (see `:h indent-expression`)
let g:html_indent_script1 = "inc"   " So <script> tag also increases indent of it's 1st line (see `:h html-indenting`)
let g:html_indent_style1 = "inc"    " Same but for <style> tag (honestly weird that these aren't default!)

"" Undotree
nnoremap <F9> <Cmd>UndotreeToggle<CR>

