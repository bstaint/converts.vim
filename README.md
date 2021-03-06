converts.vim
=======

通过自定义方法转换选定的内容

Requirements && Install (vim-plug)
----
`:echo has('pythonx')`

vimrc:
```
Plug 'inkarkat/vim-ingo-library'
Plug 'bstaint/converts.vim'
```

Screenshots
----
![GIF](https://raw.githubusercontent.com/bstaint/converts.vim/master/doc/GIF.gif)

Usage
----
 - Select Text.
 - `<Leader>.`
 - Input key.

Callback:
----
```vim
pyx from converts import conv
call converts#extend({
            \ 'fn':  function('s:file_name'),
            \ 'bs':  function('s:backslash'),
            \ 'abs': function('s:absolute_path'),
            \ 'md5': function('converts#callback', ['conv.parse', 'md5']),
            \ 'ue':  function('converts#callback', ['conv.parse', 'url']),
            \ 'ud':  function('converts#callback', ['conv.parse', 'url', 'True']),
            \ 'de':  function('converts#callback', ['conv.parse', 'dict']),
            \ 'dd':  function('converts#callback', ['conv.parse', 'dict', 'True']),
            \ 'be':  function('converts#callback', ['conv.parse', 'base64']),
            \ 'bd':  function('converts#callback', ['conv.parse', 'base64', 'True']),
            \ })
```
