local fn = vim.fn
local fmt = string.format
local use_local = require('utils').use_local

---Require a plugin config
---@param name string
---@return any
local function conf(name) return require(fmt('plugins.%s', name)) end

-- Automatically install packer
local install_path = pvim.get_runtime_dir() .. '/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system({
    'git',
    'clone',
    '--depth',
    '1',
    'https://github.com/wbthomason/packer.nvim',
    install_path,
  })
  print('Installing packer close and reopen Neovim...')
  vim.cmd([[packadd packer.nvim]])
end

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, 'packer')
if not status_ok then return end

local packer_compiled = join_paths(pvim.get_runtime_dir(), 'site', 'lua', '_compiled_nightly.lua')

-- Have packer use a popup window
packer.init({
  compile_path = packer_compiled,
  display = {
    open_fn = function()
      return require('packer.util').float({
        border = { '🭽', '▔', '🭾', '▕', '🭿', '▁', '🭼', '▏' },
      })
    end,
  },
})

-- Install your plugins here
return packer.startup(function(use)
  -- My plugins here
  use('wbthomason/packer.nvim')
  use('nvim-lua/popup.nvim')
  use({ 'nvim-telescope/telescope.nvim', config = conf('telescope') })
  use('nvim-lua/plenary.nvim')
  use({ 'folke/which-key.nvim', config = conf('whichkey') })
  use_local({ 'razak17/zephyr-nvim', local_path = 'personal' })
  use({ 'nvim-neo-tree/neo-tree.nvim', branch = 'v2.x', config = conf('neo-tree') })
  use('MunifTanjim/nui.nvim')
  use({
    'romainl/vim-cool',
    config = function() vim.g.CoolTotalMatches = 1 end,
  })
  use({
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    module = 'cmp',
    config = conf('cmp'),
    requires = {
      { 'saadparwaiz1/cmp_luasnip', after = 'nvim-cmp' },
      { 'hrsh7th/cmp-buffer', after = 'nvim-cmp' },
      { 'f3fora/cmp-spell', after = 'nvim-cmp' },
      { 'hrsh7th/cmp-emoji', after = 'nvim-cmp' },
      {
        'petertriho/cmp-git',
        after = 'nvim-cmp',
        config = function()
          require('cmp_git').setup({
            filetypes = { 'gitcommit', 'NeogitCommitMessage' },
          })
        end,
      },
      {
        'uga-rosa/cmp-dictionary',
        after = 'nvim-cmp',
        config = function()
          -- Refer to install script
          local dicwords = join_paths(pvim.get_runtime_dir(), 'site', 'spell', 'dictionary.txt')
          if vim.fn.filereadable(dicwords) ~= 1 then dicwords = '/usr/share/dict/words' end
          require('cmp_dictionary').setup({
            async = true,
            dic = {
              ['*'] = dicwords,
            },
          })
          require('cmp_dictionary').update()
        end,
      },
    },
  })

  use('kyazdani42/nvim-web-devicons')
  use({
    'L3MON4D3/LuaSnip',
    event = 'InsertEnter',
    module = 'luasnip',
    requires = 'rafamadriz/friendly-snippets',
    config = conf('luasnip'),
  })
  use({
    'numToStr/FTerm.nvim',
    event = { 'BufWinEnter' },
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
  })
  use({ 'moll/vim-bbye', event = 'BufWinEnter' })
  use({
    'xiyaowong/accelerated-jk.nvim',
    event = { 'BufWinEnter' },
    config = function()
      require('accelerated-jk').setup({
        mappings = { j = 'gj', k = 'gk' },
        -- If the interval of key-repeat takes more than `acceleration_limit` ms, the step is reset
        -- acceleration_limit = 150,
      })
    end,
  })
  use({
    'uga-rosa/ccc.nvim',
    config = function()
      require('ccc').setup({
        highlighter = {
          auto_enable = true,
          excludes = { 'dart' },
        },
      })
    end,
  })
  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then require('packer').sync() end

  if not vim.g.packer_compiled_loaded and vim.loop.fs_stat(packer_compiled) then
    vim.cmd.source(packer_compiled)
    vim.g.packer_compiled_loaded = true
  end

  if vim.fn.filereadable(packer_compiled) ~= 1 then require('packer').compile() end
end)
