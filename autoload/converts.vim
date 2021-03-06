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
        let @x = call(g:converts_callback[a:cb], [ingo#selection#Get()])
        if empty(@x) != v:true && @x != '0'
            normal! gv"xP
        endif
    catch /E716/
        call ingo#msg#WarningMsg("Not found convert method!")
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
