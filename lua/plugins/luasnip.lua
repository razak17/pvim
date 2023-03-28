return function() local ls = require('luasnip') local types = require('luasnip.util.types')
  local extras = require('luasnip.extras')
  local fmt = require('luasnip.extras.fmt').fmt

  --- Checks whether a given path exists and is a directory
  --@param path (string) path to check
  --@returns (bool)
  local function is_directory(path)
    local stat = vim.loop.fs_stat(path)
    return stat and stat.type == 'directory' or false
  end

  ls.config.set_config({
    history = false,
    region_check_events = 'CursorMoved,CursorHold,InsertEnter',
    delete_check_events = 'InsertLeave',
    ext_opts = {
      [types.choiceNode] = {
        active = {
          hl_mode = 'combine',
          virt_text = { { '●', 'Operator' } },
        },
      },
      [types.insertNode] = {
        active = {
          hl_mode = 'combine',
          virt_text = { { '●', 'Type' } },
        },
      },
    },
    enable_autosnippets = true,
    snip_env = {
      fmt = fmt,
      m = extras.match,
      t = ls.text_node,
      f = ls.function_node,
      c = ls.choice_node,
      d = ls.dynamic_node,
      i = ls.insert_node,
      l = extras.lamda,
      snippet = ls.snippet,
    },
  })

  -- <c-l> is selecting within a list of options.
  vim.keymap.set({ 's', 'i' }, '<c-l>', function()
    if ls.choice_active() then ls.change_choice(1) end
  end)

  vim.keymap.set({ 's', 'i' }, '<c-l>', function()
    if ls.expand_or_jumpable() then ls.expand_or_jump() end
  end)

  vim.keymap.set({ 's', 'i' }, '<c-b>', function()
    if ls.jumpable(-1) then ls.jump(-1) end
  end)

  require('luasnip').config.setup({ store_selection_keys = '<C-x>' })

  local paths = {
    join_paths(vim.call('stdpath', 'data'), 'site', 'lazy', 'friendly-snippets'),
  }
  local user_snippets = join_paths(vim.call('stdpath', 'config'), 'snippets', 'textmate')
  if is_directory(user_snippets) then paths[#paths + 1] = user_snippets end
  require('luasnip.loaders.from_lua').lazy_load()
  require('luasnip.loaders.from_vscode').lazy_load({ paths = paths })
end
