" ============================================================================
" FILE: <+FILE+>
" AUTHOR: <+AUTHOR+> <<+MAIL_ADDRESS+>>
" Last Modified: <+DATE+>
" DESCRIPTION: {{{
" descriptions.
" ctrlp.vim: https://github.com/ctrlpvim/ctrlp.vim
" }}}
" ============================================================================
let s:save_cpo = &cpo
set cpo&vim
if exists('g:loaded_ctrlp_<+FILEBASE+>') && g:loaded_ctrlp_<+FILEBASE+>
  finish
endif
let g:loaded_ctrlp_<+FILEBASE+> = 1
let s:ctrlp_builtins = ctrlp#getvar('g:ctrlp_builtins')

" Don't forget append following code to plugin/<+FILE+>
" if match(split(&runtimepath, ','), 'ctrlp\.vim') != -1
"   command! CtrlP<+FILE_PASCAL+> call ctrlp#init(ctrlp#<+FILEBASE+>#id())
" endif

function! s:get_sid() abort
  return matchstr(expand('<sfile>'), '^function <SNR>\zs\d\+\ze_get_sid$')
endfunction
let s:sid_prefix = '<SNR>' . s:get_sid() . '_'
let g:ctrlp_ext_var = add(get(g:, 'ctrlp_ext_vars', []), {
      \ 'init': s:sid_prefix . 'init()',
      \ 'accept': s:sid_prefix . 'accept',
      \ 'lname': '<+FILEBASE+>',
      \ 'sname': '<+FILEBASE+>',
      \ 'type': 'line',
      \ 'enter': s:sid_prefix . 'enter()',
      \ 'exit': s:sid_prefix . 'exit()',
      \ 'opts': s:sid_prefix . 'opts()',
      \ 'sort': 0,
      \ 'nolim': 1
      \})
let s:id = s:ctrlp_builtins + len(g:ctrlp_ext_vars)
delfunction s:get_sid
unlet s:ctrlp_builtins s:sid_prefix


function! ctrlp#<+FILEBASE+>#id() abort
  return s:id
endfunction


function! s:init() abort
  <+CURSOR+>
  return []
endfunction

function! s:accept(mode, str) abort
  call ctrlp#exit()
  " Write actions
endfunction

function! s:enter() abort
  " Called before s:init()
  " For example: get filetype
endfunction

function! s:exit() abort
  " Called when exit ctrlp
endfunction

function! s:opts() abort
  " Set options etc...
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
