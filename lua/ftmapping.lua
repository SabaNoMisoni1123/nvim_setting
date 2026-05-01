-- lua/ftmapping.lua

local autocmd_filetype = vim.api.nvim_create_augroup('filetypes', { clear = true })

local function map(mode, lhs, rhs, desc, opts)
  opts = vim.tbl_extend("force", { buffer = true, silent = true }, opts or {})
  if desc then
    opts.desc = desc
  end
  vim.keymap.set(mode, lhs, rhs, opts)
end

-- help
vim.api.nvim_create_autocmd('FileType', {
  pattern = "help",
  group = autocmd_filetype,
  callback = function()
    map('n', 'q', '<Cmd>quit<CR>', 'Close help')
  end,
})

-- nvim tree
vim.api.nvim_create_autocmd('FileType', {
  pattern = "NvimTree",
  group = autocmd_filetype,
  callback = function()
    map('n', '>', '<Cmd>NvimTreeResize +10<CR>', 'Expand NvimTree width')
    map('n', '<', '<Cmd>NvimTreeResize -10<CR>', 'Shrink NvimTree width')
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
      { nargs = 0, force = true }
    )
    vim.api.nvim_create_user_command(
      'TagbarWidthMinus',
      function()
        vim.g.tagbar_width = vim.g.tagbar_width - 10
      end,
      { nargs = 0, force = true }
    )
    map('n', '<', '<Cmd>TagbarClose<CR><Cmd>TagbarWidthMinus<CR><Cmd>Tagbar f<CR>', 'Shrink Tagbar width')
    map('n', '>', '<Cmd>TagbarClose<CR><Cmd>TagbarWidthPlus<CR><Cmd>Tagbar f<CR>', 'Expand Tagbar width')
  end,
})

-- c / cpp
vim.api.nvim_create_autocmd('FileType', {
  pattern = { "c", "cpp" },
  group = autocmd_filetype,
  callback = function()
    map('n', ',x', '<Cmd>QuickRun make/src<CR>', 'QuickRun make/src')
    map('n', ',,x', '<Cmd>QuickRun cmake/src<CR>', 'QuickRun cmake/src')
  end,
})

-- markdown
vim.api.nvim_create_autocmd('FileType', {
  pattern = "markdown",
  group = autocmd_filetype,
  callback = function()
    map('n', ',x', '<Cmd>QuickRun markdown/marp<CR>', 'QuickRun Marp')
    map('n', ',,x', '<Cmd>QuickRun markdown/marp-pdf<CR>', 'QuickRun Marp PDF')
    map('n', '<C-x>', '<Cmd>MarkdownPreviewToggle<CR>', 'Toggle Markdown preview')
  end,
})

-- csv
vim.api.nvim_create_autocmd('FileType', {
  pattern = "csv",
  group = autocmd_filetype,
  callback = function()
    map('i', ',', ',', 'Insert comma without auto-space')
  end,
})
