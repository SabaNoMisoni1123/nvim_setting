vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

vim.cmd [[
  let g:OSTYPE=substitute(system("uname"), '\n', '', 'g')
]]

require("mapping")
require("set")
require("autocmd")
require("plugins")
require("ftmapping")

vim.api.nvim_create_autocmd("CursorHold", {
  pattern = { "plugins.lua" },
  command = "PackerCompile",
})

vim.cmd("filetype plugin indent on")
vim.cmd("syntax enable")
