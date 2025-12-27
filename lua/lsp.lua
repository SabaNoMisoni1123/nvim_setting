-- ===============================
-- LSP 全体設定（Neovim 0.11+ 対応版 / 高速化）
-- ===============================

local enabled = {}
local exe_cache = {}
local npm_root_cache = nil -- string | false | nil(未確定)

-- ---------- utils ----------
local function trim(s) return (s:gsub("%s+$", "")) end

local function cmd_exists(cmd)
  if exe_cache[cmd] ~= nil then return exe_cache[cmd] end
  local ok = (vim.fn.executable(cmd) == 1)
  exe_cache[cmd] = ok
  return ok
end

local function prewarm_npm_root()
  if npm_root_cache ~= nil then return end
  if vim.system then
    vim.system({ "npm", "-g", "root" }, { text = true }, function(obj)
      local v = false
      if obj.code == 0 and obj.stdout and obj.stdout ~= "" then
        v = trim(obj.stdout)
      end
      vim.schedule(function()
        npm_root_cache = v
      end)
    end)
  end
end

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

-- ---------- common ----------
local lsp_flags = { debounce_text_changes = 150 }

local capabilities = require("cmp_nvim_lsp").default_capabilities(
  vim.lsp.protocol.make_client_capabilities()
)

local on_attach = function(client, bufnr)
  local bufopts = { noremap = true, silent = true, buffer = bufnr }

  vim.keymap.set("n", "<leader>lc", vim.lsp.buf.declaration, bufopts)
  vim.keymap.set("n", "<leader>ld", vim.lsp.buf.definition, bufopts)
  vim.keymap.set("n", "<leader>lh", vim.lsp.buf.hover, bufopts)
  vim.keymap.set("n", "<leader>li", vim.lsp.buf.implementation, bufopts)
  vim.keymap.set("n", "<leader>lt", vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, bufopts)
  vim.keymap.set("n", "<leader>lf", function() vim.lsp.buf.format({ async = true }) end, bufopts)

  vim.keymap.set("n", "<leader>le", vim.diagnostic.open_float, bufopts)
  -- vim.keymap.set("n", "]q", vim.diagnostic.goto_next, bufopts)
  -- vim.keymap.set("n", "[q", vim.diagnostic.goto_prev, bufopts)

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

-- ---------- per-server config ----------
local function server_config(name)
  if name == "grammarly" then
    return { filetypes = { "markdown", "text", "tex" } }
  elseif name == "ts_ls" then
    local root = get_npm_global_root()
    local plugin_loc = nil
    if root and root ~= false then
      plugin_loc = root .. "/@vue/typescript-plugin"
    end
    local cfg = {
      filetypes = { "javascript", "typescript", "vue" },
      init_options = { plugins = {} },
    }
    if plugin_loc then
      table.insert(cfg.init_options.plugins, {
        name = "@vue/typescript-plugin",
        location = plugin_loc,
        languages = { "javascript", "typescript", "vue" },
      })
    end
    return cfg
  elseif name == "vue_ls" then
    local root = get_npm_global_root()
    local tsdk = nil
    if root and root ~= false then
      tsdk = root .. "/typescript/lib"
    end
    local cfg = { init_options = { typescript = {} } }
    if tsdk then
      cfg.init_options.typescript.tsdk = tsdk
    end
    return cfg
  elseif name == "efm" then
    return {
      filetypes = { "markdown", "tex", "asciidoc", "rst", "org" },
      init_options = { documentFormatting = true },
      settings = { rootMarkers = { ".git/" } },
    }
  elseif name == "lua_ls" then
    return {
      settings = {
        Lua = {
          runtime = { version = "LuaJIT" },
          diagnostics = { globals = { "vim" } },
          workspace = { library = vim.api.nvim_get_runtime_file("", true) },
          telemetry = { enable = false },
        },
      },
    }
  else
    return {}
  end
end

local function setup_and_enable(name, cmd)
  if enabled[name] then return end
  if cmd and not cmd_exists(cmd) then return end

  local cfg = server_config(name)
  cfg.on_attach = on_attach
  cfg.flags = lsp_flags
  cfg.capabilities = capabilities

  vim.lsp.config(name, cfg)
  vim.lsp.enable(name)
  enabled[name] = true
end

-- ---------- FileType -> LSP mapping ----------
-- 必要な時にだけ setup_and_enable する
local function enable_for_filetype(ft)
  if ft == "python" then
    if cmd_exists("pyright") then
      setup_and_enable("pyright", "pyright")
    else
      setup_and_enable("pylsp", "pylsp")
    end
    return
  end

  if ft == "typescript" or ft == "typescriptreact" or ft == "javascript" or ft == "javascriptreact" then
    setup_and_enable("ts_ls", "typescript-language-server")
    return
  end

  if ft == "vue" then
    setup_and_enable("vue_ls", "vue-language-server")
    setup_and_enable("ts_ls", "typescript-language-server")
    return
  end

  if ft == "vim" then
    setup_and_enable("vimls", "vim-language-server")
    return
  end

  if ft == "tex" then
    setup_and_enable("texlab", "texlab")
    setup_and_enable("ltex", "ltex-ls")
    setup_and_enable("efm", "efm-langserver")
    setup_and_enable("grammarly", "grammarly-languageserver")
    return
  end

  if ft == "markdown" or ft == "text" then
    setup_and_enable("ltex", "ltex-ls")
    setup_and_enable("efm", "efm-langserver")
    setup_and_enable("grammarly", "grammarly-languageserver")
    return
  end

  if ft == "c" or ft == "cpp" then
    setup_and_enable("clangd", "clangd")
    return
  end

  if ft == "rust" then
    setup_and_enable("rust_analyzer", "rust-analyzer")
    return
  end

  if ft == "json" then
    setup_and_enable("jsonls", "vscode-json-language-server")
    return
  end

  if ft == "lua" then
    setup_and_enable("lua_ls", "lua-language-server")
    return
  end
end

-- 起動後に npm root をバックグラウンドで先読み（ブロックしない）
vim.api.nvim_create_autocmd("VimEnter", {
  once = true,
  callback = function()
    prewarm_npm_root()
  end,
})

-- FileTypeごとに必要なサーバだけ有効化
vim.api.nvim_create_autocmd("FileType", {
  callback = function(args)
    enable_for_filetype(vim.bo[args.buf].filetype)
  end,
})

-- ---------- lsp_signature ----------
-- ここは軽量だが、LspAttach後でも良い。現状維持（必要なら後で遅延へ）
require("lsp_signature").setup({
  floating_window = true,
  floating_window_above_cur_line = true,
  bind = true,
  handler_opts = { border = "single" },
  zindex = 10,
  doc_lines = 0,
})

-- ---------- diagnostics ----------
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
