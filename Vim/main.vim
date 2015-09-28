function! s:main() abort
  echo 'Hello World!'
  <+CURSOR+>
endfunction
setlocal maxfuncdepth=1000
call s:main()
