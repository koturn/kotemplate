" ============================================================================
" FILE: <+FILE+>
" AUTHOR: <+AUTHOR+> <<+MAIL_ADDRESS+>>
" Last Modified: <+DATE+>
" DESCRIPTION: {{{
" descriptions.
" milqi.vim: https://github.com/kamichidu/vim-milqi
" }}}
" ============================================================================
let s:save_cpo = &cpo
set cpo&vim

" Don't forget append following code to plugin/<+FILE+>
" command! -bar Milqi<+FILE_PASCAL+> call milqi#candidate_first(milqi#<+FILEBASE+>#define())

" {{{ s:define
let s:define = {'name': 'kotemplate'}
" }}}

function! milqi#<+FILEBASE+>#define() abort " {{{
  return s:define
endfunction " }}}

function! s:define.init(context) abort " {{{
  <+CURSOR+>
  return ['apple', 'banana', 'cake']
endfunction " }}}

function! s:define.accept(context, candidate) abort " {{{
  call milqi#exit()
  " Write actions here
endfunction " }}}

function! s:define.exit(context) abort " {{{
endfunction " }}}

function! s:define.get_abbr(context, candidate) abort " {{{
endfunction " }}}

function! s:define.lazy_init(context, query) abort " {{{
endfunction " }}}

function! s:define.async_init(context) abort " {{{
endfunction " }}}


let &cpo = s:save_cpo
unlet s:save_cpo
