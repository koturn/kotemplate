<+DIR+>
<%= repeat('=', len('<+DIR+>')) %>

[![Build Status](https://travis-ci.org/<+AUTHOR+>/<+DIR+>.png)](https://travis-ci.org/<+AUTHOR+>/<+DIR+>)

<+CURSOR+>


## Usage




## Sample configuration




## Installation

With [NeoBundle](https://github.com/Shougo/neobundle.vim).

```VimL
NeoBundle '<+AUTHOR+>/<+DIR+>'
```

If you want to use ''':NeoBundleLazy''', write following code in your .vimrc.

```VimL
NeoBundleLazy '<+AUTHOR+>/<+DIR+>'
if neobundle#tap('<+DIR+>')
  call neobundle#config({
        \ 'depends': 'apple/vim-apple',
        \ 'autoload': {
        \   'commands': [
        \     'Apple', 'Banana', 'Cake',
        \     {'name': 'AppleComplete', 'complete': 'file'},
        \     {'name': 'BananaComplete', 'complete': 'file'},
        \   ],
        \   'mappings': ['<Plug>(apple-'], ['n', '<Plug>(banana-'],
        \   'functions': ['Diamond', 'Electoric'],
        \   'function_prefix': 'xxxx'
        \ }
        \})
  call neobundle#untap()
endif
```

With [Vundle](https://github.com/VundleVim/Vundle.vim).

```VimL
Plugin '<+AUTHOR+>/<+DIR+>'
```

With [vim-plug](https://github.com/junegunn/vim-plug).

```VimL
Plug '<+AUTHOR+>/<+DIR+>'
```

If you don't want to use plugin manager, put files and directories on
```~/.vim/```, or ```%HOME%/vimfiles``` on Windows.


## LICENSE

This software is released under the MIT License, see [LICENSE](LICENSE).
