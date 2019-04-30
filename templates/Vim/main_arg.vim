function! s:main(argc, argv) abort
  echo 'argc:' argc
  echo 'argv:' argv
  <+CURSOR+>
endfunction
setlocal maxfuncdepth=1000
call s:main(argc(), argv())
