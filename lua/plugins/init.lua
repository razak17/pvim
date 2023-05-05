local fn = vim.fn

return {
  'nvim-lua/popup.nvim',
  'nvim-lua/plenary.nvim',
  'MunifTanjim/nui.nvim',
  'kyazdani42/nvim-web-devicons',

  { 'razak17/onedark.nvim', lazy = false, priority = 1000 },
  { 'razak17/slides.nvim', lazy = false },
  {
    'romainl/vim-cool',
    event = { 'BufRead', 'BufNewFile' },
    config = function() vim.g.CoolTotalMatches = 1 end,
  },
  {
    'akinsho/toggleterm.nvim',
    event = 'VeryLazy',
    opts = {
      open_mapping = [[<c-\>]],
      shade_filetypes = { 'none' },
      direction = 'float',
      autochdir = true,
      persist_mode = true,
      insert_mappings = false,
      start_in_insert = true,
      highlights = {
        FloatBorder = { link = 'FloatBorder' },
        NormalFloat = { link = 'NormalFloat' },
      },
      float_opts = {
        winblend = 3,
        border = { '🭽', '▔', '🭾', '▕', '🭿', '▁', '🭼', '▏' },
      },
      size = function(term)
        if term.direction == 'horizontal' then return 15 end
        if term.direction == 'vertical' then return math.floor(vim.o.columns * 0.4) end
      end,
    },
    config = function(_, opts)
      require('toggleterm').setup(opts)

      local float_handler = function(term)
        vim.wo.sidescrolloff = 0
        if not pvim.falsy(fn.mapcheck('jk', 't')) then
          vim.keymap.del('t', 'jk', { buffer = term.bufnr })
          vim.keymap.del('t', '<esc>', { buffer = term.bufnr })
        end
      end

      local Terminal = require('toggleterm.terminal').Terminal

      local lazygit = Terminal:new({
        cmd = 'lazygit',
        dir = 'git_dir',
        hidden = true,
        direction = 'float',
        on_open = float_handler,
      })

      map('n', '<leader>lg', function() lazygit:toggle() end, {
        desc = 'toggleterm: toggle lazygit',
      })
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
    keys = {
      {
        '<leader>c',
        function() require('close_buffers').delete({ type = 'this' }) end,
        desc = 'close buffer',
      },
      {
        '<leader>bc',
        function() require('close_buffers').wipe({ type = 'other' }) end,
        desc = 'close others',
      },
      {
        '<leader>bx',
        function() require('close_buffers').wipe({ type = 'all', force = true }) end,
        desc = 'close all',
      },
    },
  },
  {
    'echasnovski/mini.pairs',
    event = 'VeryLazy',
    config = function() require('mini.pairs').setup() end,
  },
}
