local fmt = string.format

---Require a plugin config
---@param name string
---@return any
local function conf(name) return require(fmt('plugins.%s', name)) end

local lazy_path = join_paths(pvim.get_runtime_dir(), 'site/lazy/lazy.nvim')
if not vim.loop.fs_stat(lazy_path) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    '--single-branch',
    'https://github.com/folke/lazy.nvim.git',
    lazy_path,
  })
end
vim.opt.rtp:prepend(lazy_path)

local lazy_opts = {
  root = join_paths(pvim.get_runtime_dir(), 'site/lazy'),
  defaults = { lazy = true },
  lockfile = join_paths(pvim.get_config_dir(), 'lazy-lock.json'),
  git = { timeout = 720 },
  dev = {
    path = join_paths(vim.env.HOME, 'personal/workspace/coding/plugins'),
    patterns = { 'razak17' },
  },
  install = { colorscheme = { 'zephyr', 'habamax' } },
  ui = { border = 'single' },
  performance = {
    enabled = true,
    cache = { path = join_paths(pvim.get_cache_dir(), 'lazy/cache') },
    rtp = { reset = false },
  },

  readme = { root = join_paths(pvim.get_cache_dir(), 'lazy/readme') },
}

require('lazy').setup({
  'nvim-lua/popup.nvim',
  'nvim-lua/plenary.nvim',
  'MunifTanjim/nui.nvim',
  'kyazdani42/nvim-web-devicons',
  { 'nvim-telescope/telescope.nvim', lazy = false, config = conf('telescope') },
  { 'folke/which-key.nvim', lazy = false, config = conf('whichkey') },
  { 'razak17/zephyr-nvim' },
  { 'nvim-neo-tree/neo-tree.nvim', lazy = false, branch = 'v2.x', config = conf('neo-tree') },
  {
    'romainl/vim-cool',
    event = { 'BufRead', 'BufNewFile' },
    config = function() vim.g.CoolTotalMatches = 1 end,
  },
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    config = conf('cmp'),
    dependencies = {
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-emoji',
      {
        'petertriho/cmp-git',
        config = function()
          require('cmp_git').setup({
            filetypes = { 'gitcommit', 'NeogitCommitMessage' },
          })
        end,
      },
      {
        'uga-rosa/cmp-dictionary',
        config = function()
          require('cmp_dictionary').setup({
            async = true,
            dic = {
              ['*'] = join_paths(pvim.get_runtime_dir(), 'site', 'spell', 'dictionary.txt'),
            },
          })
        end,
      },
    },
  },
  {
    'L3MON4D3/LuaSnip',
    event = 'InsertEnter',
    dependencies = { 'rafamadriz/friendly-snippets' },
    config = conf('luasnip'),
  },
  {
    'numToStr/FTerm.nvim',
    event = 'VeryLazy',
    config = function()
      local fterm = require('FTerm')
      fterm.setup({ dimensions = { height = 0.9, width = 0.9 } })
      local function new_float(cmd)
        cmd = fterm:new({ cmd = cmd, dimensions = { height = 0.9, width = 0.9 } }):toggle()
      end
      local nnoremap = pvim.nnoremap
      nnoremap([[<c-\>]], function() fterm.toggle() end, 'fterm: toggle lazygit')
      pvim.tnoremap([[<c-\>]], function() fterm.toggle() end, 'fterm: toggle lazygit')
      nnoremap('<leader>lg', function() new_float('lazygit') end, 'fterm: toggle lazygit')
      nnoremap(
        '<leader>gc',
        function() new_float('git add . && git commit -v -a') end,
        'git: commit'
      )
      nnoremap('<leader>gd', function() new_float('iconf -ccma') end, 'git: commit dotfiles')
    end,
  },
  {
    'xiyaowong/accelerated-jk.nvim',
    event = 'VeryLazy',
    config = function()
      require('accelerated-jk').setup({
        mappings = { j = 'gj', k = 'gk' },
      })
    end,
  },
  {
    'uga-rosa/ccc.nvim',
    lazy = false,
    config = function()
      require('ccc').setup({
        highlighter = {
          auto_enable = true,
          excludes = { 'dart' },
        },
      })
    end,
  },
  {
    'karb94/neoscroll.nvim',
    event = 'VeryLazy',
    config = function() require('neoscroll').setup({ hide_cursor = true }) end,
  },
  {
    'kazhala/close-buffers.nvim',
    init = function()
      pvim.nnoremap(
        '<leader>c',
        function() require('close_buffers').delete({ type = 'this' }) end,
        'close buffer'
      )
      pvim.nnoremap(
        '<leader>bc',
        function() require('close_buffers').wipe({ type = 'other' }) end,
        'close others'
      )
      pvim.nnoremap(
        '<leader>bx',
        function() require('close_buffers').wipe({ type = 'all', force = true }) end,
        'close others'
      )
    end,
  },
  {
    'echasnovski/mini.pairs',
    event = 'VeryLazy',
    config = function() require('mini.pairs').setup() end,
  },
}, lazy_opts)
