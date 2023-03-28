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
_G.map = vim.keymap.set
----------------------------------------------------------------------------------------------------
-- Load Modules
----------------------------------------------------------------------------------------------------
require('globals')
require('bootstrap')
