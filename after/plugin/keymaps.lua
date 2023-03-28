local nnoremap = function(...) map('n', ...) end
local xnoremap = function(...) map('x', ...) end
local vnoremap = function(...) map('v', ...) end
local inoremap = function(...) map('i', ...) end

----------------------------------------------------------------------------------------------------
-- Window Movement
----------------------------------------------------------------------------------------------------
nnoremap('<C-h>', '<C-w>h')
nnoremap('<C-j>', '<C-w>j')
nnoremap('<C-k>', '<C-w>k')
nnoremap('<C-l>', '<C-w>l')
----------------------------------------------------------------------------------------------------
-- Press jk fast to enter
inoremap('jk', '<ESC>')
----------------------------------------------------------------------------------------------------
-- Indent
----------------------------------------------------------------------------------------------------
vnoremap('<', '<gv')
vnoremap('>', '>gv')
----------------------------------------------------------------------------------------------------
-- Move selected line / block of text in visual mode
----------------------------------------------------------------------------------------------------
xnoremap('K', ":m '<-2<CR>gv=gv")
xnoremap('J', ":m '>+1<CR>gv=gv")
----------------------------------------------------------------------------------------------------
-- Undo
----------------------------------------------------------------------------------------------------
nnoremap('<C-z>', ':undo<CR>')
vnoremap('<C-z>', ':undo<CR><Esc>')
xnoremap('<C-z>', ':undo<CR><Esc>')
inoremap('<c-z>', [[<Esc>:undo<CR>]])
----------------------------------------------------------------------------------------------------
-- Arrows
----------------------------------------------------------------------------------------------------
nnoremap('<down>', '<nop>')
nnoremap('<up>', '<nop>')
nnoremap('<left>', '<nop>')
nnoremap('<right>', '<nop>')
inoremap('<up>', '<nop>')
inoremap('<down>', '<nop>')
inoremap('<left>', '<nop>')
inoremap('<right>', '<nop>')
----------------------------------------------------------------------------------------------------
-- Save
----------------------------------------------------------------------------------------------------
nnoremap('<C-s>', ':silent! write<CR>')

nnoremap('<CR>', 'o<Esc>')
nnoremap('<S-Enter>', 'O<Esc>')
-- Navigate buffers
nnoremap('H', '<cmd>bprevious<CR>', { desc = 'previous buffer' })
nnoremap('L', '<cmd>bnext<CR>', { desc = 'next buffer' })

vim.cmd([[
cnoreabbrev W! w!
cnoreabbrev Q! q!
cnoreabbrev Wq wq
cnoreabbrev wQ wq
cnoreabbrev WQ wq
cnoreabbrev W w
cnoreabbrev Q q
]])
