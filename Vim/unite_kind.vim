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


let s:kind = {
      \ 'name': '<+FILEBASE+>',
      \ 'action_table': {},
      \ 'default_action': 'my_action',
      \ 'parents': ['file'],
      \}

let s:kind.action_table.my_action = {
      \ 'description'
      \}
function! s:kind.action_table.my_action.func(candidate) abort
  <+CURSOR+>
endfunction


function! unite#kinds#<+FILEBASE+>#define() abort
  return s:kind
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
