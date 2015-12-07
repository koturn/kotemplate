" ============================================================================
" FILE: <+FILE+>
" AUTHOR: <+AUTHOR+> <<+MAIL_ADDRESS+>>
" DESCRIPTION: {{{
" descriptions.
" unite.vim: https://github.com/Shougo/unite.vim
" }}}
" ============================================================================
let s:save_cpo = &cpo
set cpo&vim


let s:sorter = {
      \ 'name': '<+FILEBASE+>',
      \ 'description': 'my sorter',
      \}

function! s:sorter.filter(candidates, context) abort
  <+CURSOR+>
  return unite#util#sort_by(a:candidates, 'v:val.word')
endfunction


function! unite#filters#<+FILEBASE+>#define() abort
  return s:sorter
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
