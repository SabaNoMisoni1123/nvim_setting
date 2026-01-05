-- lua/lsp/efm_markdown.lua

local M = {}

function M.efm_extra_cfg()
  -- efmls-configs-nvim は「efm 用の linter/formatter 定義集」:contentReference[oaicite:3]{index=3}
  -- ここでは textlint だけ efmls-configs を使い、
  -- markdownlint-cli2 は公式の --format(stdin->stdout) を使う“確実な定義”で手書きします。:contentReference[oaicite:4]{index=4}

  local tools = {}

  -- textlint (lint) from efmls-configs-nvim
  local ok_textlint, textlint = pcall(require, "efmls-configs.linters.textlint")
  if ok_textlint then
    table.insert(tools, textlint)
  end

  -- markdownlint-cli2 (format): stdin->stdout formatting supported by --format :contentReference[oaicite:5]{index=5}
  table.insert(tools, {
    formatCommand = "npx --yes markdownlint-cli2 --format --config ~/.markdownlint-cli2.jsonc",
    formatStdin = true,
  })

  -- markdownlint-cli2 (lint) も efm 経由で欲しい場合（任意）
  table.insert(tools, {
    lintCommand = "npx --yes markdownlint-cli2 --config ~/.markdownlint-cli2.jsonc ${INPUT}",
    lintIgnoreExitCode = true,
    lintFormats = { "%f:%l %m", "%f:%l:%c %m" },
  })

  -- textlint fix を formatter として併用するならここに formatCommand を追加
  -- （ただし format が複数になるため運用設計が要る）

  return {
    init_options = { documentFormatting = true },
    filetype = { "markdown" },
    settings = {
      rootMarkers = { ".git/" },
      languages = {
        markdown = tools,
      },
    },
  }
end

return M
