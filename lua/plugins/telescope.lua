local function builtin() return require('telescope.builtin') end

local function extensions(name) return require('telescope').extensions[name] end

local function live_grep(opts) return extensions('menufacture').live_grep(opts) end
local function find_files(opts) return extensions('menufacture').find_files(opts) end
local function git_files(opts) return extensions('menufacture').git_files(opts) end

local function project_files()
  if not pcall(git_files, { show_untracked = true }) then find_files() end
end

local function delta_opts(opts, is_buf)
  local previewers = require('telescope.previewers')
  local delta = previewers.new_termopen_previewer({
    get_command = function(entry)
      local args = {
        'git',
        '-c',
        'core.pager=delta',
        '-c',
        'delta.side-by-side=false',
        'diff',
        entry.value .. '^!',
      }
      if is_buf then vim.list_extend(args, { '--', entry.current_file }) end
      return args
    end,
  })
  opts = opts or {}
  opts.previewer = {
    delta,
    previewers.git_commit_message.new(opts),
  }
  return opts
end

local function delta_git_commits(opts) builtin().git_commits(delta_opts(opts)) end
local function delta_git_bcommits(opts) builtin().git_bcommits(delta_opts(opts, true)) end

local function b(picker, opts)
  opts = opts or {}
  return function() require('telescope.builtin')[picker](opts) end
end

return {
  'nvim-telescope/telescope.nvim',
  event = 'VimEnter',
  config = function()
    local status_ok, telescope = pcall(require, 'telescope')
    if not status_ok then return end

    local sorters = require('telescope.sorters')
    local previewers = require('telescope.previewers')
    local actions = require('telescope.actions')
    local layout_actions = require('telescope.actions.layout')

    telescope.setup({
      defaults = {
        prompt_prefix = ' ❯ ',
        selection_caret = ' ❯ ',
        cycle_layout_list = { 'flex', 'horizontal', 'vertical', 'bottom_pane', 'center' },
        sorting_strategy = 'ascending',
        layout_strategy = 'horizontal',
        set_env = { ['TERM'] = vim.env.TERM },
        borderchars = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
        file_browser = { hidden = true },
        color_devicons = true,
        dynamic_preview_title = true,
        winblend = 0,
        path_display = { 'truncate' },
        file_sorter = sorters.get_fzy_sorter,
        file_previewer = previewers.vim_buffer_cat.new,
        grep_previewer = previewers.vim_buffer_vimgrep.new,
        qflist_previewer = previewers.vim_buffer_qflist.new,
        mappings = {
          i = {
            ['<C-w>'] = actions.send_selected_to_qflist,
            ['<c-c>'] = function() vim.cmd.stopinsert({ bang = true }) end,
            ['<esc>'] = actions.close,
            ['<C-j>'] = actions.move_selection_next,
            ['<C-k>'] = actions.move_selection_previous,
            ['<C-q>'] = actions.smart_send_to_qflist + actions.open_qflist,
            ['<c-s>'] = actions.select_horizontal,
            ['<CR>'] = actions.select_default,
            ['<c-e>'] = layout_actions.toggle_preview,
            ['<c-l>'] = layout_actions.cycle_layout_next,
            ['<Tab>'] = actions.toggle_selection,
          },
          n = {
            ['<C-j>'] = actions.move_selection_next,
            ['<C-k>'] = actions.move_selection_previous,
            ['<C-q>'] = actions.smart_send_to_qflist + actions.open_qflist,
          },
        },
      },
      pickers = {
        colorscheme = { enable_preview = true },
        git_bcommits = {
          layout_config = {
            horizontal = {
              preview_width = 0.55,
            },
          },
        },
        git_commits = {
          layout_config = {
            horizontal = {
              preview_width = 0.55,
            },
          },
        },
      },
      extensions = {
        undo = {
          mappings = {
            i = {
              ['<C-a>'] = require('telescope-undo.actions').yank_additions,
              ['<C-d>'] = require('telescope-undo.actions').yank_deletions,
              ['<C-u>'] = require('telescope-undo.actions').restore,
            },
          },
        },
        menufacture = {
          mappings = {
            main_menu = { [{ 'i', 'n' }] = '<C-;>' },
          },
        },
      },
    })

    require('telescope').load_extension('zf-native')
    require('telescope').load_extension('menufacture')
    require('telescope').load_extension('undo')
  end,
  keys = {
    { '<c-p>', find_files, desc = 'find files' },
    { '<leader>ff', project_files, desc = 'project files' },
    { '<leader>fs', live_grep, desc = 'find word' },
    { '<leader>fw', b('grep_string'), desc = 'find word' },
    -- Git
    { '<leader>gs', b('git_status'), desc = 'git status' },
    { '<leader>fgb', b('git_branches'), desc = 'git branches' },
    { '<leader>fgB', delta_git_bcommits, desc = 'buffer commits' },
    { '<leader>fgc', delta_git_commits, desc = 'commits' },
  },
  dependencies = {
    'natecraddock/telescope-zf-native.nvim',
    'molecule-man/telescope-menufacture',
    'debugloop/telescope-undo.nvim',
  },
}
