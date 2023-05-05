return {
  'folke/which-key.nvim',
  init = function()
    local status_ok, which_key = pcall(require, 'which-key')
    if not status_ok then return end

    which_key.setup({
      plugins = { spelling = { enabled = true } },
      icons = { breadcrumb = '»' },
      window = { border = { '🭽', '▔', '🭾', '▕', '🭿', '▁', '🭼', '▏' } },
      layout = { align = 'center' },
      hidden = { '<silent>', '<cmd>', '<Cmd>', '<CR>', 'call', 'lua', '^:', '^ ' },
      show_help = true,
    })

    which_key.register({
      ['<leader>'] = {
        ['↵'] = 'execute commnd',
        A = {
          name = 'ASCII',
          A = { ':normal 20i<<CR>', 'add 20 less than signs' },
          v = { ':!asciidoc-view %<CR><CR>', 'asciidoc-view' },
          w = { ':.!toilet -w 200 -f wideterm<CR>', 'wideterm' },
        },
        B = {
          name = '+Background',
          a = { ':ls<CR>', 'show all open buffers' },
          -- TODO: Make this better
          d = {
            ':highlight MsgArea guibg=#1e2127 guifg=default<CR>:highlight StatusLine guibg=#1e2127 guifg=default<CR>:highlight Normal guibg=#1e2127 guifg=default<CR>:highlight SignColumn guibg=#1e2127<CR>:highlight LineNr guifg=#5B6268<CR>',
            'dark',
          },
          l = {
            ':highlight MsgArea guibg =#fefefe guifg=#030303<CR>:highlight StatusLine guibg =#fefefe guifg=#030303<CR>:highlight Normal guibg=#fefefe guifg=#030303<CR>:highlight SignColumn guibg=#fefefe<CR>:highlight LineNr guifg=#030303<CR>',
            'light',
          },
        },
        h = { '<cmd>nohlsearch<CR>', 'no highlight' },
        W = { '<cmd>set wrap! linebreak<CR>', 'toggle wrap' },
        x = { '<cmd>q!<CR>', 'quit' },
        S = { '<cmd>set spell! spelllang=en_us<CR><CR>', 'toggle spell' },
      },
    })
  end,
}
