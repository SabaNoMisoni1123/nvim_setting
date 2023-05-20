-- 言語の追加
-- key: command, val: setting strings
local lsp_commands = {}

if vim.fn.executable('pyright') == 1 then
  lsp_commands['pyright'] = 'pyright'
else
  lsp_commands['pylsp'] = 'pylsp'
end

lsp_commands['typescript-language-server'] = 'tsserver'
lsp_commands['vue-language-server'] = 'volar'
lsp_commands['vim-language-server'] = 'vimls'
lsp_commands['texlab'] = 'texlab'
lsp_commands['clangd'] = 'clangd'
lsp_commands['rust-analyzer'] = 'rust_analyzer'
lsp_commands['grammarly-languageserver'] = 'grammarly'
lsp_commands['ltex-ls'] = 'ltex'
lsp_commands['efm-langserver'] = 'efm'
lsp_commands['vscode-json-language-server'] = 'jsonls'
lsp_commands['lua-language-server'] = 'lua_ls'

-- local lsp setting
local nlspsettings = require("nlspsettings")
nlspsettings.setup({
  config_home = vim.fn.stdpath('config') .. '/nlsp-settings',
  local_settings_dir = ".nlsp-settings",
  -- local_settings_root_markers_fallback = { '.git' },
  append_default_schemas = true,
  loader = 'json',
})

-- 諸設定
local opts = { noremap = true, silent = true }
local lsp_flags = {
  debounce_text_changes = 150,
}
local on_attach = function(client, bufnr)
  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set('n', '<leader>lc', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', '<leader>ld', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', '<leader>lh', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', '<leader>li', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<leader>lt', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<leader>lr', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<leader>lf', function() vim.lsp.buf.format { async = true } end, bufopts)

  vim.keymap.set('n', '<leader>le', vim.diagnostic.open_float, bufopts)
  vim.keymap.set('n', ']q', vim.diagnostic.goto_next, bufopts)
  vim.keymap.set('n', '[q', vim.diagnostic.goto_prev, bufopts)

  -- use telescope
  -- vim.keymap.set('n', '<leader>lk', vim.lsp.buf.references, bufopts)
  -- vim.keymap.set('n', '<leader>ls', vim.lsp.buf.document_symbol, bufopts)
  -- vim.keymap.set('n', '<leader>lw', vim.lsp.buf.workspace_symbol, bufopts)

  local builtin = require('telescope.builtin')
  vim.keymap.set('n', '<leader>lk', builtin.lsp_references, bufopts)
  vim.keymap.set('n', '<leader>ls', builtin.lsp_document_symbols, bufopts)
  vim.keymap.set('n', '<leader>lw', builtin.lsp_dynamic_workspace_symbols, bufopts)
end

local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

for key, val in pairs(lsp_commands) do
  -- コマンドの存在を確認
  if vim.fn.executable(key) == 1 then
    -- LSPの起動
    -- LSPごとにif文
    if val == 'grammarly' then
      require('lspconfig')[val].setup {
        on_attach = on_attach,
        flags = lsp_flags,
        capabilities = capabilities,
        filetypes = { "markdown", "text", "tex" },
      }
    elseif val == 'efm' then
      require('lspconfig')[val].setup {
        on_attach = on_attach,
        flags = lsp_flags,
        capabilities = capabilities,
        filetypes = { "markdown", "text", "tex" },
        init_options = { documentFormatting = true },
        settings = {
          rootMarkers = { ".git/" },
        }
      }
    elseif val == 'volar' then
      require('lspconfig')[val].setup {
        on_attach = on_attach,
        flags = lsp_flags,
        capabilities = capabilities,
        init_options = {
          typescript = {
            tsdk = string.sub(vim.fn.system('npm -g root'), 1, -2).."/typescript/lib"
          }
        },
      }
    elseif val == 'lua_ls' then
      require('lspconfig')[val].setup {
        on_attach = on_attach,
        flags = lsp_flags,
        capabilities = capabilities,
        settings = {
          Lua = {
            runtime = {
              -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
              version = 'LuaJIT',
            },
            diagnostics = {
              -- Get the language server to recognize the `vim` global
              globals = { 'vim' },
            },
            workspace = {
              -- Make the server aware of Neovim runtime files
              library = vim.api.nvim_get_runtime_file("", true),
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
              enable = false,
            },
          },
        },
      }
    else
      -- 基本設定
      require('lspconfig')[val].setup {
        on_attach = on_attach,
        flags = lsp_flags,
        capabilities = capabilities,
      }
    end
  end
end

require('lsp_signature').setup {
  floating_window = true,
  floating_window_above_cur_line = true,
  bind = true,
  handler_opts = {
    border = "single"
  },
  zindex = 10,
  doc_lines = 0,
}

-- エラー表示の設定
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
  virtual_text = true,
  signs = true,
  underline = true,
}
)

-- アイコンなどの見た目設定
local signs = { Error = "", Warn = "", Hint = "", Info = "" }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

vim.cmd('LspStart')
