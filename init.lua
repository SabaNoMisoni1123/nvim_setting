-- init.lua

-- リーダキー
vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

-- OS
vim.cmd [[
  let g:OSTYPE=substitute(system("uname"), '\n', '', 'g')
]]

-- プロバイダ設定

vim.g.loaded_python3_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0

-- 各種設定ファイルの読込
require("mapping")
require("set")
require("autocmd")
require("plugins")
require("ftmapping")

-- プラグインの動作設定
vim.api.nvim_create_autocmd("CursorHold", {
  pattern = { "plugins.lua" },
  command = "PackerCompile",
})

vim.cmd("filetype plugin indent on")
vim.cmd("syntax enable")
