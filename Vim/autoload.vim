" ============================================================================
" FILE: <+FILE+>
" AUTHOR: <+AUTHOR+> <<+MAIL_ADDRESS+>>
" Last Modified: <+DATE+>
" DESCRIPTION: {{{
" descriptions.
" }}}
" ============================================================================
let s:save_cpo = &cpo
set cpo&vim


function! <+FILEBASE+>#<+CURSOR+>template()
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
