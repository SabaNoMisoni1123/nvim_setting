-- lua/ftmapping.lua

local autocmd_filetype = vim.api.nvim_create_augroup('filetypes', { clear = true })
local bufopts = { noremap = true, buffer = 0 }

-- help
vim.api.nvim_create_autocmd('FileType', {
  pattern = "help",
  group = autocmd_filetype,
  callback = function()
    vim.keymap.set('n', 'q', '<Cmd>q<CR>', bufopts)
  end,
})

-- nvim tree
vim.api.nvim_create_autocmd('FileType', {
  pattern = "NvimTree",
  group = autocmd_filetype,
  callback = function()
    vim.keymap.set('n', '>', '<Cmd>NvimTreeResize +10<CR>', bufopts)
    vim.keymap.set('n', '<', '<Cmd>NvimTreeResize -10<CR>', bufopts)
  end,
})

-- tagbar
vim.api.nvim_create_autocmd('FileType', {
  pattern = "tagbar",
  group = autocmd_filetype,
  callback = function()
    vim.api.nvim_create_user_command(
      'TagbarWidthPlus',
      function()
        vim.g.tagbar_width = vim.g.tagbar_width + 10
      end,
      { nargs = 0 }
    )
    vim.api.nvim_create_user_command(
      'TagbarWidthMinus',
      function()
        vim.g.tagbar_width = vim.g.tagbar_width - 10
      end,
      { nargs = 0 }
    )
    vim.keymap.set('n', '<', '<Cmd>TagbarClose<CR>:TagbarWidthPlus<CR>:Tagbar f<CR>', bufopts)
    vim.keymap.set('n', '>', '<Cmd>TagbarClose<CR>:TagbarWidthMinus<CR>:Tagbar f<CR>', bufopts)
  end,
})

-- c / cpp
vim.api.nvim_create_autocmd('FileType', {
  pattern = { "c", "cpp" },
  group = autocmd_filetype,
  callback = function()
    vim.keymap.set('n', ',x', '<Cmd>QuickRun make/src<CR>', bufopts)
    vim.keymap.set('n', ',,x', '<Cmd>QuickRun cmake/src<CR>', bufopts)
  end,
})

-- markdonw
vim.api.nvim_create_autocmd('FileType', {
  pattern = "markdown",
  group = autocmd_filetype,
  callback = function()
    vim.keymap.set('n', ',x', '<Cmd>QuickRun markdown/marp<CR>', bufopts)
    vim.keymap.set('n', ',,x', '<Cmd>QuickRun markdown/marp-pdf<CR>', bufopts)
  end,
})

-- csv
vim.api.nvim_create_autocmd('FileType', {
  pattern = "csv",
  group = autocmd_filetype,
  callback = function()
    vim.keymap.set('i', ',', ',', bufopts)
  end,
})

-- quickrun
vim.api.nvim_create_autocmd('FileType', {
  pattern = "quickrun",
  group = autocmd_filetype,
  callback = function()
    vim.keymap.set('n', 'q', '<Cmd>q<CR>', bufopts)
  end,
})
