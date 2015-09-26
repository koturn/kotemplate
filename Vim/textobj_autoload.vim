if exists('g:loaded_textobj_<+FILEBASE+>')
  finish
endif
let g:loaded_textobj_<+FILEBASE+> = 1
let s:save_cpo = &cpo
set cpo&vim


call textobj#user#plugin('<+FILEBASE+>', {
      \ '-': {
      \   'select-a': 'au', '*select-a-function*': 'textobj#<+FILEBASE+>#select_a',
      \   'select-i': 'iu', '*select-i-function*': 'textobj#<+FILEBASE+>#select_i',
      \  },
      \})
call textobj#user#plugin('function', {
      \ 'a': {'select': 'af', 'select-function': 'textobj#<+FILEBASE+>#select_a'},
      \ 'i': {'select': 'if', 'select-function': 'textobj#<+FILEBASE+>#select_i'},
      \ 'A': {'select': 'aF', 'select-function': 'textobj#<+FILEBASE+>#select_A'},
      \ 'I': {'select': 'iF', 'select-function': 'textobj#<+FILEBASE+>#select_I'},
      \})


let &cpo = s:save_cpo
unlet s:save_cpo
