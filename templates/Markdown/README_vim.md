<+DIR+>
<%= repeat('=', len('<+DIR+>')) %>

[![Build Status](https://travis-ci.org/<+AUTHOR+>/<+DIR+>.png)](https://travis-ci.org/<+AUTHOR+>/<+DIR+>)
[![Powered by vital.vim](https://img.shields.io/badge/powered%20by-vital.vim-80273f.svg)](https://github.com/vim-jp/vital.vim)

<+CURSOR+>


## Usage




## Sample configuration




## Installation

### With [dein.vim](https://github.com/Shougo/neobundle.vim)

Write following code to your `.vimrc` and execute `:call dein#install()` in
your Vim.

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

### With [NeoBundle](https://github.com/Shougo/neobundle.vim)

Write following code to your `.vimrc` and execute `:NeoBundleInstall` in your
Vim.

```vim
NeoBundle '<+AUTHOR+>/<+DIR+>'
```

If you want to use `:NeoBundleLazy`, write following code in your .vimrc.

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

### With [Vundle](https://github.com/VundleVim/Vundle.vim)

Write following code to your `.vimrc` and execute `:PluginInstall` in your Vim.

```vim
Plugin '<+AUTHOR+>/<+DIR+>'
```

### With [vim-plug](https://github.com/junegunn/vim-plug)

Write following code to your `.vimrc` and execute `:PlugInstall` in your Vim.

```vim
Plug '<+AUTHOR+>/<+DIR+>'
```

### With [vim-pathogen](https://github.com/tpope/vim-pathogen)

Clone this repository to the package directory of pathogen.

```
$ git clone https://github.com/<+AUTHOR+>/<+DIR+>.git ~/.vim/bundle/<+DIR+>
```

### With packages feature

In the first, clone this repository to the package directory.

```
$ git clone https://github.com/<+AUTHOR+>/<+DIR+>.git ~/.vim/pack/koturn/opt/<+DIR+>
```

Second, add following code to your `.vimrc`.

```vim
packadd <+DIR+>
```

### With manual

If you don't want to use plugin manager, put files and directories on
`~/.vim/`, or `%HOME%/vimfiles/` on Windows.


## Dependent plugins

### Required




### Optional




## Requirements




## LICENSE

This software is released under the MIT License, see [LICENSE](LICENSE).
