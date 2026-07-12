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

local function get_npm_global_package_dir(pkg)
  local root = get_npm_global_root()
  if not root or root == false then
    return nil
  end

  local path = root .. "/" .. pkg
  return vim.uv.fs_stat(path) and path or nil
end

-- ---- common ----
local lsp_flags = { debounce_text_changes = 150 }

local base_cap = vim.lsp.protocol.make_client_capabilities()
local ok_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
local capabilities = ok_cmp and cmp_lsp.default_capabilities(base_cap) or base_cap

local on_attach = function(_, bufnr)
  local function map(lhs, rhs, desc)
    vim.keymap.set("n", lhs, rhs, { silent = true, buffer = bufnr, desc = desc })
  end

  map("<leader>lc", vim.lsp.buf.declaration, "LSP declaration")
  map("<leader>ld", vim.lsp.buf.definition, "LSP definition")
  map("<leader>lh", vim.lsp.buf.hover, "LSP hover")
  map("<leader>li", vim.lsp.buf.implementation, "LSP implementation")
  map("<leader>lt", vim.lsp.buf.type_definition, "LSP type definition")
  map("<leader>lr", vim.lsp.buf.rename, "LSP rename")
  map("<leader>lf", function() vim.lsp.buf.format({ async = true }) end, "LSP format")

  map("<leader>le", vim.diagnostic.open_float, "Open diagnostic float")
  map("]q", function() vim.diagnostic.jump({ count = 1, float = true }) end, "Next diagnostic")
  map("[q", function() vim.diagnostic.jump({ count = -1, float = true }) end, "Previous diagnostic")
  map("<C-a>", vim.lsp.buf.code_action, "LSP code action")

  map("<leader>lk", function()
    require("telescope.builtin").lsp_references()
  end, "LSP references")
  map("<leader>ls", function()
    require("telescope.builtin").lsp_document_symbols()
  end, "LSP document symbols")
  map("<leader>lw", function()
    require("telescope.builtin").lsp_dynamic_workspace_symbols()
  end, "LSP workspace symbols")
end

local function enable_if_installed(name, cmd, extra_cfg)
  if cmd and not cmd_exists(cmd) then
    return false
  end

  local default_cfg = vim.lsp.config[name] or {}
  local cfg = extra_cfg or {}
  if cfg.filetype and not cfg.filetypes then
    cfg.filetypes = cfg.filetype
    cfg.filetype = nil
  end
  local server_on_attach = cfg.on_attach or default_cfg.on_attach
  cfg.on_attach = function(client, bufnr)
    if type(server_on_attach) == "function" then
      server_on_attach(client, bufnr)
    end
    on_attach(client, bufnr)
  end
  cfg.flags = lsp_flags
  cfg.capabilities = capabilities

  -- nvim-lspconfig のデフォルト設定を拡張
  vim.lsp.config(name, cfg)
  vim.lsp.enable(name)
  return true
end

-- ---- per-server (必要最小限の上書きだけ) ----

-- Python: pyright
enable_if_installed("pyright", "pyright-langserver")

-- TypeScript / JavaScript

do
  local vue_language_server_path = get_npm_global_package_dir("@vue/language-server")
  local vue_ts_plugin = nil
  local can_enable_vue_ls = false

  if vue_language_server_path then
    vue_ts_plugin = {
      name = "@vue/typescript-plugin",
      location = vue_language_server_path,
      languages = { "vue" },
      configNamespace = "typescript",
    }
  end

  if enable_if_installed("vtsls", "vtsls", vue_ts_plugin and {
      settings = {
        vtsls = {
          tsserver = {
            globalPlugins = {
              vue_ts_plugin,
            },
          },
        },
      },
      filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
    } or nil) then
    can_enable_vue_ls = true
  elseif enable_if_installed("ts_ls", "typescript-language-server", {
      init_options = vue_ts_plugin and {
        plugins = {
          {
            name = vue_ts_plugin.name,
            location = vue_ts_plugin.location,
            languages = { "javascript", "typescript", "vue" },
          },
        },
      } or { plugins = {} },
      filetypes = vue_ts_plugin
          and { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" }
          or nil,
    }) then
    can_enable_vue_ls = vue_ts_plugin ~= nil
  end

  if can_enable_vue_ls then
    local root = get_npm_global_root()
    local tsdk = (root and root ~= false) and (root .. "/typescript/lib") or nil
    local cfg = { init_options = { typescript = {} } }
    if tsdk then
      cfg.init_options.typescript.tsdk = tsdk
    end
    enable_if_installed("vue_ls", "vue-language-server", cfg)
  end
end

enable_if_installed("eslint", "vscode-eslint-language-server")

-- Lua
enable_if_installed("lua_ls", "lua-language-server", {
  on_init = function(client)
    if client.workspace_folders then
      local path = client.workspace_folders[1].name
      if path ~= vim.fn.stdpath("config")
          and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc")) then
        return
      end
    end

    client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua or {}, {
      runtime = {
        version = "LuaJIT",
        path = {
          "lua/?.lua",
          "lua/?/init.lua",
        },
      },
      diagnostics = { globals = { "vim" } },
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME,
          vim.api.nvim_get_runtime_file("lua/lspconfig", false)[1],
        },
      },
      telemetry = { enable = false },
    })
  end,
  settings = {
    Lua = {},
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
    filetypes = { "markdown" },
    settings = { rootMarkers = { ".git/" } },
  }
  if not extra.filetypes then
    extra.filetypes = { "markdown" }
  end
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
