<+DIR+>
<%= repeat('=', len('<+DIR+>')) %>

[![Build Status](https://travis-ci.org/<+AUTHOR+>/<+DIR+>.png)](https://travis-ci.org/<+AUTHOR+>/<+DIR+>)

<+CURSOR+>


## Usage




## Sample configuration




## Installation

### With [dein.vim](https://github.com/Shougo/neobundle.vim).

```vim
call dein#add('<+AUTHOR+>/<+DIR+>', {
      \ 'depends': 'apple/vim-apple',
      \ 'on_cmd': [
      \   'Apple',
      \   'Banana',
      \   'Cake',
      \ ],
      \ 'on_map': [
      \   ['<Plug>(apple-'],
      \   ['n', '<Plug>(banana-']
      \ ],
      \ 'on_func': 'xxxx'
      \})
```

### With [NeoBundle](https://github.com/Shougo/neobundle.vim).

```vim
NeoBundle '<+AUTHOR+>/<+DIR+>'
```

If you want to use ```:NeoBundleLazy```, write following code in your .vimrc.

```vim
NeoBundle '<+AUTHOR+>/<+DIR+>', {
      \ 'depends': 'apple/vim-apple',
      \ 'on_cmd': [
      \   'Apple',
      \   'Banana',
      \   'Cake',
      \ ],
      \ 'on_map': [
      \   ['<Plug>(apple-'],
      \   ['n', '<Plug>(banana-']
      \ ],
      \ 'on_func': 'xxxx'
      \}
```

### With [Vundle](https://github.com/VundleVim/Vundle.vim).

```vim
Plugin '<+AUTHOR+>/<+DIR+>'
```

### With [vim-plug](https://github.com/junegunn/vim-plug).

```vim
Plug '<+AUTHOR+>/<+DIR+>'
```

If you don't want to use plugin manager, put files and directories on
```~/.vim/```, or ```%HOME%/vimfiles/``` on Windows.


## Dependent plugins

### Required




### Optional




## Requirements




## LICENSE

This software is released under the MIT License, see [LICENSE](LICENSE).
