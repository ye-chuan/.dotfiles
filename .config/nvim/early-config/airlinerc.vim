" Should be sourced early, before the vim-airline plugin loads
set noshowmode                      " Since we are already using airline to show the mode

let g:airline_extensions = ['tabline']       " Disable searching for non-existent plugins for integration
""" Tabline extension (to use tabline to show buffers)
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ''
let g:airline#extensions#tabline#left_alt_sep = ''
let g:airline#extensions#tabline#formatter = 'default'
let g:airline#extensions#tabline#buffer_nr_show = 1         " Shows Buffer Number
let g:airline#extensions#tabline#buffer_nr_format = '%s '   " %s is the buffer number, default is "%s: "

let g:airline_powerline_fonts = 1   " For vim-airline pluging to load Powerline fonts
if !exists('g:airline_symbols')
     let g:airline_symbols = {}
endif
let g:airline_left_sep = '' " '' ''
" let g:airline_left_alt_sep = '' " ''
let g:airline_right_sep = '' " '' ''
" let g:airline_right_alt_sep = '' " ''
" let g:airline_symbols.branch = ''
let g:airline_symbols.colnr = ' ' " ' ℅:'
" let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ' ' " ' :'
let g:airline_symbols.maxlinenr = ' ' " '☰ '
" let g:airline_symbols.dirty='⚡'
let g:airline_theme = 'catppuccin'

