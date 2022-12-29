local cmp = require 'cmp'
local luasnip = require 'luasnip'
local lspkind = require 'lspkind'

cmp.setup({
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
    end,
  },
  window = {
    -- completion = cmp.config.window.bordered(),
    -- documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end),
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = function(fallback)
      if cmp.visible() then
        cmp.mapping.abort()
      else
        fallback()
      end
    end,
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    ['<C-k>'] = function(fallback)
      if luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end,
    ['<C-j>'] = function(fallback)
      if luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end,
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' , group_index = 1, priority = 300 },
    { name = 'luasnip', group_index = 1, priority = 200 },
    { name = 'nvim_lsp_signature_help', group_index = 2, priority = 150 },
    { name = 'buffer', group_index = 2, priority = 100 },
    { name = 'path', group_index = 2, priority = 70 },
    {
      name = 'look',
      keyword_length = 2,
      option = {
        convert_case = ture,
        loud = ture,
      },
      group_index = 3,
      priority = 30,
    },
    {
      name = 'dictionary',
      keyword_length = 2,
      group_index = 3,
      priority = 10,
    },
  }),
  formatting = {
    format = function(entry, vim_item)
      if vim.tbl_contains({ 'path' }, entry.source.name) then
        local icon, hl_group = require('nvim-web-devicons').get_icon(entry:get_completion_item().label)
        if icon then
            vim_item.kind = icon
            vim_item.kind_hl_group = hl_group
            return vim_item
        end
      end
      return lspkind.cmp_format({
        with_text = true,
        mode = "symbol_text",
        menu = ({
          buffer = "[Buffer]",
          nvim_lsp = "[LSP]",
          luasnip = "[LuaSnip]",
          nvim_lsp_signature_help = "[Help]",
          omni = "[Omni]",
          path = "[Path]",
          look = "[Look]",
          dictionary = "[dict]"
        }),
      })(entry, vim_item)
    end
  },
})

require("cmp_dictionary").setup({
  dic = {
    -- If you always use the English dictionary, The following settings are suitable:
    ["*"] = "/usr/share/dict/words",
  },
  max_items = 50,
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'buffer' },
    { name = 'look' },
    { name = 'dictionary' },
  })
})

cmp.setup.filetype('tex', {
  sources = cmp.config.sources({
    { name = 'luasnip', group_index = 1, priority = 200 },
    { name = 'buffer', group_index = 2, priority = 100 },
    { name = 'omni', group_index = 2, priority = 70 },
    { name = 'path', group_index = 2, priority = 70 },
    {
      name = 'look',
      keyword_length = 2,
      option = {
        convert_case = ture,
        loud = ture,
      },
      group_index = 3,
      priority = 30,
    },
    {
      name = 'dictionary',
      keyword_length = 2,
      group_index = 3,
      priority = 10,
    },
  })
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' },
    { name = 'cmdline' }
  })
})

cmp.setup {
  preselect = cmp.PreselectMode.None
}
