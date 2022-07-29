vim.g.neo_tree_remove_legacy_commands = 1

local opts = { noremap = true, silent = true }
local keymap = vim.api.nvim_set_keymap

keymap("n", "<c-n>", "<Cmd>Neotree toggle reveal<CR>", opts)

require("which-key").register({
	["<leader>e"] = { "<Cmd>Neotree toggle reveal<CR>", "toggle tree" },
})

require("neo-tree").setup({
	source_selector = { winbar = true, separator_active = " " },
	enable_git_status = true,
	git_status_async = true,
	filesystem = {
		hijack_netrw_behavior = "open_current",
		use_libuv_file_watcher = true,
		filtered_items = {
			visible = true,
			hide_dotfiles = false,
			hide_gitignored = true,
			never_show = {
				".DS_Store",
			},
		},
	},
	default_component_configs = {},
	window = {
		position = "right",
		width = 30,
		mappings = {
			o = "toggle_node",
			l = "open",
			["<CR>"] = "open_with_window_picker",
			["<c-s>"] = "split_with_window_picker",
			["<c-v>"] = "vsplit_with_window_picker",
		},
	},
})
