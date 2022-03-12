syntax on
filetype off
hi CursorLineNr cterm=bold

set foldtext=SimpleFoldText()

function SimpleFoldText()
  let line = getline(v:foldstart)
  let sub = substitute(line, '/\*\|\*/\|{{{\d\=', '', 'g')
  return sub . ' >>>>>>'
endfunction

set foldexpr=ListFolds()

function! ListFolds()
  let thisline = getline(v:lnum)
  if match(thisline, '^- ') >= 0
    return ">1"
  elseif match(thisline, '^  - ') >= 0
    return ">2"
  elseif match(thisline, '^    - ') >= 0
    return ">3"
  elseif match(thisline, '^      - ') >= 0
    return ">4"
  elseif match(thisline, '^        - ') >= 0
    return ">5"
  endif
  return "0"
endfunction

" background
nnoremap <leader>Bl :highlight Normal guibg=#c3eeff guifg=#030303<CR>
nnoremap <leader>Bd :highlight Normal guibg=#282a36 guifg=default<CR>

" shows all open buffers and their status
nmap <leader>ba :ls<CR>

" toggles the paste mode
" nmap <C-p> :set paste!<CR>

" toggles word wrap
nmap <C-w> :set wrap! linebreak<CR>

" toggles spell checking
nmap <C-]> :set spell! spelllang=en_us<CR>

" execute command
nmap <leader><Enter> !!zsh<CR>

" AsciiDoc preview
nmap <leader>Av :!asciidoc-view %<CR><CR>

" adds a line of <
nmap <leader>AA :normal 20i<<CR>

" makes Ascii art font
nmap <leader>Ab :.!toilet -w 200 -f term -F border<CR>
nmap <leader>AB :.!toilet -w 200 -f bfraktur<CR>
nmap <leader>Ae :.!toilet -w 200 -f emboss<CR>
nmap <leader>AE :.!toilet -w 200 -f emboss2<CR>
nmap <leader>Af :.!toilet -w 200 -f bigascii12<CR>
nmap <leader>AF :.!toilet -w 200 -f letter<CR>
nmap <leader>Am :.!toilet -w 200 -f bigmono12<CR>
nmap <leader>Aw :.!toilet -w 200 -f wideterm<CR>

let &t_ti.="\e[1 q"
let &t_SI.="\e[5 q"
let &t_EI.="\e[1 q"
let &t_te.="\e[0 q"
