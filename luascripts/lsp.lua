-- 言語の追加
local lsp_commands = {}
if vim.fn.executable('pyright') == 1 then
  lsp_commands['python'] = 'pyright'
elseif vim.fn.executable('pylsp') == 1 then
  lsp_commands['python'] = 'pylsp'
end

if vim.fn.executable('typescript-language-server') == 1 then
  lsp_commands['javascript'] = 'tsserver'
elseif vim.fn.executable('deno') == 1 then
  lsp_commands['javascript'] = 'deno'
end

if vim.fn.executable('vue-language-server') == 1 then
  lsp_commands['vue'] = 'volar'
end

if vim.fn.executable('vim-language-server') == 1 then
  lsp_commands['vim'] = 'vimls'
end

if vim.fn.executable('texlab') == 1 then
  lsp_commands['tex'] = 'texlab'
end

if vim.fn.executable('clangd') == 1 then
  lsp_commands['c_cpp'] = 'clangd'
end

if vim.fn.executable('rust-analyzer') == 1 then
  lsp_commands['rust'] = 'rust_analyzer'
end

-- 諸設定
local opts = { noremap = true, silent = true }
local lsp_flags = {
  debounce_text_changes = 150,
}
local on_attach = function(client, bufnr)
  local bufopts = { noremap = true, silent = true, buffer = buffer }
  vim.keymap.set('n', '<leader>lc', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', '<leader>ld', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', '<leader>lh', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', '<leader>li', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<leader>lt', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<leader>lr', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<leader>lk', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<leader>ls', vim.lsp.buf.document_symbol, bufopts)
  vim.keymap.set('n', '<leader>lw', vim.lsp.buf.workspace_symbol, bufopts)
  vim.keymap.set('n', '<leader>lf', function() vim.lsp.buf.format { async = true } end, bufopts)
  vim.keymap.set('n', '<leader>le', vim.diagnostic.open_float, bufopts)
end

local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

for key, val in pairs(lsp_commands) do
  require('lspconfig')[val].setup{
    on_attach = on_attach,
    flags = lsp_flags,
    capabilities = capabilities,
  }
end

require('lsp_signature').setup{
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
