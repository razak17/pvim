local status_ok, which_key = pcall(require, "which-key")
if not status_ok then
	return
end

local setup = {
	plugins = {
		spelling = { enabled = true },
	},
	icons = {
		breadcrumb = "»",
		separator = "",
		group = "+",
	},
	window = {
		border = "single",
		position = "bottom",
		margin = { 1, 0, 1, 0 },
		padding = { 2, 2, 2, 2 },
		winblend = 0,
	},
	layout = { align = "center" },
	hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " },
	show_help = true,
}

local opts = {
	mode = "n",
	prefix = "<leader>",
	buffer = nil,
	silent = true,
	noremap = true,
	nowait = true,
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
