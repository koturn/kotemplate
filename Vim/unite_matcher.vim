" ============================================================================
" FILE: <+FILE+>
" AUTHOR: <+AUTHOR+> <<+MAIL_ADDRESS+>>
" DESCRIPTION: {{{
" descriptions.
" unite.vim: https://github.com/Shougo/unite.vim
" }}}
" ============================================================================
let s:save_cpo = &cpo
set cpo&vim


" {{{ s:matcher
let s:matcher = {
      \ 'name': '<+FILEBASE+>',
      \ 'description': 'my matcher',
      \}
" }}}

function! s:matcher.filter(candidates, context) abort " {{{
  <+CURSOR+>
  if a:context.input ==# ''
    return unite#filters#filter_matcher(a:candidates, '', a:context)
  endif
  let candidates = a:candidates
  for input in a:context.input_list
    if input == '!' || input == ''
      continue
    endif
    let a:context.input = input
    let candidates = unite#filters#matcher_regexp#regexp_matcher(candidates, input, a:context)
  endfor
  return candidates
endfunction " }}}

function! s:matcher.pattern(input) abort " {{{
  return substitute(a:input, '\$cd', getcwd(), 'g')
endfunction " }}}


function! unite#filters#<+FILEBASE+>#define() abort " {{{
  return s:matcher
endfunction " }}}


let &cpo = s:save_cpo
unlet s:save_cpo
