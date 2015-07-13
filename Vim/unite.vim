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


" ============ "
" unite-source "
" ============ "
let s:source = {
      \ 'name': '<+FILEBASE+>',
      \ 'description': 'descriptions',
      \ 'action_table': {
      \   'my_action': {
      \     'description': 'descriptions',
      \   }
      \ },
      \ 'default_action': 'my_action'
      \}

function! s:source.action_table.my_action.func(candidate) abort
  " Write actions
  " a:candidate: Selected one candidate from return value from s:source.gather_candidates()
  <+CURSOR+>
endfunction

function! s:source.gather_candidates(args, context) abort
  " a:args: :Unite hoge:arg1:arg2 => ['arg1', 'arg2']
  return [
        \ {'word': 'word_a'},
        \ {'word': 'word_b'},
        \ {'word': 'word_c'}
        \]
endfunction

function! unite#sources#<+FILEBASE+>#define() abort
  return s:source
endfunction
unlet s:source


" ============ "
" unite-filter "
" ============ "
let s:filter = {
      \ 'name': 'my_converter'
      \}

function! s:filter.filter(candidates, context) abort
  for candidate in a:candidates
    let candidate.word = candidate.word[0 : 29]
  endfor
  return a:candidates
endfunction

call unite#define_filter(s:filter)
unlet s:filter
call unite#custom_source('<+FILEBASE+>', 'converters', 'my_converter')


" ====== "
" sorter "
" ====== "
let s:filter = {
      \ 'name' : 'my_sorter'
      \}

function! s:filter.filter(candidates, context) abort
  return unite#util#sort_by(a:candidates, 'v:val.word')
endfunction

call unite#define_filter(s:filter)
unlet s:filter
call unite#custom_source('<+FILEBASE+>', 'sorters', 'my_sorter')
" call unite#custom_source('<+FILEBASE+>', 'sorters', ['my_sorter', 'sorter_reverse'])


let &cpo = s:save_cpo
unlet s:save_cpo
