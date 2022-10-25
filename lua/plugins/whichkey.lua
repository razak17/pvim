return function()
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
        b = { ':.!toilet -w 200 -f term -F border<CR>', 'term' },
        B = { ':.!toilet -w 200 -f bfraktur<CR>', 'bfraktur' },
        e = { ':.!toilet -w 200 -f emboss<CR>', 'emboss' },
        E = { ':.!toilet -w 200 -f emboss2<CR>', 'emboss2' },
        f = { ':.!toilet -w 200 -f bigascii12<CR>', 'bigascii12' },
        F = { ':.!toilet -w 200 -f letter<CR>', 'letter' },
        m = { ':.!toilet -w 200 -f bigmono12<CR>', 'bigmono12' },
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
      c = { "<cmd>lua require('close_buffers').wipe({ type = 'this' })<CR>", 'close buffer' },
      h = { '<cmd>nohlsearch<CR>', 'no highlight' },
      W = { '<cmd>set wrap! linebreak<CR>', 'toggle wrap' },
      x = { '<cmd>q!<CR>', 'quit' },
      p = {
        name = 'Packer',
        c = { '<cmd>PackerCompile<cr>', 'compile' },
        C = { '<cmd>PackerClean<cr>', 'clean' },
        i = { '<cmd>PackerInstall<cr>', 'install' },
        s = { '<cmd>PackerSync<cr>', 'sync' },
        S = { '<cmd>PackerStatus<cr>', 'status' },
        u = { '<cmd>PackerUpdate<cr>', 'update' },
      },
      S = { '<cmd>set spell! spelllang=en_us<CR><CR>', 'toggle spell' },
    },
  })
end
