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

" Don't forget append following code to plugin/<+FILE+>
" command! -bar Alti<+FILE_PASCAL+> call alti#init(alti#<+FILEBASE+>#define())

function! s:get_sid_prefix() abort
  return matchstr(expand('<sfile>'), '^function \zs<SNR>\d\+_\zeget_sid_prefix$')
endfunction
let s:sid_prefix = s:get_sid_prefix()
delfunction s:get_sid_prefix

let s:define = {
      \ 'name': '<+FILEBASE+>',
      \ 'enter': s:sid_prefix . 'enter',
      \ 'cmpl': s:sid_prefix . 'cmpl',
      \ 'prompt': s:sid_prefix . 'prompt',
      \ 'submitted': s:sid_prefix . 'submitted'
      \}
unlet s:sid_prefix

function! alti#<+FILEBASE+>#define() abort
  return s:define
endfunction


function! s:enter() abort dict
  let self.candidates = ['apple', 'banana', 'cake']
endfunction

function! s:cmpl(context) abort dict
  return a:context.fuzzy_filtered(self.candidates)
endfunction

function! s:prompt(context) abort
  return '> '
endfunction

function! s:submitted(context, line) abort
  echo a:context.selection
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
