if not pvim then return end

local api, fn = vim.api, vim.fn

pvim.augroup('TextYankHighlight', {
  {
    -- don't execute silently in case of errors
    event = { 'TextYankPost' },
    pattern = { '*' },
    command = function()
      require('vim.highlight').on_yank({ timeout = 277, on_visual = false, higroup = 'Visual' })
    end,
  },
})

pvim.augroup('UpdateVim', {
  -- Make windows equal size when vim resizes
  { event = { 'VimResized' }, pattern = { '*' }, command = 'wincmd =' },
})

pvim.augroup('WinBehavior', {
  {
    event = { 'Syntax' },
    pattern = { '*' },
    command = [[if line('$') > 5000 | syntax sync minlines=300 | endif]],
  },
  {
    -- Force write shada on leaving nvim
    event = { 'VimLeave' },
    pattern = { '*' },
    command = [[if has('nvim') | wshada! | else | wviminfo! | endif]],
  },
  {
    event = { 'FocusLost' },
    pattern = { '*' },
    command = function()
      vim.cmd('silent! wall')
    end,
  },
  { event = { 'TermOpen' }, pattern = { '*:zsh' }, command = 'startinsert' },
  -- Automatically jump into the quickfix window on open
  {
    event = { 'QuickFixCmdPost' },
    pattern = { '[^l]*' },
    nested = true,
    command = 'cwindow',
  },
  {
    event = { 'QuickFixCmdPost' },
    pattern = { 'l*' },
    nested = true,
    command = 'lwindow',
  },
  {
    event = { 'BufWinEnter' },
    command = function(args)
      if vim.wo.diff then vim.diagnostic.disable(args.buf) end
    end,
  },
  {
    event = { 'BufWinLeave' },
    command = function(args)
      if vim.wo.diff then vim.diagnostic.enable(args.buf) end
    end,
  },
})

local save_excluded = {
  'neo-tree',
  'neo-tree-popup',
  'lua.luapad',
  'gitcommit',
  'NeogitCommitMessage',
}
local function can_save()
  return pvim.empty(vim.bo.buftype)
    and not pvim.empty(vim.bo.filetype)
    and vim.bo.modifiable
    and not vim.tbl_contains(save_excluded, vim.bo.filetype)
end

pvim.augroup('Utilities', {
  {
    -- @source: https://vim.fandom.com/wiki/Use_gf_to_open_a_file_via_its_URL
    event = { 'BufReadCmd' },
    pattern = { 'file:///*' },
    nested = true,
    command = function(args)
      vim.cmd.bdelete({ bang = true })
      vim.cmd.edit(vim.uri_to_fname(args.file))
    end,
  },
  {
    -- When editing a file, always jump to the last known cursor position.
    -- Don't do it for commit messages, when the position is invalid.
    event = { 'BufReadPost' },
    pattern = { '*' },
    command = function()
      if vim.bo.ft ~= 'gitcommit' and vim.fn.win_gettype() ~= 'popup' then
        local last_place_mark = vim.api.nvim_buf_get_mark(0, '"')
        local line_nr = last_place_mark[1]
        local last_line = vim.api.nvim_buf_line_count(0)

        if line_nr > 0 and line_nr <= last_line then
          vim.api.nvim_win_set_cursor(0, last_place_mark)
        end
      end
    end,
  },
  {
    event = { 'FileType' },
    pattern = { 'gitcommit', 'gitrebase' },
    command = 'set bufhidden=delete',
  },
  {
    event = { 'BufWritePre', 'FileWritePre' },
    pattern = { '*' },
    command = "silent! call mkdir(expand('<afile>:p:h'), 'p')",
  },
  {
    event = { 'BufLeave' },
    pattern = { '*' },
    command = function()
      if can_save() then vim.cmd.update({ mods = { silent = true } }) end
    end,
  },
})
