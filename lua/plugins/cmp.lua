local cmp_status_ok, cmp = pcall(require, "cmp")
if not cmp_status_ok then
	return
end

local luasnip = require("luasnip")

local function tab(fallback)
  local ok, luasnip = rvim.safe_require('luasnip', { silent = true })
  if cmp.visible() then
    cmp.select_next_item()
    return
  end
  if ok and luasnip.expand_or_locally_jumpable() then
    luasnip.expand_or_jump()
    return
  end
  fallback()
end

local function shift_tab(fallback)
  local ok, luasnip = rvim.safe_require('luasnip', { silent = true })
  if cmp.visible() then
    cmp.select_prev_item()
    return
  end
  if ok and luasnip.jumpable(-1) then
    luasnip.jump(-1)
    return
  end
  fallback()
end

cmp.setup({
	snippet = {
    expand = function(args) require('luasnip').lsp_expand(args.body) end,
	},
	window = {
		completion = cmp.config.window.bordered({
			border = { "🭽", "▔", "🭾", "▕", "🭿", "▁", "🭼", "▏" },
		}),
		documentation = cmp.config.window.bordered({
			border = { "🭽", "▔", "🭾", "▕", "🭿", "▁", "🭼", "▏" },
		}),
	},
  mapping = {
    ['<c-h>'] = cmp.mapping(
      function() api.nvim_feedkeys(fn['copilot#Accept'](t('<Tab>')), 'n', true) end
    ),
    ['<C-k>'] = cmp.mapping.select_prev_item(),
    ['<C-j>'] = cmp.mapping.select_next_item(),
    ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
    ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
    ['<Tab>'] = cmp.mapping(tab, { 'i', 's', 'c' }),
    ['<S-Tab>'] = cmp.mapping(shift_tab, { 'i', 's', 'c' }),
    ['<C-q>'] = cmp.mapping({
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    }),
    ['<C-space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm({ select = false }), -- If nothing is selected don't complete
  },
	formatting = {
		fields = { "kind", "abbr", "menu" },
		source_names = {
			luasnip = "(SN)",
			path = "(Path)",
			buffer = "(Buf)",
			dictionary = "(Dict)",
			spell = "(SP)",
			calc = "(Calc)",
			emoji = "(E)",
		},
	},
	sources = {
		{ name = "luasnip", group_index = 2 },
		{ name = "buffer", group_index = 2 },
		{ name = "path", group_index = 2 },
		{ name = "emoji", group_index = 2 },
	},
	experimental = {
		ghost_text = true,
	},
})
