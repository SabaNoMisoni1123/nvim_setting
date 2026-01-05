-- lua/nvim_cmp.lua

local cmp = require 'cmp'
local luasnip = require 'luasnip'
local lspkind = require 'lspkind'

vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }

cmp.setup {
  -- 事前選択は無効化：意図せぬ <CR> 確定を防ぐ
  preselect = cmp.PreselectMode.None,

  -- snippet 展開エンジンの指定（必須）
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },

  -- 補完/ドキュメントウィンドウの見た目（必要なら枠線を有効化）
  window = {
    -- completion = cmp.config.window.bordered(),
    -- documentation = cmp.config.window.bordered(),
  },

  -- 入力体験の微調整（任意）
  -- 推奨：UI/挙動のブレを減らす
  completion = {
    completeopt = 'menu,menuone,noselect',
  },

  -- ゴーストテキストを使わない
  experimental = {
    ghost_text = false,
  },

  -- キーマップ
  mapping = cmp.mapping.preset.insert({
    -- Tab：①メニュー未表示なら開いて1件目を選択、②表示中は次候補へ
    --      ※luasnip展開/ジャンプを最優先
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        -- 初回Tabで1件目が選択状態になり、以降は次候補へ
        cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
      else
        fallback()
        -- メニューを開いてから1件目を選択（タブが入力できなくなるので採用しないがメモとして残す。）
        -- cmp.complete()
        -- cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert, count = 0 })
      end
    end, { "i", "s" }),

    -- S-Tab
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        -- cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
        cmp.select_prev_item()
      else
        fallback()
      end
    end, { "i", "s" }),

    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),

    -- 補完中止
    ['<C-e>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.abort()
      else
        fallback()
      end
    end, { "i", "c" }),

    -- ③ <CR>で選択中候補を確定（Tabで選んだ1件目も確定可）
    ['<CR>'] = cmp.mapping.confirm({
      select = true,                          -- 未選択でも最上位を選んで確定
      behavior = cmp.ConfirmBehavior.Replace, -- 置換確定
    }),

    -- スニペット操作
    ['<C-k>'] = cmp.mapping(function(fallback)
      if luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { "i", "s" }),
    ['<C-j>'] = cmp.mapping(function(fallback)
      if luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  }),

  -- ソース構成
  sources = {
    { name = 'nvim_lsp',                group_index = 1, priority = 300 },
    { name = 'luasnip',                 group_index = 1, priority = 200 },
    { name = 'nvim_lsp_signature_help', group_index = 1, priority = 150 },
    { name = 'buffer',                  group_index = 1, priority = 100 },
    { name = 'path',                    group_index = 2, priority = 70 },

    -- look
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

    -- dictionary
    {
      name = 'dictionary',
      keyword_length = 2,
      group_index = 2,
      priority = 1,
      max_item_count = 15,
    },
    -- { name = 'copilot', group_index = 1, priority = 250 }, -- 使うなら有効化
  },

  -- 表示整形
  formatting = {
    format = function(entry, vim_item)
      if entry.source.name == 'path' then
        local ok, devicons = pcall(require, 'nvim-web-devicons')
        if ok then
          local label = entry:get_completion_item().label
          local icon, hl_group = devicons.get_icon(label, nil, { default = true })
          if icon then
            vim_item.kind = icon
            vim_item.kind_hl_group = hl_group
            return vim_item
          end
        end
      end
      -- lspkind
      return lspkind.cmp_format({
        mode = "symbol_text",
        maxwidth = 50,
        ellipsis_char = '…',
        menu = {
          buffer = "[Buffer]",
          nvim_lsp = "[LSP]",
          luasnip = "[LuaSnip]",
          nvim_lsp_signature_help = "[Help]",
          omni = "[Omni]",
          path = "[Path]",
          look = "[Look]",
          dictionary = "[dict]",
          mocword = "[mocword]",
          -- copilot = "[copilot]",
        },
      })(entry, vim_item)
    end,
  },
}

-- ファイルタイプ別設定：gitcommit
cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'buffer' },
    { name = 'look' },
    { name = 'dictionary' },
  })
})

-- ファイルタイプ別設定：tex（LaTeX）
cmp.setup.filetype('tex', {
  sources = cmp.config.sources({
    { name = 'mocword', group_index = 1, priority = 300 },
    { name = 'luasnip', group_index = 1, priority = 200 },
    { name = 'buffer',  group_index = 2, priority = 100 },
    { name = 'omni',    group_index = 2, priority = 70 },
    { name = 'path',    group_index = 2, priority = 70 },
    {
      name = 'look',
      keyword_length = 2,
      option = { convert_case = true, loud = true },
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

-- ファイルタイプ別設定：text / markdown
cmp.setup.filetype({ 'text', 'markdown' }, {
  sources = cmp.config.sources({
    { name = 'luasnip', group_index = 2, priority = 10 },
    { name = 'buffer',  group_index = 1, priority = 250 },
    { name = 'mocword', group_index = 1, priority = 300 },
    { name = 'path',    group_index = 2, priority = 70 },
    {
      name = 'look',
      keyword_length = 1,
      option = { convert_case = true, loud = true },
      group_index = 3,
      priority = 200,
    },
    {
      name = 'dictionary',
      keyword_length = 1,
      group_index = 3,
      priority = 100,
    },
  })
})

-- 検索コマンドライン '/' '?' 用（native_menu 併用不可）
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- コマンドライン ':' 用
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'cmdline', priority = 10 },
    { name = 'path',    priority = 1 },
  })
})

----------------------------------------------------------------
-- LuaSnip 設定
----------------------------------------------------------------
local ls            = require("luasnip")
-- 以降のローカル変数は必要に応じてスニペ定義で使用
local s             = ls.snippet
local sn            = ls.snippet_node
local isn           = ls.indent_snippet_node
local t             = ls.text_node
local i             = ls.insert_node
local f             = ls.function_node
local c             = ls.choice_node
local d             = ls.dynamic_node
local r             = ls.restore_node

local events        = require("luasnip.util.events")
local ai            = require("luasnip.nodes.absolute_indexer")
local fmt           = require("luasnip.extras.fmt").fmt
local extras        = require("luasnip.extras")
local m             = extras.m
local l             = extras.l
local rep           = extras.rep
local postfix       = require("luasnip.extras.postfix").postfix

-- SnipMate 形式のスニペットを lazy load
local snipmate_path = vim.fn.expand('~/.local/share/nvim/site/pack/packer/opt/vim-snippets/snippets')
require("luasnip.loaders.from_snipmate").lazy_load({
  path = snipmate_path,
  default_priority = 1,
  override_priority = 1,
})

-- 自作スニペットのロード
local cfg_dir = vim.fn.stdpath('config')
local my_snip_path = (os.getenv("XDG_CONFIG_HOME") and (os.getenv("XDG_CONFIG_HOME") .. "/nvim/snippets"))
    or (cfg_dir .. "/snippets")

require("luasnip.loaders.from_snipmate").lazy_load({
  path = my_snip_path,
  default_priority = 10,
  override_priority = 10,
})
