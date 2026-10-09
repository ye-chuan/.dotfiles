" Allows wrapping
setlocal wrap
setlocal linebreak
" Indented soft wrapping (a wrapped indented bullet point should still be indented)
setlocal breakindent
" `list:-1` here means to match the indent up to the list pattern (bullet point),
" see :h breakindentopt. This is so that the wrapped line will align with the
" first word of the its line when wrapped to the next line
setlocal breakindentopt=list:-1

" Treat blockquotes as lists too so that the soft wrap work
let &l:formatlistpat .= '\|^\s*\%(>\s*\)\+'
" For example, we will then get the following (the hard wrap here mimicks effects the intended effect of soft wrap):
" > This is one long long long line of
"   text that is soft wrapped with
"   proper intentation
" > > This is a nested blockquote that
"     is also propery soft wrapped to
"     the right indentation
" > The way we do this is by treating
"   the `>` as a "list character"
"   (like a bullet point), and then
"   making use of Vim's `breakindent`
"   to give the softwrap the correct
"   indentation
