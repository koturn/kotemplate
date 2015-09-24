" ============================================================================
" FILE: <+FILE+>
" AUTHOR: <+AUTHOR+> <<+MAIL_ADDRESS+>>
" Last Modified: <+DATE+>
" DESCRIPTION: {{{
" descriptions.
" alti.vim: https://github.com/LeafCage/alti.vim
" }}}
" ============================================================================
let s:save_cpo = &cpo
set cpo&vim


let s:define = {
      \ 'name': '<+FILEBASE+>',
      \ 'cmpl': 'alti#<+FILEBASE+>#cmpl',
      \ 'prompt': 'alti#<+FILEBASE+>#prompt',
      \ 'submitted': 'alti#<+FILEBASE+>#submitted'
      \}

function! alti#<+FILEBASE+>#define() abort
  return s:define
endfunction

function! alti#<+FILEBASE+>#cmpl(context) abort
  return filter(['apple', 'banana', 'cake'], 'stridx(tolower(v:val), tolower(a:arglead)) == 0')
endfunction

function! alti#<+FILEBASE+>#prompt(context) abort
  return '> '
endfunction

function! alti#<+FILEBASE+>#submitted(context, line) abort
  echo a:input
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
