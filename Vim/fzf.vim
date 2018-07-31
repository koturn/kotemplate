" ============================================================================
" FILE: <+FILE+>
" AUTHOR: <+AUTHOR+> <<+MAIL_ADDRESS+>>
" Last Modified: <+DATE+>
" DESCRIPTION: {{{
" descriptions.
" fzf: https://github.com/junegunn/fzf
" }}}
" ============================================================================
let s:save_cpo = &cpo
set cpo&vim

" Don't forget append following code to plugin/<+FILE+>
" command! -bar FZF<+FILE_PASCAL+> call fzf#run(fzf#<+FILEBASE+>#option())

" {{{ s:options
let s:option = {
      \ 'options': '-m',
      \ 'down': 20
      \}
" }}}
function! s:option.sink(candidate) abort " {{{
  " Write actions
endfunction " }}}


function! fzf#<+FILEBASE+>#option() abort " {{{
  let s:option.source = s:gather_candidates()
  return s:option
endfunction " }}}


function! s:gather_candidates() abort " {{{
  <+CURSOR+>
  return ['apple', 'banana', 'cake']
endfunction " }}}


let &cpo = s:save_cpo
unlet s:save_cpo
