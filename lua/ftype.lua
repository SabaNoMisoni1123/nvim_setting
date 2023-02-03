local autocmd_filetype = vim.api.nvim_create_augroup('filetypes', { clear = true })

vim.api.nvim_create_autocmd('FileType', {
  pattern = "*",
  group = autocmd_filetype,
  callback = function()
    return 0
  end,
})

-- help
vim.api.nvim_create_autocmd('FileType', {
  pattern = "help",
  group = autocmd_filetype,
  callback = function()
    local bufopts = { noremap = true }
    vim.keymap.set('n', 'q', '<Cmd>q<CR>', bufopts)
  end,
})

-- nvim tree
vim.api.nvim_create_autocmd('FileType', {
  pattern = "NvimTree",
  group = autocmd_filetype,
  callback = function()
    local bufopts = { noremap = true }
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

    local bufopts = { noremap = true }
    vim.keymap.set('n', '<', '<Cmd>TagbarClose<CR>:TagbarWidthPlus<CR>:Tagbar f<CR>', bufopts)
    vim.keymap.set('n', '>', '<Cmd>TagbarClose<CR>:TagbarWidthMinus<CR>:Tagbar f<CR>', bufopts)
  end,
})

-- c
vim.api.nvim_create_autocmd('FileType', {
  pattern = "c",
  group = autocmd_filetype,
  callback = function()
    local bufopts = { noremap = true }
    vim.keymap.set('n', ',x', '<Cmd>QuickRun make/src<CR>', bufopts)
    vim.keymap.set('n', ',,x', '<Cmd>QuickRun cmake/src<CR>', bufopts)
  end,
})

-- cpp
vim.api.nvim_create_autocmd('FileType', {
  pattern = "cpp",
  group = autocmd_filetype,
  callback = function()
    local bufopts = { noremap = true }
    vim.keymap.set('n', ',x', '<Cmd>QuickRun make/src<CR>', bufopts)
    vim.keymap.set('n', ',,x', '<Cmd>QuickRun cmake/src<CR>', bufopts)
  end,
})
