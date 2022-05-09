if exists('g:converts_loaded')
  finish
endif

if !mapcheck('<Leader>.', 'v')
  vmap <unique> <silent> <Leader>. :<C-U>call converts#prompt()<CR>
endif

let g:converts_loaded = 1
" vim: set ts=2 sts=2 sw=2 expandtab :
