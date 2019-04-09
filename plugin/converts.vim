if exists('g:converts_loaded')
  finish
endif
let g:converts_loaded = 1

pyx from converts import conv

fun! s:file_name(file) abort
  return fnamemodify(a:file, ':t')
endf

fun! s:absolute_path(file) abort
  return fnamemodify(a:file, ':p')
endf

fun! s:backslash(text) abort
  if match(a:text, '/') >= 0
    return substitute(a:text, '/', '\', 'g')
  else
    return substitute(a:text, '\', '/', 'g')
  endif
endf

"{{{ keymap
if !hasmapto('<Leader>.','v')
  vnoremap <silent> <Leader>. :call converts#convertText()<CR>
endif
" }}}

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

" vim: set ts=2 sts=2 sw=2 expandtab :
