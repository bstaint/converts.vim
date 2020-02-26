if exists('g:converts_loaded')
  finish
endif

vnoremap <silent> <Plug>ConvertText :<C-U>call converts#convertText()<CR>

if !hasmapto('<Plug>ConvertText', 'v')
  vmap <unique> <Leader>. <Plug>ConvertText
endif

let g:converts_loaded = 1
" vim: set ts=2 sts=2 sw=2 expandtab :
