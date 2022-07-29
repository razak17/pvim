local status_ok, telescope = pcall(require, "telescope")
if not status_ok then
	return
end

local actions = require("telescope.actions")
local layout_actions = require("telescope.actions.layout")

telescope.setup({
	defaults = {
		prompt_prefix = " ",
		selection_caret = " ",
		path_display = { "smart" },
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
	},
})
