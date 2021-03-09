" ============================================================================
" FILE: <+FILE+>
" AUTHOR: <+AUTHOR+> <<+MAIL_ADDRESS+>>
" Last Modified: <+DATE+>
" DESCRIPTION: {{{
" descriptions.
" ctrlp.vim: https://github.com/ctrlpvim/ctrlp.vim
" }}}
" ============================================================================
if get(g:, 'loaded_ctrlp_<+FILEBASE+>', 0)
  finish
endif
let g:loaded_ctrlp_<+FILEBASE+> = 1
let s:save_cpo = &cpo
set cpo&vim

let s:ctrlp_builtins = ctrlp#getvar('g:ctrlp_builtins')

" Don't forget append following code to plugin/<+FILE+>
" if match(split(&runtimepath, ','), 'ctrlp\.vim') != -1
"   command! CtrlP<+FILE_PASCAL+> call ctrlp#init(ctrlp#<+FILEBASE+>#id())
" endif

function! s:get_sid_prefix() abort " {{{
  return matchstr(expand('<sfile>'), 'function \zs<SNR>\d\+_\zeget_sid_prefix$')
endfunction " }}}
let s:sid_prefix = s:get_sid_prefix()
delfunction s:get_sid_prefix

" {{{ g:ctrlp_ext_vars
let g:ctrlp_ext_vars = add(get(g:, 'ctrlp_ext_vars', []), {
      \ 'init': s:sid_prefix . 'init()',
      \ 'accept': s:sid_prefix . 'accept',
      \ 'lname': '<+FILEBASE+>',
      \ 'sname': '<+FILEBASE+>',
      \ 'type': 'line',
      \ 'nolim': 1
      \})
" }}}
let s:id = s:ctrlp_builtins + len(g:ctrlp_ext_vars)
unlet s:ctrlp_builtins s:sid_prefix


function! ctrlp#<+FILEBASE+>#id() abort " {{{
  return s:id
endfunction " }}}


function! s:init() abort " {{{
  <+CURSOR+>
  return []
endfunction " }}}

function! s:accept(mode, str) abort " {{{
  call ctrlp#exit()
  " Write actions
endfunction " }}}


let &cpo = s:save_cpo
unlet s:save_cpo
