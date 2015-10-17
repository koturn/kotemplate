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

let s:<+FILEBASE+>_var = {
      \ 'init': 'ctrlp#<+FILEBASE+>#init()',
      \ 'accept': 'ctrlp#<+FILEBASE+>#accept',
      \ 'lname': '<+FILEBASE+>',
      \ 'sname': '<+FILEBASE+>',
      \ 'type': 'line'
      \}
if exists('g:ctrlp_ext_vars') && !empty(g:ctrlp_ext_vars)
  let g:ctrlp_ext_vars = add(g:ctrlp_ext_vars, s:<+FILEBASE+>_var)
else
  let g:ctrlp_ext_vars = [s:<+FILEBASE+>_var]
endif
let s:id = s:ctrlp_builtins + len(g:ctrlp_ext_vars)
unlet s:ctrlp_builtins

function! ctrlp#<+FILEBASE+>#id() abort
  return s:id
endfunction

function! ctrlp#<+FILEBASE+>#init() abort
  <+CURSOR+>
  return []
endfunction

function! ctrlp#<+FILEBASE+>#accept(mode, str) abort
  call ctrlp#exit()
  " Write actions
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
