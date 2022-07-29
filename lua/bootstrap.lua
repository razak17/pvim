local function join_paths(...)
	local uv = vim.loop
	local path_sep = uv.os_uname().version:match("Windows") and "\\" or "/"
	local result = table.concat({ ... }, path_sep)
	return result
end

if os.getenv("RVIM_RUNTIME_DIR") then
	vim.opt.rtp:remove(join_paths(vim.fn.stdpath("data"), "site"))
	vim.opt.rtp:remove(join_paths(vim.fn.stdpath("data"), "site", "after"))
	vim.opt.rtp:prepend(join_paths(pvim.get_runtime_dir(), "site"))
	vim.opt.rtp:append(join_paths(pvim.get_runtime_dir(), "site", "after"))

	vim.opt.rtp:remove(vim.fn.stdpath("config"))
	vim.opt.rtp:remove(join_paths(vim.fn.stdpath("config"), "after"))
	vim.opt.rtp:prepend(pvim.get_config_dir())
	vim.opt.rtp:append(join_paths(pvim.get_config_dir(), "after"))
end

vim.cmd([[let &packpath = &runtimepath]])

local g = vim.g

g["loaded_python_provider"] = 0
g["loaded_ruby_provider"] = 0
g["loaded_perl_provider"] = 0
g["python3_host_prog"] = 0
g["node_host_prog"] = 0
