set autoread
set autowrite
set nonumber
set norelativenumber
set foldlevelstart=20
set foldmethod=expr
set foldexpr=utils#list_folds()
set foldtext=utils#simple_fold_text()
set hidden

" title required for i3 status checking, modified indicator at end
"set titlestring=%t%(\ \(%F\)%)%a\ -\ VIM%(\ %M%)
set titlestring=%(%F%)%a\ -\ VIM%(\ %M%)
set t_Co=16
" undo cursorlinenr underline (was introduced Aug '19)
hi CursorLineNr cterm=bold
hi SignColumn guifg=#ffff00

syntax on
filetype off

nmap <S-Enter> O<Esc>
nmap <CR> o<Esc>
inoremap <Up> <NOP>
inoremap <Down> <NOP>
inoremap <Left> <NOP>
inoremap <Right> <NOP>
noremap <Up> <NOP>
noremap <Down> <NOP>

" presentation mode
noremap <Left> :silent bp<CR> :redraw!<CR>
noremap <Right> :silent bn<CR> :redraw!<CR>
nmap <F5> :set relativenumber! number! nocursorline ruler!<CR>
nmap <F2> :call utils#display_presentation_boundaries()<CR>
nmap <F3> :call utils#find_execute_command()<CR>

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
