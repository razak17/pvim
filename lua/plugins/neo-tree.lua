return {
  'razak17/neo-tree.nvim',
  cmd = { 'Neotree' },
  branch = 'v2.x',
  keys = {
    { '<c-n>', '<cmd>Neotree toggle reveal<CR>', desc = 'toggle tree' },
  },
  config = function()
    vim.g.neo_tree_remove_legacy_commands = 1

    require('neo-tree').setup({
      enable_git_status = true,
      git_status_async = true,
      filesystem = {
        hijack_netrw_behavior = 'open_current',
        use_libuv_file_watcher = true,
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
          hide_gitignored = true,
          never_show = {
            '.DS_Store',
          },
        },
      },
      default_component_configs = {},
      window = {
        position = 'right',
        width = 30,
        mappings = {
          o = 'toggle_node',
          l = 'open',
          ['<CR>'] = 'open_with_window_picker',
          ['<c-s>'] = 'split_with_window_picker',
          ['<c-v>'] = 'vsplit_with_window_picker',
        },
      },
    })
  end,
}
