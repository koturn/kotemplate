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


" {{{ s:converter
let s:converter = {
      \ 'name': '<+FILEBASE+>',
      \ 'description': 'my converter',
      \}
" }}}

function! s:converter.filter(candidates, context) abort " {{{
  <+CURSOR+>
  for candidate in a:candidates
    let candidate.word = candidate.word[0 : 29]
  endfor
  return a:candidates
endfunction " }}}


function! unite#filters#<+FILEBASE+>#define() abort " {{{
  return s:converter
endfunction " }}}


let &cpo = s:save_cpo
unlet s:save_cpo
