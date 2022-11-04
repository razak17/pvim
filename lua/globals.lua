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
---@generic T : table
---@param callback fun(T, T, key: string | number): T
---@param list T[]
---@param accum T
---@return T
function pvim.fold(callback, list, accum)
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

---Get the full path to `$pvim_RUNTIME_DIR`
---@return string
function pvim.get_runtime_dir()
  local pvim_runtime_dir = os.getenv('PVIM_RUNTIME_DIR')
  if not pvim_runtime_dir then
    -- when nvim is used directly
    return vim.fn.stdpath('data')
  end
  return pvim_runtime_dir
end

---Get the full path to `$pvim_CONFIG_DIR`
---@return string
function pvim.get_config_dir()
  local pvim_config_dir = vim.env.PVIM_CONFIG_DIR
  if not pvim_config_dir then return vim.call('stdpath', 'config') end
  return pvim_config_dir
end

---Get the full path to `$pvim_CACHE_DIR`
---@return string
function pvim.get_cache_dir()
  local pvim_cache_dir = os.getenv('PVIM_CACHE_DIR')
  if not pvim_cache_dir then return vim.fn.stdpath('cache') end
  return pvim_cache_dir
end

--- Validate the keys passed to pvim.augroup are valid
---@param name string
---@param cmd Autocommand
local function validate_autocmd(name, cmd)
  local keys = { 'event', 'buffer', 'pattern', 'desc', 'command', 'group', 'once', 'nested' }
  local incorrect = pvim.fold(function(accum, _, key)
    if not vim.tbl_contains(keys, key) then table.insert(accum, key) end
    return accum
  end, cmd, {})
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
---@field event  string[] | string list of autocommand events
---@field pattern string[] list of autocommand patterns
---@field command string | fun(args: AutocmdArgs): boolean?
---@field nested  boolean
---@field once    boolean
---@field buffer  number

---Create an autocommand
---returns the group ID so that it can be cleared or manipulated.
---@param name string
---@param commands Autocommand[]
---@return number
function pvim.augroup(name, commands)
  assert(name ~= 'User', 'The name of an augroup CANNOT be User')
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

----------------------------------------------------------------------------------------------------
-- Mappings
----------------------------------------------------------------------------------------------------

---create a mapping function factory
---@param mode string
---@param o table
---@return fun(lhs: string, rhs: string|function, opts: table|nil) 'create a mapping'
local function make_mapper(mode, o)
  -- copy the opts table pvim extends will mutate the opts table passed in otherwise
  local parent_opts = vim.deepcopy(o)
  ---Create a mapping
  ---@param lhs string
  ---@param rhs string|function
  ---@param opts table
  return function(lhs, rhs, opts)
    -- check if plugin is installed if plugin option is passed in opts
    if type(opts) == 'table' and opts.plugin then
      if not pvim.plugin_installed(opts.plugin) then return end
      -- remove plugin option from opts to enable vim.keymap.set to use it
      opts = vim.tbl_filter(function(_, key) return key == 'plugin' end, opts)
    end
    -- If the label is all that was passed in, set the opts automagically
    opts = type(opts) == 'string' and { desc = opts } or opts and vim.deepcopy(opts) or {}
    vim.keymap.set(mode, lhs, rhs, vim.tbl_extend('keep', opts, parent_opts))
  end
end

local map_opts = { remap = true, silent = true }
local noremap_opts = { silent = true }

-- A recursive commandline mapping
pvim.nmap = make_mapper('n', map_opts)
-- A recursive select mapping
pvim.xmap = make_mapper('x', map_opts)
-- A recursive terminal mapping
pvim.imap = make_mapper('i', map_opts)
-- A recursive operator mapping
pvim.vmap = make_mapper('v', map_opts)
-- A recursive insert mapping
pvim.omap = make_mapper('o', map_opts)
-- A recursive visual & select mapping
pvim.tmap = make_mapper('t', map_opts)
-- A recursive visual mapping
pvim.smap = make_mapper('s', map_opts) -- A recursive normal mapping
pvim.cmap = make_mapper('c', { remap = false, silent = false })
-- A non recursive normal mapping
pvim.nnoremap = make_mapper('n', noremap_opts)
-- A non recursive visual mapping
pvim.xnoremap = make_mapper('x', noremap_opts)
-- A non recursive visual & select mapping
pvim.vnoremap = make_mapper('v', noremap_opts)
-- A non recursive insert mapping
pvim.inoremap = make_mapper('i', noremap_opts)
-- A non recursive operator mapping
pvim.onoremap = make_mapper('o', noremap_opts)
-- A non recursive terminal mapping
pvim.tnoremap = make_mapper('t', noremap_opts)
-- A non recursive select mapping
pvim.snoremap = make_mapper('s', noremap_opts)
-- A non recursive commandline mapping
pvim.cnoremap = make_mapper('c', { silent = false })
