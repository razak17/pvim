local fn = vim.fn

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
	use("wbthomason/packer.nvim") -- Have packer manage itself
	use("nvim-lua/popup.nvim") -- An implementation of the Popup API from vim in Neovim
	use("nvim-lua/plenary.nvim") -- Useful lua functions used ny lots of plugins
	use("folke/which-key.nvim")
	use("razak17/zephyr-nvim")
	use("nvim-telescope/telescope.nvim")
	use({ "nvim-neo-tree/neo-tree.nvim", branch = "v2.x" })
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
  use "hrsh7th/nvim-cmp"
  use "hrsh7th/cmp-buffer" -- buffer completions
  use "hrsh7th/cmp-path" -- path completions
  use "f3fora/cmp-spell"
  use "hrsh7th/cmp-emoji"
use({
  'uga-rosa/cmp-dictionary',
      config = function()
        -- Refer to install script
        local dicwords = join_paths(pvim.get_runtime_dir(), 'site', 'dictionary.txt')
        if vim.fn.filereadable(dicwords) ~= 1 then dicwords = '/usr/share/dict/words' end
        require('cmp_dictionary').setup({
          async = true,
          dic = {
            ['*'] = dicwords,
          },
        })
        require('cmp_dictionary').update()
      end,
})

  -- Snippet
  use "L3MON4D3/LuaSnip" --snippet engine
  use "rafamadriz/friendly-snippets" -- a bunch of snippets to use

	-- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	if PACKER_BOOTSTRAP then
		require("packer").sync()
	end
end)
