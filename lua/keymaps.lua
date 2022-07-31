local opts = { noremap = true, silent = true }

-- Shorten function name
local keymap = vim.api.nvim_set_keymap

--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Normal --
-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)

-- Insert --
-- Press jk fast to enter
keymap("i", "jk", "<ESC>", opts)

-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Visual Block --
-- Move text up and down
keymap("x", "J", ":move '>+1<CR>gv-gv", opts)
keymap("x", "K", ":move '<-2<CR>gv-gv", opts)
keymap("x", "<A-j>", ":move '>+1<CR>gv-gv", opts)
keymap("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)

-- Undo
keymap("n", "<C-z>", ":undo<CR>", opts)
keymap("x", "<C-z>", ":undo<CR><Esc>", opts)

-- Disable arrows in normal mode
keymap("n", "<Up>", "<NOP>", opts)
keymap("i", "<Up>", "<NOP>", opts)
keymap("n", "<Down>", "<NOP>", opts)
keymap("i", "<Down>", "<NOP>", opts)
keymap("i", "<Left>", "<NOP>", opts)
keymap("i", "<Right>", "<NOP>", opts)

keymap("n", "<C-s>", ":w!<CR>", { noremap = false })
keymap("n", "<C-q>", ":q<CR>", { noremap = false })
keymap("n", "<CR>", "o<Esc>", opts)
keymap("n", "<S-Enter>", "O<Esc>", opts)

keymap("n", "<Left>", ":silent bp<CR> :redraw!<CR>", { noremap = true })
keymap("n", "<Right>", ":silent bn<CR> :redraw!<CR>", { noremap = true })

keymap("n", "<F5>", ":set relativenumber! number! nocursorline ruler!<CR>", { noremap = false })

vim.cmd([[
cnoreabbrev W! w!
cnoreabbrev Q! q!
cnoreabbrev Wq wq
cnoreabbrev wQ wq
cnoreabbrev WQ wq
cnoreabbrev W w
cnoreabbrev Q q
]])
