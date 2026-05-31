" Allows wrapping
setlocal wrap
setlocal linebreak
" Indented wrapping (a wrapped indented bullet point should still be indented)
setlocal breakindent
" `list:-1` here means to match the indent up to the list pattern (bullet point),
" see :h breakindentopt. This is so that the wrapped line will align with the
" first word of the its line when wrapped to the next line
setlocal breakindentopt=list:-1
