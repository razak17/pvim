local g = vim.g

vim.g.mapleader = ' '
vim.g.maplocalleader = ','
----------------------------------------------------------------------------------------------------
-- Set Providers
----------------------------------------------------------------------------------------------------
g.python3_host_prog = join_paths(vim.call('stdpath', 'cache'), 'venv', 'neovim', 'bin', 'python3')
for _, v in pairs({ 'python', 'ruby', 'perl' }) do
  g['loaded_' .. v .. '_provider'] = 0
end
----------------------------------------------------------------------------------------------------
-- Settings
----------------------------------------------------------------------------------------------------
require('settings')
----------------------------------------------------------------------------------------------------
-- Plugins
----------------------------------------------------------------------------------------------------
local fn = vim.fn
local data = fn.stdpath('data')
local lazy_path = join_paths(data, 'lazy', 'lazy.nvim')

if not vim.loop.fs_stat(lazy_path) then
  fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    '--single-branch',
    'https://github.com/folke/lazy.nvim.git',
    lazy_path,
  })
end
vim.opt.rtp:prepend(lazy_path)

require('lazy').setup('plugins', {
  defaults = { lazy = true },
  change_detection = { notify = false },
  git = { timeout = 720 },
  dev = {
    path = join_paths(vim.env.HOME, 'personal/workspace/coding/plugins'),
    patterns = { 'razak17' },
  },
  ui = { border = 'single' },
  checker = { enabled = true, concurrency = 30, notify = false, frequency = 3600 },
})
map('n', '<localleader>L', '<cmd>Lazy<CR>', { desc = 'lazygit: toggle ui' })
----------------------------------------------------------------------------------------------------
-- Color Scheme
----------------------------------------------------------------------------------------------------
local status_ok, colorscheme = pcall(vim.cmd, 'colorscheme onedark')
if not status_ok then vim.notify('colorscheme ' .. colorscheme .. ' not found!') end
