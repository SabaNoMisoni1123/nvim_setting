-- ===============================
-- LSP 全体設定（Neovim 0.11+ 対応版）
-- ===============================

-- ===============================
-- サーバ一覧
-- ===============================
local servers = {}

do
  if vim.fn.executable('pyright') == 1 then
    servers['pyright'] = { _cmd_check = 'pyright' }
  else
    servers['pylsp'] = { _cmd_check = 'pylsp' }
  end

  servers['ts_ls'] = { _cmd_check = 'typescript-language-server' }
  servers['vue_ls'] = { _cmd_check = 'vue-language-server' }
  servers['vimls'] = { _cmd_check = 'vim-language-server' }
  servers['texlab'] = { _cmd_check = 'texlab' }
  servers['clangd'] = { _cmd_check = 'clangd' }
  servers['rust_analyzer'] = { _cmd_check = 'rust-analyzer' }
  servers['grammarly'] = { _cmd_check = 'grammarly-languageserver' }
  servers['ltex'] = { _cmd_check = 'ltex-ls' }
  servers['efm'] = { _cmd_check = 'efm-langserver' }
  servers['jsonls'] = { _cmd_check = 'vscode-json-language-server' }
  servers['lua_ls'] = { _cmd_check = 'lua-language-server' }
end

-- ===============================
-- 共通オプション
-- ===============================
local lsp_flags = { debounce_text_changes = 150 }

local capabilities = require('cmp_nvim_lsp').default_capabilities(
  vim.lsp.protocol.make_client_capabilities()
)

-- バッファにアタッチ時の共通キー割り当て
local on_attach = function(client, bufnr)
  local bufopts = { noremap = true, silent = true, buffer = bufnr }

  vim.keymap.set('n', '<leader>lc', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', '<leader>ld', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', '<leader>lh', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', '<leader>li', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<leader>lt', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<leader>lr', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<leader>lf', function() vim.lsp.buf.format({ async = true }) end, bufopts)

  vim.keymap.set('n', '<leader>le', vim.diagnostic.open_float, bufopts)
  vim.keymap.set('n', ']q', vim.diagnostic.goto_next, bufopts)
  vim.keymap.set('n', '[q', vim.diagnostic.goto_prev, bufopts)

  -- Telescope 連携
  local builtin = require('telescope.builtin')
  vim.keymap.set('n', '<leader>lk', builtin.lsp_references, bufopts)
  vim.keymap.set('n', '<leader>ls', builtin.lsp_document_symbols, bufopts)
  vim.keymap.set('n', '<leader>lw', builtin.lsp_dynamic_workspace_symbols, bufopts)
end

-- ===============================
-- サーバ個別設定
-- ===============================
local function server_config(name)
  if name == 'grammarly' then
    return {
      filetypes = { 'markdown', 'text', 'tex' },
    }
  elseif name == 'ts_ls' then
    -- TypeScript (tsserver 後継) + Vue 連携
    return {
      init_options = {
        plugins = {
          {
            name = '@vue/typescript-plugin',
            -- グローバル npm の @vue/typescript-plugin 位置を解決
            location = (string.gsub(vim.fn.system('npm -g root'), '%s+$', '')) .. '/@vue/typescript-plugin',
            languages = { 'javascript', 'typescript', 'vue' },
          },
        },
      },
      filetypes = { 'javascript', 'typescript', 'vue' },
    }
  elseif name == 'efm' then
    return {
      filetypes = { 'markdown', 'tex', 'asciidoc', 'rst', 'org' },
      init_options = { documentFormatting = true },
      settings = { rootMarkers = { '.git/' } },
    }
  elseif name == 'lua_ls' then
    return {
      settings = {
        Lua = {
          runtime = { version = 'LuaJIT' },
          diagnostics = { globals = { 'vim' } },
          workspace = { library = vim.api.nvim_get_runtime_file('', true) },
          telemetry = { enable = false },
        },
      },
    }
  elseif name == 'vue_ls' then
    return {
      init_options = {
        typescript = {
          tsdk = (string.gsub(vim.fn.system('npm -g root'), '%s+$', '')) .. '/typescript/lib'
        },
      },
    }
  else
    -- それ以外はデフォルト
    return {}
  end
end

-- ===============================
-- 登録（config）と有効化（enable）
-- ===============================
for name, meta in pairs(servers) do
  if not meta._cmd_check or vim.fn.executable(meta._cmd_check) == 1 then
    local cfg = server_config(name)

    cfg.on_attach = on_attach
    cfg.flags = lsp_flags
    cfg.capabilities = capabilities

    vim.lsp.config(name, cfg)

    vim.lsp.enable(name)
  end
end

-- ===============================
-- 署名ポップアップ（lsp_signature）
-- ===============================
require('lsp_signature').setup({
  floating_window = true,
  floating_window_above_cur_line = true,
  bind = true,
  handler_opts = { border = 'single' },
  zindex = 10,
  doc_lines = 0,
})

-- ===============================
-- 診断表示（新 API に統一）
-- ===============================
vim.diagnostic.config({
  virtual_text = {
    spacing = 1,
  },
  signs = {
    test = {
      [vim.diagnostic.severity.ERROR] = "",
      [vim.diagnostic.severity.WARN]  = "",
      [vim.diagnostic.severity.INFO]  = "",
      [vim.diagnostic.severity.HINT]  = "",
    },
    numhl = {
      [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
      [vim.diagnostic.severity.WARN]  = "DiagnosticSignWarn",
      [vim.diagnostic.severity.INFO]  = "DiagnosticSignInfo",
      [vim.diagnostic.severity.HINT]  = "DiagnosticSignHint",
    }
  },
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})
