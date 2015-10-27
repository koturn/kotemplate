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

function! s:get_sid() abort
  return matchstr(expand('<sfile>'), '^function <SNR>\zs\d\+\ze_get_sid$')
endfunction
let s:sid_prefix = '<SNR>' . s:get_sid() . '_'
delfunction s:get_sid
let s:define = {
      \ 'name': '<+FILEBASE+>',
      \ 'default_text': '',
      \ 'static_head': '',
      \ 'append_sep': 1,
      \ 'enter': s:sid_prefix . 'enter',
      \ 'cmpl': s:sid_prefix . 'cmpl',
      \ 'prompt': s:sid_prefix . 'prompt',
      \ 'insertstr': s:sid_prefix . 'insertstr',
      \ 'submitted': s:sid_prefix . 'submitted',
      \ 'canceled': s:sid_prefix . 'canceled',
      \ 'default_actions': [],
      \ 'menu': [],
      \ 'actions': {},
      \ 'bind': {}
      \}

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

function! s:insertstr(context) abort
  return substitute(a:context.selection, '^' . a:context.arglead, '', '')
endfunction

function! s:submitted(context, line) abort
  echo a:context.selection
endfunction

function! s:canceled(context, line) abort
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
