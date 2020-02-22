if exists('g:converts_loaded')
  finish
endif

"{{{ keymap
vnoremap <silent> <Plug>ConvertText :call converts#convertText()<CR>

if !hasmapto('<Plug>ConvertText','v')
  vmap <Leader>. <Plug>ConvertText
endif
" }}}

let g:converts_loaded = 1
" vim: set ts=2 sts=2 sw=2 expandtab :