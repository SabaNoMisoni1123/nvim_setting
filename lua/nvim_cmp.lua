-- nvim cmp
local cmp = require 'cmp'
local luasnip = require 'luasnip'
local lspkind = require 'lspkind'

cmp.setup {
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
    ['<CR>'] = cmp.mapping.confirm({ select = true }),     -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
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
  sources = {
    { name = 'nvim_lsp',                group_index = 1, priority = 300 },
    { name = 'luasnip',                 group_index = 1, priority = 200 },
    { name = 'nvim_lsp_signature_help', group_index = 1, priority = 150 },
    { name = 'buffer',                  group_index = 1, priority = 100 },
    { name = 'path',                    group_index = 2, priority = 70 },
    {
      name = 'look',
      keyword_length = 2,
      option = {
        convert_case = true,
        loud = true,
      },
      group_index = 2,
      priority = 1,
      max_item_count = 15,
    },
    {
      name = 'dictionary',
      keyword_length = 2,
      group_index = 2,
      priority = 1,
      max_item_count = 15,
    },
  },
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
}

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
    { name = 'buffer',  group_index = 2, priority = 100 },
    { name = 'omni',    group_index = 2, priority = 70 },
    { name = 'path',    group_index = 2, priority = 70 },
    {
      name = 'look',
      keyword_length = 2,
      option = {
        convert_case = true,
        loud = true,
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


-- lua snip
local ls = require("luasnip")
local s = ls.snippet

local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node

local events = require("luasnip.util.events")
local ai = require("luasnip.nodes.absolute_indexer")
local fmt = require("luasnip.extras.fmt").fmt
local extras = require("luasnip.extras")
local m = extras.m
local l = extras.l
local rep = extras.rep
local postfix = require("luasnip.extras.postfix").postfix

-- load vim-snippets
require("luasnip.loaders.from_snipmate").lazy_load({
  path = '~/.local/share/nvim/site/pack/packer/opt/vim-snippets/snippets',
  default_priority = 1,
  override_priority = 1,
})


-- load my snippets
require("luasnip.loaders.from_snipmate").lazy_load({
  path = os.getenv("XDG_CONFIG_HOME") .. "/nvim/snippets",
  default_priority = 10,
  override_priority = 10,
})
