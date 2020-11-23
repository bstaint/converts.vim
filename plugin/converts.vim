if exists('g:converts_loaded')
  finish
endif

vmap <unique> <Leader>. :<C-U>call converts#prompt()<CR>

let g:converts_loaded = 1
" vim: set ts=2 sts=2 sw=2 expandtab :
