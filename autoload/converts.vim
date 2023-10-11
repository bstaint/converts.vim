pyx import vim
pyx from converts import conv

"{{{ input callback completion
fun! converts#completion(A,L,P)
    return filter(keys(g:converts_callback), 'v:val =~ "^'. a:A .'"')
endf "}}}

"{{{ python callback function
fun! converts#callback(...)
    let text = a:000[-1]
pyx << EOF

text = vim.eval('text')
argv = int(vim.eval('a:0'))
callback = eval(vim.eval('a:1'))
if argv == 3:
    text = callback(text, vim.eval('a:2'))
elif argv == 4:
    text = callback(text, vim.eval('a:2'), vim.eval('a:3'))
EOF
    let text = pyxeval('text')
    return text
endf "}}}

function! converts#convert(cb)
    if empty(a:cb) == v:true | return | endif
    try
        noau normal! `<v`>y
        let @x = call(g:converts_callback[a:cb], [getreg('@')])
        if empty(@x) != v:true && @x != '0' && @x != v:null
            normal! gv"xP
        endif
    catch /E716/
        lua vim.notify("Not found convert method!")
    endtry
endfunction

"{{{ convert visual select text
fun! converts#prompt()
    " only support visual mode
    if visualmode() !=# 'v' || &modifiable != 1
        return
    endif

    let c = input("Conv> ", "", "customlist,converts#completion")
    call converts#convert(c)
endf "}}}

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

let g:converts_callback = get(g:, 'converts_callback', {})
call extend(g:converts_callback, {
    \ 'fn':  function('s:file_name'),
    \ 'backslash':  function('s:backslash'),
    \ 'abs': function('s:absolute_path'),
    \ 'md5': function('converts#callback', ['conv.parse', 'md5']),
    \ 'urlencode':  function('converts#callback', ['conv.parse', 'url']),
    \ 'urldecode':  function('converts#callback', ['conv.parse', 'url', 'True']),
    \ 'reqencode':  function('converts#callback', ['conv.parse', 'dict']),
    \ 'reqdecode':  function('converts#callback', ['conv.parse', 'dict', 'True']),
    \ 'b64encode':  function('converts#callback', ['conv.parse', 'base64']),
    \ 'b64decode':  function('converts#callback', ['conv.parse', 'base64', 'True']),
\ })
