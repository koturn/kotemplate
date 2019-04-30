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


" {{{ s:source
let s:source = {
      \ 'name': '<+FILEBASE+>',
      \ 'description': 'descriptions',
      \ 'action_table': {},
      \ 'default_action': 'my_action'
      \}
" }}}

" {{{ s:source.action_table.my_action
let s:source.action_table.my_action = {
      \ 'description': 'my action'
      \}
function! s:source.action_table.my_action.func(candidate) abort " {{{
  <+CURSOR+>
endfunction " }}}

function! s:source.gather_candidates(args, context) abort " {{{
  let candidates = ['apple', 'banana', 'cake']
  return map(candidates, '{
        \ "word": v:val
        \}')
endfunction " }}}
" }}}


function! unite#sources#<+FILEBASE+>#define() abort " {{{
  return s:source
endfunction " }}}


let &cpo = s:save_cpo
unlet s:save_cpo
