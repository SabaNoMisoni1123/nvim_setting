-- init.lua

-- WSLでPATHが肥大化している場合の保険（必要に応じて）
if vim.fn.has("wsl") == 1 then
  local p = vim.env.PATH or ""
  -- /mnt/c などWindowsマウント由来を除外（必要なら条件を調整）
  local filtered = {}
  for part in string.gmatch(p, "[^:]+") do
    if not part:match("^/mnt/[a-zA-Z]/") then
      table.insert(filtered, part)
    end
  end
  vim.env.PATH = table.concat(filtered, ":")
end

-- clipboard
-- unnamedplus を使う（既に利用中）
vim.opt.clipboard = "unnamedplus"

-- xclip を provider として明示
vim.g.clipboard = {
  name = "xclip-wsl2",
  copy = {
    ["+"] = "xclip -selection clipboard -in",
    ["*"] = "xclip -selection primary -in",
  },
  paste = {
    ["+"] = "xclip -selection clipboard -out",
    ["*"] = "xclip -selection primary -out",
  },
  cache_enabled = 1,
}

-- Leader
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- OS（外部コマンド uname を使わずに判定）
-- 以前の g:OSTYPE を維持したい場合は以下で同等の値になります
vim.g.OSTYPE = vim.loop.os_uname().sysname

-- Providers（不要なものは無効化して起動を軽くする）
vim.g.loaded_python3_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0

-- Settings / mappings / plugins
require("mapping")
require("set")
require("autocmd")
require("plugins")
require("ftmapping")
