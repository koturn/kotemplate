#!/bin/bash

set -eu

vim -u NONE -i NONE -N -n -e -s -S <(cat <<EOF
function! s:main(input) abort
  <+CURSOR+>
  return 'answer'
endfunction

let s:input = getline(1, '$')
enew
put =s:main(s:input)
1 delete _
%print
EOF
) <(cat)
