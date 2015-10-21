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
      \ 'enter': 'alti#<+FILEBASE+>#enter',
      \ 'cmpl': 'alti#<+FILEBASE+>#cmpl',
      \ 'prompt': 'alti#<+FILEBASE+>#prompt',
      \ 'submitted': 'alti#<+FILEBASE+>#submitted'
      \}

function! alti#<+FILEBASE+>#define() abort
  return s:define
endfunction

function! alti#<+FILEBASE+>#enter() abort dict
  let self.candidates = ['apple', 'banana', 'cake']
endfunction

function! alti#<+FILEBASE+>#cmpl(context) abort dict
  return a:context.fuzzy_filtered(self.candidates)
endfunction

function! alti#<+FILEBASE+>#prompt(context) abort
  return '> '
endfunction

function! alti#<+FILEBASE+>#submitted(context, line) abort
  echo a:context.selection
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
