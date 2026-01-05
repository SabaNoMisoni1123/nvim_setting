-- lua/autocmd.lua
-- markdown
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.opt.formatoptions:append { "r" }
  end,
})

-- tex
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "tex", "latex" },
  callback = function()
    vim.g.tex_flavor = "latex"
  end,
})
