" ============================================================================
" FILE: <+FILE+>
" AUTHOR: <+AUTHOR+> <<+MAIL_ADDRESS+>>
" Last Modified: <+DATE+>
" DESCRIPTION: {{{
" descriptions.
" }}}
" ============================================================================


function! textobj#<+FILEBASE+>#select_a() abort " {{{
  <+CURSOR+>
  return ['v', head_pos, tail_pos]
endfunction " }}}

function! textobj#<+FILEBASE+>#select_i() abort " {{{
  return ['v', head_pos, tail_pos]
endfunction " }}}

function! textobj#<+FILEBASE+>#select_A() abort " {{{
  return ['V', head_pos, tail_pos]
endfunction " }}}

function! textobj#<+FILEBASE+>#select_I() abort " {{{
  return ['V', head_pos, tail_pos]
endfunction " }}}
