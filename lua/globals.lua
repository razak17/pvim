if not pvim then return end

local api = vim.api
local fmt = string.format

---Require a module using [pcall] and report any errors
---@param module string
---@param opts table?
---@return boolean, any
function pvim.safe_require(module, opts)
  opts = opts or { silent = false }
  local ok, result = pcall(require, module)
  if not ok and not opts.silent then
    if opts.message then result = opts.message .. '\n' .. result end
    vim.notify(result, vim.log.levels.ERROR, { title = fmt('Error requiring: %s', module) })
  end
  return ok, result
end

--- Convert a list or map of items into a value by iterating all it's fields and transforming
--- them with a callback
---@generic T, S
---@param callback fun(acc: S, item: T, key: string | number): S
---@param list T[]
---@param accum S?
---@return S
function pvim.fold(callback, list, accum)
  accum = accum or {}
  for k, v in pairs(list) do
    accum = callback(accum, v, k)
    assert(accum ~= nil, 'The accumulator must be returned on each iteration')
  end
  return accum
end

---Determine if a value of any type is empty
---@param item any
---@return boolean?
function pvim.empty(item)
  if not item then return true end
  local item_type = type(item)
  if item_type == 'string' then return item == '' end
  if item_type == 'number' then return item <= 0 end
  if item_type == 'table' then return vim.tbl_isempty(item) end
  return item ~= nil
end

function join_paths(...)
  local uv = vim.loop
  local path_sep = uv.os_uname().version:match('Windows') and '\\' or '/'
  local result = table.concat({ ... }, path_sep)
  return result
end

---Determine if a value of any type is empty
---@param item any
---@return boolean?
function pvim.falsy(item)
  if not item then return true end
  local item_type = type(item)
  if item_type == 'boolean' then return not item end
  if item_type == 'string' then return item == '' end
  if item_type == 'number' then return item <= 0 end
  if item_type == 'table' then return vim.tbl_isempty(item) end
  return item ~= nil
end

----------------------------------------------------------------------------------------------------
-- API Wrappers
----------------------------------------------------------------------------------------------------
-- Thin wrappers over API functions to make their usage easier/terser

P = vim.pretty_print

--- Validate the keys passed to rvim.augroup are valid
---@param name string
---@param _cmd Autocommand
local function validate_autocmd(name, _cmd)
  local keys = { 'event', 'buffer', 'pattern', 'desc', 'command', 'group', 'once', 'nested' }
  local incorrect = pvim.fold(function(accum, _, key)
    if not vim.tbl_contains(keys, key) then table.insert(accum, key) end
    return accum
  end, _cmd, {})
  if #incorrect == 0 then return end
  vim.schedule(
    function()
      vim.notify('Incorrect keys: ' .. table.concat(incorrect, ', '), 'error', {
        title = fmt('Autocmd: %s', name),
      })
    end
  )
end

---@class AutocmdArgs
---@field id number
---@field event string
---@field group string?
---@field buf number
---@field file string
---@field match string | number
---@field data any

---@class Autocommand
---@field desc string
---@field event  string | string[] list of autocommand events
---@field pattern string | string[] list of autocommand patterns
---@field command string | fun(args: AutocmdArgs): boolean?
---@field nested  boolean
---@field once    boolean
---@field buffer  number

---Create an autocommand
---returns the group ID so that it can be cleared or manipulated.
---@param name string The name of the autocommand group
---@param ... Autocommand A list of autocommands to create
---@return number
function pvim.augroup(name, ...)
  local commands = { ... }
  assert(name ~= 'User', 'The name of an augroup CANNOT be User')
  assert(#commands > 0, fmt('You must specify at least one autocommand for %s', name))
  local id = api.nvim_create_augroup(name, { clear = true })
  for _, autocmd in ipairs(commands) do
    validate_autocmd(name, autocmd)
    local is_callback = type(autocmd.command) == 'function'
    api.nvim_create_autocmd(autocmd.event, {
      group = name,
      pattern = autocmd.pattern,
      desc = autocmd.desc,
      callback = is_callback and autocmd.command or nil,
      command = not is_callback and autocmd.command or nil,
      once = autocmd.once,
      nested = autocmd.nested,
      buffer = autocmd.buffer,
    })
  end
  return id
end
