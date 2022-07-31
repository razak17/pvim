local fn = vim.fn
local fmt = string.format
local use_local = require("utils").use_local

---Require a plugin config
---@param name string
---@return any
local function conf(name)
	return require(fmt("plugins.%s", name))
end

-- Automatically install packer
local install_path = pvim.get_runtime_dir() .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	PACKER_BOOTSTRAP = fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
	print("Installing packer close and reopen Neovim...")
	vim.cmd([[packadd packer.nvim]])
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
	return
end

-- Have packer use a popup window
packer.init({
	display = {
		open_fn = function()
			return require("packer.util").float({
				border = { "🭽", "▔", "🭾", "▕", "🭿", "▁", "🭼", "▏" },
			})
		end,
	},
})

-- Install your plugins here
return packer.startup(function(use)
	-- My plugins here
	use("wbthomason/packer.nvim")
	use("nvim-lua/popup.nvim")
	use({ "nvim-telescope/telescope.nvim", config = conf("telescope") })
	use("nvim-lua/plenary.nvim")
	use({ "folke/which-key.nvim", config = conf("whichkey") })
	use_local({ "razak17/zephyr-nvim", local_path = "personal" })
	use({ "nvim-neo-tree/neo-tree.nvim", branch = "v2.x", config = conf("neo-tree") })
	use("MunifTanjim/nui.nvim")
	use({
		"s1n7ax/nvim-window-picker",
		tag = "v1.*",
		config = function()
			require("window-picker").setup({
				autoselect_one = true,
				include_current = false,
				filter_rules = {
					bo = {
						filetype = { "neo-tree-popup", "quickfix", "incline" },
						buftype = { "terminal", "quickfix", "nofile" },
					},
				},
			})
		end,
	})
	use({
		"romainl/vim-cool",
		config = function()
			vim.g.CoolTotalMatches = 1
		end,
	})
	use({
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		module = "cmp",
		config = conf("cmp"),
		requires = {
			{ "saadparwaiz1/cmp_luasnip", after = "nvim-cmp" },
			{ "hrsh7th/cmp-buffer", after = "nvim-cmp" },
			{ "f3fora/cmp-spell", after = "nvim-cmp" },
			{ "hrsh7th/cmp-emoji", after = "nvim-cmp" },
			{
				"petertriho/cmp-git",
				after = "nvim-cmp",
				config = function()
					require("cmp_git").setup({
						filetypes = { "gitcommit", "NeogitCommitMessage" },
					})
				end,
			},
			{
				"uga-rosa/cmp-dictionary",
				after = "nvim-cmp",
				config = function()
					-- Refer to install script
					local dicwords = join_paths(pvim.get_runtime_dir(), "site", "dictionary.txt")
					if vim.fn.filereadable(dicwords) ~= 1 then
						dicwords = "/usr/share/dict/words"
					end
					require("cmp_dictionary").setup({
						async = true,
						dic = {
							["*"] = dicwords,
						},
					})
					require("cmp_dictionary").update()
				end,
			},
		},
	})

	use("kyazdani42/nvim-web-devicons")
	use({
		"L3MON4D3/LuaSnip",
		event = "InsertEnter",
		module = "luasnip",
		requires = "rafamadriz/friendly-snippets",
		config = conf("luasnip"),
	})
	use({
		"numToStr/FTerm.nvim",
		event = { "BufWinEnter" },
		config = function()
			local fterm = require("FTerm")
			fterm.setup({ dimensions = { height = 0.9, width = 0.9 } })
			local function new_float(cmd)
				cmd = fterm:new({ cmd = cmd, dimensions = { height = 0.9, width = 0.9 } }):toggle()
			end
			local nnoremap = pvim.nnoremap
			nnoremap([[<c-\>]], function()
				fterm.toggle()
			end, "fterm: toggle lazygit")
			pvim.tnoremap([[<c-\>]], function()
				fterm.toggle()
			end, "fterm: toggle lazygit")
			nnoremap("<leader>lg", function()
				new_float("lazygit")
			end, "fterm: toggle lazygit")
			nnoremap("<leader>gc", function()
				new_float("git add . && git commit -v -a")
			end, "git: commit")
			nnoremap("<leader>gd", function()
				new_float("iconf -ccma")
			end, "git: commit dotfiles")
		end,
	})

	-- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	if PACKER_BOOTSTRAP then
		require("packer").sync()
	end
end)
