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

----------------------------------------------------------------------------------------------------
-- Color Scheme
----------------------------------------------------------------------------------------------------
local status_ok, colorscheme = pcall(vim.cmd, 'colorscheme zephyr')
if not status_ok then
  vim.notify('colorscheme ' .. colorscheme .. ' not found!')
  return
end

----------------------------------------------------------------------------------------------------
-- Highlights
----------------------------------------------------------------------------------------------------
local fmt = string.format

local function hex_to_rgb(color)
  local hex = color:gsub('#', '')
  return tonumber(hex:sub(1, 2), 16), tonumber(hex:sub(3, 4), 16), tonumber(hex:sub(5), 16)
end

local function alter(attribute, percent) return math.floor(attribute * (100 + percent) / 100) end

local function alter_color(color, percent)
  local r, g, b = hex_to_rgb(color)
  if not r or not g or not b then return 'NONE' end
  r, g, b = alter(r, percent), alter(g, percent), alter(b, percent)
  r, g, b = math.min(r, 255), math.min(g, 255), math.min(b, 255)
  return fmt('#%02x%02x%02x', r, g, b)
end

local function get_hl(group_name)
  local ok, hl = pcall(vim.api.nvim_get_hl_by_name, group_name, true)
  if not ok then return {} end
  hl.foreground = hl.foreground and '#' .. bit.tohex(hl.foreground, 6)
  hl.background = hl.background and '#' .. bit.tohex(hl.background, 6)
  return hl
end

local normal_bg = get_hl('Normal', 'background').background
vim.api.nvim_set_hl(0, 'Normal', { bg = alter_color(normal_bg, -50) })
vim.api.nvim_set_hl(0, 'NormalFloat', { bg = alter_color(normal_bg, -50) })
