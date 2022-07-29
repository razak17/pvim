_G.__rvim_global_callbacks = __rvim_global_callbacks or {}

_G.pvim = {
	_store = __rvim_global_callbacks,
	--- work around to place functions in the global scope but namespaced within a table.
	--- TODO: refactor this once nvim allows passing lua functions to mappings
	mappings = {},
}

---Get the full path to `$RVIM_RUNTIME_DIR`
---@return string
function pvim.get_runtime_dir()
	local rvim_runtime_dir = os.getenv("PVIM_RUNTIME_DIR")
	if not rvim_runtime_dir then
		-- when nvim is used directly
		return vim.fn.stdpath("data")
	end
	return rvim_runtime_dir
end

---Get the full path to `$RVIM_CONFIG_DIR`
---@return string
function pvim.get_config_dir()
	local rvim_config_dir = vim.env.PVIM_CONFIG_DIR
	if not rvim_config_dir then
		return "~/.config/pvim"
	end
	return rvim_config_dir
end

---Get the full path to `$RVIM_CACHE_DIR`
---@return string
function pvim.get_cache_dir()
	local rvim_cache_dir = os.getenv("PVIM_CACHE_DIR")
	if not rvim_cache_dir then
		return vim.fn.stdpath("cache")
	end
	return rvim_cache_dir
end
