local g = vim.g
g['loaded_python_provider'] = 0
g['loaded_ruby_provider'] = 0
g['loaded_perl_provider'] = 0
g['python3_host_prog'] = 0
g['node_host_prog'] = 0

----------------------------------------------------------------------------------------------------
-- Append RTP
----------------------------------------------------------------------------------------------------
vim.opt.rtp:remove(join_paths(vim.call('stdpath', 'data'), 'site'))
vim.opt.rtp:remove(join_paths(vim.call('stdpath', 'data'), 'site', 'after'))
vim.opt.rtp:prepend(join_paths(pvim.get_runtime_dir(), 'site', 'after'))
vim.opt.rtp:append(join_paths(pvim.get_runtime_dir(), 'site', 'lazy'))

vim.opt.rtp:remove(vim.call('stdpath', 'config'))
vim.opt.rtp:remove(join_paths(vim.call('stdpath', 'config'), 'after'))
vim.opt.rtp:prepend(pvim.get_config_dir())
vim.opt.rtp:append(join_paths(pvim.get_config_dir(), 'after'))

vim.cmd([[let &packpath = &runtimepath]])
