" ============================================================================
" FILE: <+FILE+>
" AUTHOR: <+AUTHOR+> <<+MAIL_ADDRESS+>>
" Last Modified: <+DATE+>
" DESCRIPTION: {{{
" descriptions.
" }}}
" ============================================================================
if exists('g:loaded_<+FILEBASE+>')
  finish
endif
let g:loaded_<+FILEBASE+> = 1
let s:save_cpo = &cpo
set cpo&vim


<+CURSOR+>


let &cpo = s:save_cpo
unlet s:save_cpo
