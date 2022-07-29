local status_ok, telescope = pcall(require, "telescope")
if not status_ok then
	return
end

local previewers = require("telescope.previewers")
local sorters = require("telescope.sorters")
local actions = require("telescope.actions")
local layout_actions = require("telescope.actions.layout")
local themes = require("telescope.themes")

local function get_border(opts)
	return vim.tbl_deep_extend("force", opts or {}, {
		borderchars = {
			{ "─", "│", "─", "│", "┌", "┐", "┘", "└" },
			prompt = { "─", "│", " ", "│", "┌", "┐", "│", "│" },
			results = { "─", "│", "─", "│", "├", "┤", "┘", "└" },
			preview = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
		},
	})
end

---@param opts table
---@return table
local function dropdown(opts)
	return themes.get_dropdown(get_border(opts))
end

local function ivy(opts)
	return require("telescope.themes").get_ivy(vim.tbl_deep_extend("keep", opts or {}, {
		borderchars = {
			preview = { "▔", "▕", "▁", "▏", "🭽", "🭾", "🭿", "🭼" },
		},
	}))
end

telescope.setup({
	defaults = {
		prompt_prefix = " ❯ ",
		selection_caret = " ❯ ",
		cycle_layout_list = { "flex", "horizontal", "vertical", "bottom_pane", "center" },
		sorting_strategy = "ascending",
		layout_strategy = "horizontal",
		set_env = { ["TERM"] = vim.env.TERM },
		borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
		file_browser = { hidden = true },
		color_devicons = true,
		dynamic_preview_title = true,
		layout_config = {
			height = 0.9,
			width = 0.9,
			preview_cutoff = 120,
			horizontal = {
				width_padding = 0.04,
				height_padding = 0.1,
				preview_width = 0.6,
			},
			vertical = {
				width_padding = 0.05,
				height_padding = 0.1,
				preview_height = 0.5,
			},
		},
		winblend = 0,
		file_ignore_patterns = {
			-- '%.jpg',
			-- '%.jpeg',
			-- '%.png',
			"%.otf",
			"%.ttf",
			"%.DS_Store",
			"%.lock",
			".git/",
			"node_modules/",
			"dist/",
			"site-packages/",
		},
		path_display = { "truncate" },
		file_sorter = sorters.get_fzy_sorter,
		file_previewer = previewers.vim_buffer_cat.new,
		grep_previewer = previewers.vim_buffer_vimgrep.new,
		qflist_previewer = previewers.vim_buffer_qflist.new,
		mappings = {
			i = {
				["<C-w>"] = actions.send_selected_to_qflist,
				["<c-c>"] = function()
					vim.cmd.stopinsert({ bang = true })
				end,
				["<esc>"] = actions.close,
				["<C-j>"] = actions.move_selection_next,
				["<C-k>"] = actions.move_selection_previous,
				["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
				["<c-s>"] = actions.select_horizontal,
				["<CR>"] = actions.select_default,
				["<c-e>"] = layout_actions.toggle_preview,
				["<c-l>"] = layout_actions.cycle_layout_next,
				["<Tab>"] = actions.toggle_selection,
			},
			n = {
				["<C-j>"] = actions.move_selection_next,
				["<C-k>"] = actions.move_selection_previous,
				["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
			},
		},
		pickers = {
			buffers = dropdown({
				sort_mru = true,
				sort_lastused = true,
				show_all_buffers = true,
				ignore_current_buffer = true,
				previewer = false,
				theme = "dropdown",
				mappings = {
					i = { ["<c-x>"] = "delete_buffer" },
					n = { ["<c-x>"] = "delete_buffer" },
				},
			}),
			keymaps = dropdown({
				layout_config = {
					height = 18,
					width = 0.5,
				},
			}),
			live_grep = ivy({
				--@usage don't include the filename in the search results
				only_sort_text = true,
				-- NOTE: previewing html seems to cause some stalling/blocking whilst live grepping
				-- so filter out html.
				file_ignore_patterns = {
					".git/",
					"%.html",
					"dotbot/.*",
					"zsh/plugins/.*",
				},
				max_results = 2000,
				on_input_filter_cb = function(prompt)
					-- AND operator for live_grep like how fzf handles spaces with wildcards in rg
					return { prompt = prompt:gsub("%s", ".*") }
				end,
			}),
			oldfiles = dropdown(),
			current_buffer_fuzzy_find = dropdown({
				previewer = false,
				shorten_path = false,
			}),
			colorscheme = {
				enable_preview = true,
			},
			git_branches = dropdown(),
			git_bcommits = {
				layout_config = {
					horizontal = {
						preview_width = 0.55,
					},
				},
			},
			git_commits = {
				layout_config = {
					horizontal = {
						preview_width = 0.55,
					},
				},
			},
			reloader = dropdown(),
		},
	},
})

local builtin = require("telescope.builtin")

local function find_files()
	builtin.find_files(require("telescope.themes").get_dropdown({
		previewer = false,
		hidden = true,
		borderchars = {
			{ "─", "│", "─", "│", "┌", "┐", "┘", "└" },
			prompt = { "─", "│", " ", "│", "┌", "┐", "│", "│" },
			results = { "─", "│", "─", "│", "├", "┤", "┘", "└" },
			preview = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
		},
	}))
end

local function buffers()
	builtin.buffers(require("telescope.themes").get_dropdown({
		previewer = false,
		hidden = true,
		borderchars = {
			{ "─", "│", "─", "│", "┌", "┐", "┘", "└" },
			prompt = { "─", "│", " ", "│", "┌", "┐", "│", "│" },
			results = { "─", "│", "─", "│", "├", "┤", "┘", "└" },
			preview = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
		},
	}))
end

require("which-key").register({
	["<c-p>"] = { find_files, "telescope: find files" },
	b = { buffers, "buffers" },
	["<leader>f"] = {
		name = "+Telescope",
		s = { builtin.live_grep, "find word" },
		w = { builtin.grep_string, "find current word" },
	},
	s = {
		name = "Search",
		o = { builtin.oldfiles, "old files" },
		r = { builtin.registers, "registers" },
		k = { builtin.keymaps, "keymaps" },
		c = { builtin.commands, "commands" },
	},
})
