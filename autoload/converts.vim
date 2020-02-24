pyx from converts import conv

  "{{{ extend convert_list function maps
" fun! converts#extend(maps)
"     if type(a:maps) == type({})
"         let s:convert_list = extend(s:convert_list, a:maps)
"     endif
" endfunction "}}}

"{{{ input callback completion
fun! converts#completion(A,L,P)
    return filter(keys(g:converts_callback), 'v:val =~ "^'. a:A .'"')
endf "}}}

"{{{ python callback function
fun! converts#callback(...)
    let text = a:000[-1]
    let escape_text = substitute(text, "'", "\\\\'", 'g')
    if a:0 == 3
        let text = pyxeval(a:1."('".escape_text."','".a:2."')")
    elseif a:0 == 4
        let text = pyxeval(a:1."('".escape_text."','".a:2."',".a:3.")")
    endif
    return text
endf "}}}

"{{{ convert visual select text
fun! converts#convertText()
    " only support visual mode
    if visualmode() !=# 'v' | return | endif
    let key = input("> ", "", "customlist,converts#completion")
    " cut select text x register
    normal! gv"xd
    if key !=# ""
        try
            let @x = call(g:converts_callback[key], [@x])
            if @x ==# '' || @x ==# '0'
                silent! normal! u
                return
            endif
        catch /E716/
            call ingo#msg#ErrorMsg("Not found convert method!")
        endtry
    endif
    " paste x register
    normal! "xP
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
