local init_path = debug.getinfo(1, 'S').source:sub(2)
local base_dir = init_path:match('(.*[/\\])'):sub(1, -2)

if not vim.tbl_contains(vim.opt.rtp:get(), base_dir) then vim.opt.rtp:append(base_dir) end
----------------------------------------------------------------------------------------------------
-- Global namespace
----------------------------------------------------------------------------------------------------
local namespace = {
  -- for UI elements like the winbar and statusline that need global references
  ui = {},
  -- some vim mappings require a mixture of commandline commands and function calls
  -- this table is place to store lua functions to be called in those mappings
  mappings = {},
}

_G.pvim = pvim or namespace
----------------------------------------------------------------------------------------------------
-- Load Modules
----------------------------------------------------------------------------------------------------
require('globals')
require('bootstrap')
require('settings')
require('keymaps')
require('autocmds')
require('plugins')
require('plugins.colorscheme')
