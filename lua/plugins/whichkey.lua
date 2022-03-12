local status_ok, which_key = pcall(require, "which-key")
if not status_ok then
	return
end

local setup = {
	plugins = {
		marks = true, -- shows a list of your marks on ' and `
		registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
		spelling = {
			enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
			suggestions = 20, -- how many suggestions should be shown in the list?
		},
		-- the presets plugin, adds help for a bunch of default keybindings in Neovim
		-- No actual key bindings are created
		presets = {
			operators = false, -- adds help for operators like d, y, ... and registers them for motion / text object completion
			motions = true, -- adds help for motions
			text_objects = true, -- help for text objects triggered after entering an operator
			windows = true, -- default bindings on <c-w>
			nav = true, -- misc bindings to work with windows
			z = true, -- bindings for folds, spelling and others prefixed with z
			g = true, -- bindings for prefixed with g
		},
	},
	-- add operators that will trigger motion and text object completion
	-- to enable all native operators, set the preset / operators plugin above
	-- operators = { gc = "Comments" },
	key_labels = {
		-- override the label used to display some keys. It doesn't effect WK in any other way.
		-- For example:
		-- ["<space>"] = "SPC",
		-- ["<cr>"] = "RET",
		-- ["<tab>"] = "TAB",
	},
	icons = {
		breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
		separator = "", -- symbol used between a key and it's label
		group = "+", -- symbol prepended to a group
	},
	popup_mappings = {
		scroll_down = "<c-d>", -- binding to scroll down inside the popup
		scroll_up = "<c-u>", -- binding to scroll up inside the popup
	},
	window = {
		border = "rounded", -- none, single, double, shadow
		position = "bottom", -- bottom, top
		margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
		padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
		winblend = 0,
	},
	layout = {
		height = { min = 4, max = 25 }, -- min and max height of the columns
		width = { min = 20, max = 50 }, -- min and max width of the columns
		spacing = 3, -- spacing between columns
		align = "left", -- align columns left, center or right
	},
	ignore_missing = true, -- enable this to hide mappings for which you didn't specify a label
	hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " }, -- hide mapping boilerplate
	show_help = true, -- show help message on the command line when the popup is visible
	triggers = "auto", -- automatically setup triggers
	-- triggers = {"<leader>"} -- or specify a list manually
	triggers_blacklist = {
		-- list of mode / prefixes that should never be hooked by WhichKey
		-- this is mostly relevant for key maps that start with a native binding
		-- most people should not need to change this
		i = { "j", "k" },
		v = { "j", "k" },
	},
}

local opts = {
	mode = "n", -- NORMAL mode
	prefix = "<leader>",
	buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
	silent = true, -- use `silent` when creating keymaps
	noremap = true, -- use `noremap` when creating keymaps
	nowait = true, -- use `nowait` when creating keymaps
}

local mappings = {
	["↵"] = "execute commnd",
	A = {
		name = "ASCII",
		A = { ":normal 20i<<CR>", "add 20 less than signs" },
		b = { ":.!toilet -w 200 -f term -F border<CR>", "term" },
		B = { ":.!toilet -w 200 -f bfraktur<CR>", "bfraktur" },
		e = { ":.!toilet -w 200 -f emboss<CR>", "emboss" },
		E = { ":.!toilet -w 200 -f emboss2<CR>", "emboss2" },
		f = { ":.!toilet -w 200 -f bigascii12<CR>", "bigascii12" },
		F = { ":.!toilet -w 200 -f letter<CR>", "letter" },
		m = { ":.!toilet -w 200 -f bigmono12<CR>", "bigmono12" },
		v = { ":!asciidoc-view %<CR><CR>", "asciidoc-view" },
		w = { ":.!toilet -w 200 -f wideterm<CR>", "wideterm" },
	},
	B = {
		name = "+Background",
		a = { ":ls<CR>", "show all open buffers" },
		d = {
			":highlight Normal guibg=#1e2127 guifg=default<CR>:highlight SignColumn guibg=#1e2127<CR>:highlight LineNr guifg=#5B6268<CR>",
			"light",
		},
		l = {
			":highlight Normal guibg=#fefefe guifg=#030303<CR>:highlight SignColumn guibg=#fefefe<CR>:highlight LineNr guifg=#030303<CR>",
			"dark",
		},
	},
	b = {
		"<cmd>lua require('telescope.builtin').buffers(require('telescope.themes').get_dropdown{previewer = false})<cr>",
		"buffers",
	},
	c = { "<cmd>bdelete!<CR>", "close buffer" },
	f = {
		name = "+Telescope",
		g = { "<cmd>Telescope live_grep theme=ivy<cr>", "find cword" },
		w = { "<cmd>Telescope grep_string theme=ivy<cr>", "find text" },
	},
	h = { "<cmd>nohlsearch<CR>", "no highlight" },
	W = { "<cmd>set wrap! linebreak<CR>", "toggle wrap" },
	q = { "<cmd>q!<CR>", "quit" },
	p = {
		name = "Packer",
		c = { "<cmd>PackerCompile<cr>", "compile" },
		i = { "<cmd>PackerInstall<cr>", "install" },
		s = { "<cmd>PackerSync<cr>", "sync" },
		S = { "<cmd>PackerStatus<cr>", "status" },
		u = { "<cmd>PackerUpdate<cr>", "update" },
	},
	P = { "<cmd>lua require('telescope').extensions.projects.projects()<cr>", "projects" },
	s = {
		name = "Search",
		b = { "<cmd>Telescope git_branches<cr>", "checkout branch" },
		c = { "<cmd>Telescope colorscheme<cr>", "colorscheme" },
		h = { "<cmd>Telescope help_tags<cr>", "find Help" },
		M = { "<cmd>Telescope man_pages<cr>", "man Pages" },
		r = { "<cmd>Telescope oldfiles<cr>", "open Recent File" },
		R = { "<cmd>Telescope registers<cr>", "registers" },
		k = { "<cmd>Telescope keymaps<cr>", "keymaps" },
		C = { "<cmd>Telescope commands<cr>", "commands" },
	},
	S = { "<cmd>set spell! spelllang=en_us<CR><CR>", "toggle spell" },
}

local no_leader_mappings = {
	["<c-p>"] = {
		"<cmd>lua require('telescope.builtin').find_files(require('telescope.themes').get_dropdown{previewer = false})<cr>",
		"find files",
	},
}

which_key.setup(setup)
which_key.register(mappings, opts)
which_key.register(no_leader_mappings)
