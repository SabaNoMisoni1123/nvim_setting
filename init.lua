vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

-- local ostype = os.execute("uname")

require("mapping")
require("set")
require("autocmd")
require("plugins")
-- require("ftype")

vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = { "plugins.lua" },
  command = "PackerCompile",
})

vim.cmd("filetype plugin indent on")
vim.cmd("syntax enable")
