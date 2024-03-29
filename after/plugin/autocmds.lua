if not pvim then return end

local fn, api = vim.fn, vim.api

pvim.augroup('SmartClose', {
  -- Auto open grep quickfix window
  event = { 'QuickFixCmdPost' },
  pattern = { '*grep*' },
  command = 'cwindow',
})

pvim.augroup('CheckOutsideTime', {
  -- automatically check for changed files outside vim
  event = { 'WinEnter', 'BufWinEnter', 'BufWinLeave', 'BufRead', 'BufEnter', 'FocusGained' },
  command = 'silent! checktime',
})

pvim.augroup('TrimWhitespace', {
  event = { 'BufWritePre' },
  command = function()
    api.nvim_exec(
      [[
        let bsave = winsaveview()
        keeppatterns %s/\s\+$//e
        call winrestview(bsave)
      ]],
      false
    )
  end,
})

--- automatically clear commandline messages after a few seconds delay
--- source: https://unix.stackexchange.com/a/613645
pvim.augroup('ClearCommandLineMessages', {
  event = { 'CursorHold' },
  command = function()
    vim.defer_fn(function()
      if fn.mode() == 'n' then vim.cmd.echon("''") end
    end, 1000)
  end,
})

pvim.augroup('TextYankHighlight', {
  event = { 'TextYankPost' },
  command = function() vim.highlight.on_yank({ timeout = 177, higroup = 'Search' }) end,
})

pvim.augroup('UpdateVim', {
  event = { 'FocusLost', 'InsertLeave' },
  command = 'silent! wall',
}, {
  event = { 'VimResized' },
  command = 'wincmd =', -- Make windows equal size when vim resizes
})

pvim.augroup('WinBehavior', {
  event = { 'BufWinEnter' },
  command = function(args)
    if vim.wo.diff then vim.diagnostic.disable(args.buf) end
  end,
}, {
  event = { 'BufWinLeave' },
  command = function(args)
    if vim.wo.diff then vim.diagnostic.enable(args.buf) end
  end,
})

local cursorline_exclusions = { 'alpha', 'TelescopePrompt', 'CommandTPrompt', 'DressingInput' }
---@param buf number
---@return boolean
local function should_show_cursorline(buf)
  return vim.bo[buf].buftype ~= 'terminal'
    and not vim.wo.previewwindow
    -- and vim.wo.winhighlight == ''
    and vim.bo[buf].filetype ~= ''
    and not vim.tbl_contains(cursorline_exclusions, vim.bo[buf].filetype)
end

pvim.augroup('Cursorline', {
  event = { 'BufEnter', 'InsertLeave' },
  command = function(args) vim.wo.cursorline = should_show_cursorline(args.buf) end,
}, {
  event = { 'BufLeave', 'InsertEnter' },
  command = function() vim.wo.cursorline = false end,
})

local save_excluded = {
  'neo-tree',
  'neo-tree-popup',
  'lua.luapad',
  'gitcommit',
  'NeogitCommitMessage',
}
local function can_save()
  return pvim.falsy(vim.bo.buftype)
    and not pvim.falsy(vim.bo.filetype)
    and vim.bo.modifiable
    and not vim.tbl_contains(save_excluded, vim.bo.filetype)
end

pvim.augroup('Utilities', {
  -- @source: https://vim.fandom.com/wiki/Use_gf_to_open_a_file_via_its_URL
  event = { 'BufReadCmd' },
  pattern = { 'file:///*' },
  nested = true,
  command = function(args)
    vim.cmd.bdelete({ bang = true })
    vim.cmd.edit(vim.uri_to_fname(args.file))
  end,
}, {
  event = { 'FileType' },
  pattern = { 'gitcommit', 'gitrebase' },
  command = 'set bufhidden=delete',
}, {
  event = { 'BufWritePre', 'FileWritePre' },
  command = "silent! call mkdir(expand('<afile>:p:h'), 'p')",
}, {
  event = { 'BufLeave' },
  command = function()
    if can_save() then vim.cmd.update({ mods = { silent = true } }) end
  end,
}, {
  event = { 'BufWritePost' },
  pattern = { '*' },
  nested = true,
  command = function()
    if pvim.falsy(vim.bo.filetype) or fn.exists('b:ftdetect') == 1 then
      vim.cmd([[
        unlet! b:ftdetect
        filetype detect
        echom 'Filetype set to ' . &ft
      ]])
    end
  end,
}, {
  event = 'FileType',
  command = function()
    vim.opt_local.formatoptions:remove('c')
    vim.opt_local.formatoptions:remove('r')
    vim.opt_local.formatoptions:remove('o')
  end,
}, {
  event = { 'BufRead', 'BufNewFile' },
  pattern = { '*.sld' },
  command = function()
    map('n', '<localleader>aa', '<Cmd>SlideAscii term<CR>', { desc = 'slides: ascii term', buffer = 0 })
    map('n', '<localleader>aA', '<Cmd>SlideAscii bigascii12<CR>', { desc = 'slides: ascii bigascii12', buffer = 0 })
    map('n', '<localleader>ab', '<Cmd>SlideAscii bfraktur<CR>', { desc = 'slides: ascii bfraktur', buffer = 0 })
    map('n', '<localleader>ae', '<Cmd>SlideAscii emboss<CR>', { desc = 'slides: ascii emboss', buffer = 0 })
    map('n', '<localleader>aE', '<Cmd>SlideAscii emboss2<CR>', { desc = 'slides: ascii emboss2', buffer = 0 })
    map('n', '<localleader>al', '<Cmd>SlideAscii letter<CR>', { desc = 'slides: ascii letter', buffer = 0 })
    map('n', '<localleader>am', '<Cmd>SlideAscii bigmono12<CR>', { desc = 'slides: ascii bigmono12', buffer = 0 })
    map('n', '<localleader>aw', '<Cmd>SlideAscii wideterm<CR>', { desc = 'slides: ascii wideterm', buffer = 0 })
  end,
})
