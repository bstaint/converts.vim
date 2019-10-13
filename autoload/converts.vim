let s:convert_list = {}

  "{{{ extend convert_list function maps
fun! converts#extend(maps)
  if type(a:maps) == type({})
    let s:convert_list = extend(s:convert_list, a:maps)
  endif
endfunction "}}}

"{{{ input callback completion
fun! converts#completion(A,L,P)
  return filter(keys(s:convert_list), 'v:val =~ "^'. a:A .'"')
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
  let key = input(">>> ", "", "customlist,converts#completion")
  " cut select text x register
  exe 'normal! gv"xd'
  if key !=# ""
    try
      let @x = call(s:convert_list[key], [@x])
    catch /E716/
      call ingo#msg#ErrorMsg("Not found convert method!")
    endtry
  endif
  " paste x register
  exe 'normal! "xP'
endf "}}}
