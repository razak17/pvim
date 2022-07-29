local init_path = debug.getinfo(1, "S").source:sub(2)
local base_dir = init_path:match("(.*[/\\])"):sub(1, -2)

if not vim.tbl_contains(vim.opt.rtp:get(), base_dir) then
	vim.opt.rtp:append(base_dir)
end

require("globals")
require("bootstrap")
require("settings")
require("plugins.colorscheme")
require("keymaps")
require("plugins")
require("plugins.telescope")
require("plugins.whichkey")
require("plugins.ajk")
