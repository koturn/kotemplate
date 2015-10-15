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

let s:define = {
      \ 'name': '<+FILEBASE+>',
      \ 'default_text': '',
      \ 'static_head': '',
      \ 'append_sep': 1,
      \ 'enter': 'alti#<+FILEBASE+>#enter',
      \ 'cmpl': 'alti#<+FILEBASE+>#cmpl',
      \ 'prompt': 'alti#<+FILEBASE+>#prompt',
      \ 'insertstr': 'alti#<+FILEBASE+>#insertstr',
      \ 'submitted': 'alti#<+FILEBASE+>#submitted',
      \ 'canceled': 'alti#<+FILEBASE+>#canceled',
      \ 'default_actions': [],
      \ 'menu': [],
      \ 'actions': {},
      \ 'bind': {}
      \}

function! alti#<+FILEBASE+>#define() abort
  return s:define
endfunction

function! alti#<+FILEBASE+>#enter() abort
  " Write initialize: get filetype etc...
endfunction

function! alti#<+FILEBASE+>#cmpl(context) abort
  let arglead = tolower(a:context.arglead)
  return filter(['apple', 'banana', 'cake'], '!stridx(tolower(v:val), arglead)')
endfunction

function! alti#<+FILEBASE+>#prompt(context) abort
  return '> '
endfunction

function! alti#<+FILEBASE+>#insertstr(context) abort
  return substitute(a:context.selection, '^' . a:context.arglead, '', '')
endfunction

function! alti#<+FILEBASE+>#submitted(context, line) abort
  echo a:context.inputs[0]
endfunction

function! alti#<+FILEBASE+>#canceled(context, line) abort
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
