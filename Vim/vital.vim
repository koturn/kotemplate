let s:save_cpo = &cpo
set cpo&vim


function! s:_vital_loaded(V) abort " {{{
  let s:List = a:V.import('Data.List')
endfunction " }}}

function! s:_vital_depends() abort " {{{
  return ['Data.List']
endfunction " }}}

function! s:module_function() abort " {{{
  <+CURSOR+>
endfunction " }}}


let &cpo = s:save_cpo
unlet s:save_cpo
