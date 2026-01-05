-- lua/lsp.lua
-- ===============================
-- LSP 全体設定（Neovim 0.11.4 + nvim-lspconfig v2 前提）
-- 目的:
--  - lazy.nvim で遅延ロード（BufReadPre/BufNewFile）を維持
--  - 自前 FileType ルーティングを捨て、vim.lsp.enable() に一本化して取りこぼし防止
-- ===============================

-- ---- utils ----
local exe_cache = {}
local function cmd_exists(cmd)
  if exe_cache[cmd] ~= nil then return exe_cache[cmd] end
  local ok = (vim.fn.executable(cmd) == 1)
  exe_cache[cmd] = ok
  return ok
end

local function trim(s) return (s:gsub("%s+$", "")) end

local npm_root_cache = nil -- string | false | nil
local function get_npm_global_root()
  if npm_root_cache ~= nil then return npm_root_cache end
  if not cmd_exists("npm") then
    npm_root_cache = false
    return npm_root_cache
  end
  local out = vim.fn.systemlist({ "npm", "-g", "root" })
  if vim.v.shell_error ~= 0 or not out[1] or out[1] == "" then
    npm_root_cache = false
    return npm_root_cache
  end
  npm_root_cache = trim(out[1])
  return npm_root_cache
end

-- ---- common ----
local lsp_flags = { debounce_text_changes = 150 }

local base_cap = vim.lsp.protocol.make_client_capabilities()
local ok_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
local capabilities = ok_cmp and cmp_lsp.default_capabilities(base_cap) or base_cap

local on_attach = function(_, bufnr)
  local bufopts = { noremap = true, silent = true, buffer = bufnr }

  vim.keymap.set("n", "<leader>lc", vim.lsp.buf.declaration, bufopts)
  vim.keymap.set("n", "<leader>ld", vim.lsp.buf.definition, bufopts)
  vim.keymap.set("n", "<leader>lh", vim.lsp.buf.hover, bufopts)
  vim.keymap.set("n", "<leader>li", vim.lsp.buf.implementation, bufopts)
  vim.keymap.set("n", "<leader>lt", vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, bufopts)
  vim.keymap.set("n", "<leader>lf", function() vim.lsp.buf.format({ async = true }) end, bufopts)

  vim.keymap.set("n", "<leader>le", vim.diagnostic.open_float, bufopts)
  vim.keymap.set("n", "]q", function() vim.diagnostic.jump({ count = 1, float = true }) end, bufopts)
  vim.keymap.set("n", "[q", function() vim.diagnostic.jump({ count = -1, float = true }) end, bufopts)
  vim.keymap.set("n", "<C-a>", vim.lsp.buf.code_action, bufopts)

  vim.keymap.set("n", "<leader>lk", function()
    require("telescope.builtin").lsp_references()
  end, bufopts)
  vim.keymap.set("n", "<leader>ls", function()
    require("telescope.builtin").lsp_document_symbols()
  end, bufopts)
  vim.keymap.set("n", "<leader>lw", function()
    require("telescope.builtin").lsp_dynamic_workspace_symbols()
  end, bufopts)
end

local function enable_if_installed(name, cmd, extra_cfg)
  if cmd and not cmd_exists(cmd) then
    return false
  end

  local cfg = extra_cfg or {}
  cfg.on_attach = on_attach
  cfg.flags = lsp_flags
  cfg.capabilities = capabilities

  -- nvim-lspconfig のデフォルト設定を拡張
  vim.lsp.config(name, cfg)
  vim.lsp.enable(name)
  return true
end

-- ---- per-server (必要最小限の上書きだけ) ----

-- Python: pyright 優先、無ければ pylsp
if not enable_if_installed("pyright", "pyright-langserver") then
  enable_if_installed("pylsp", "pylsp")
end

-- TypeScript / JavaScript
do
  local root = get_npm_global_root()
  local plugin_loc = (root and root ~= false) and (root .. "/@vue/typescript-plugin") or nil
  local cfg = {
    -- ts_ls 側の filetypes はデフォルトに任せる（必要ならここで上書き）
    init_options = { plugins = {} },
  }
  if plugin_loc then
    table.insert(cfg.init_options.plugins, {
      name = "@vue/typescript-plugin",
      location = plugin_loc,
      languages = { "javascript", "typescript", "vue" },
    })
  end
  enable_if_installed("ts_ls", "typescript-language-server", cfg)
end
enable_if_installed("eslint", "vscode-eslint-language-server")

-- Vue
do
  local root = get_npm_global_root()
  local tsdk = (root and root ~= false) and (root .. "/typescript/lib") or nil
  local cfg = { init_options = { typescript = {} } }
  if tsdk then
    cfg.init_options.typescript.tsdk = tsdk
  end
  enable_if_installed("vue_ls", "vue-language-server", cfg)
end

-- Lua
enable_if_installed("lua_ls", "lua-language-server", {
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      diagnostics = { globals = { "vim" } },
      workspace = { library = vim.api.nvim_get_runtime_file("", true) },
      telemetry = { enable = false },
    },
  },
})

-- C/C++
enable_if_installed("clangd", "clangd")

-- Rust
enable_if_installed("rust_analyzer", "rust-analyzer")

-- JSON
enable_if_installed("jsonls", "vscode-json-language-server")

-- Vim script
enable_if_installed("vimls", "vim-language-server")

-- TeX
enable_if_installed("texlab", "texlab")
enable_if_installed("ltex", "ltex-ls")

-- EFM (Markdown/Text)
do
  local ok, efm_md = pcall(require, "lsp.efm_markdown")
  local extra = ok and efm_md.efm_extra_cfg() or {
    init_options = { documentFormatting = true },
    settings = { rootMarkers = { ".git/" } },
  }
  enable_if_installed("efm", "efm-langserver", extra)
end
enable_if_installed("marksman", "marksman")

enable_if_installed("grammarly", "grammarly-languageserver", {
  filetypes = { "markdown", "text", "tex" },
})

-- HTML
enable_if_installed("html", "vscode-html-language-server")

-- CSS
enable_if_installed("cssls", "vscode-css-languageserver")
enable_if_installed("css_variables", "css-variables-language-server")

-- ---- lsp_signature ----
pcall(function()
  require("lsp_signature").setup({
    floating_window = true,
    floating_window_above_cur_line = true,
    bind = true,
    handler_opts = { border = "single" },
    zindex = 10,
    doc_lines = 0,
  })
end)

-- ---- diagnostics ----
vim.diagnostic.config({
  virtual_text = { spacing = 1 },
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
    },
  },
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})
