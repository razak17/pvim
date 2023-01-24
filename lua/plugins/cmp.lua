return function()
  local fn, api = vim.fn, vim.api

  local cmp = require('cmp')
  local icons = require('style').icons
  local kind_icons = icons.kind

  ---A terser proxy for `nvim_replace_termcodes`
  ---@param str string
  ---@return any
  local function replace_termcodes(str) return api.nvim_replace_termcodes(str, true, true, true) end

  local border = { '🭽', '▔', '🭾', '▕', '🭿', '▁', '🭼', '▏' }

  local cmp_window = {
    border = border,
    winhighlight = table.concat({
      'Normal:NormalFloat',
      'FloatBorder:FloatBorder',
      'CursorLine:Visual',
      completion = {
        -- TODO: consider 'shadow', and tweak the winhighlight
        border = border,
      },
      documentation = {
        border = border,
      },
      'Search:None',
    }, ','),
  }

  local function tab(fallback)
    local ok, luasnip = pvim.safe_require('luasnip', { silent = true })
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
    local ok, luasnip = pvim.safe_require('luasnip', { silent = true })
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
    experimental = { ghost_text = false },
    preselect = cmp.PreselectMode.None,
    window = {
      completion = cmp.config.window.bordered(cmp_window),
      documentation = cmp.config.window.bordered(cmp_window),
    },
    snippet = {
      expand = function(args) require('luasnip').lsp_expand(args.body) end,
    },
    mapping = {
      ['<c-h>'] = cmp.mapping(
        function() api.nvim_feedkeys(fn['copilot#Accept'](replace_termcodes('<Tab>')), 'n', true) end
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
      deprecated = true,
      fields = { 'kind', 'abbr', 'menu' },
      format = function(entry, vim_item)
        vim_item.kind = kind_icons[vim_item.kind]
        if entry.source.name == 'emoji' then vim_item.kind = icons.misc.Smiley end
        -- NOTE: order matters
        vim_item.menu = ({
          nvim_lsp = '(Lsp)',
          luasnip = '(Snip)',
          buffer = '(Buf)',
          path = '(Path)',
          emoji = '(Emj)',
          spell = '(Sp)',
          dictionary = '(Dict)',
        })[entry.source.name]
        return vim_item
      end,
    },
    sources = {
      { name = 'luasnip' },
      { name = 'path' },
      {
        name = 'buffer',
        keyword_length = 2,
        options = {
          get_bufnrs = function()
            local bufs = {}
            for _, win in ipairs(api.nvim_list_wins()) do
              bufs[api.nvim_win_get_buf(win)] = true
            end
            return vim.tbl_keys(bufs)
          end,
        },
      },
      { name = 'dictionary', keyword_length = 3 },
      { name = 'emoji' },
    },
  })
end
