" ============================================================================
" FILE: <+FILE+>
" AUTHOR: <+AUTHOR+> <<+MAIL_ADDRESS+>>
" Last Modified: <+DATE+>
" DESCRIPTION: {{{
" descriptions.
" }}}
" ============================================================================
highlight clear
if exists("syntax_on")
  syntax reset
endif
let g:colors_name = expand('<sfile>:t:r')

if &background ==# 'dark' " {{{ (Dark theme)
  <+CURSOR+>
" }}}
else " {{{ (Light theme)

endif " }}}
