-- lua/nvim_tree.lua

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true

-- mapping
local function map(lhs, rhs, desc)
  vim.keymap.set('n', lhs, rhs, { silent = true, desc = desc })
end

map('<leader>d', '<Cmd>NvimTreeToggle expand(\'%:p:h\')<CR>', 'Toggle NvimTree at current file')
map('<leader>n', '<Cmd>NvimTreeFocus<CR>', 'Focus NvimTree')
map('st', '<Cmd>tabnew<CR><Cmd>NvimTreeOpen<CR>', 'Open NvimTree in new tab')

local function my_on_attach(bufnr)
  local api = require('nvim-tree.api')
  local function opts(desc)
    return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, silent = true, nowait = true }
  end

  vim.keymap.set('n', '<CR>', api.node.open.edit, opts('Open'))
  vim.keymap.set('n', 'o', api.node.open.edit, opts('Open'))
  vim.keymap.set('n', '<2-LeftMouse>', api.node.open.edit, opts('Open'))
  vim.keymap.set('n', 'h', api.tree.change_root_to_parent, opts('Up'))
  vim.keymap.set('n', 'H', api.tree.collapse_all, opts('Collapse All'))
  vim.keymap.set('n', 'l', api.tree.change_root_to_node, opts('CD'))
  vim.keymap.set('n', '.', api.tree.toggle_hidden_filter, opts('Toggle Dotfiles'))
  vim.keymap.set('n', '<C-s>', api.node.open.horizontal, opts('Open: Horizontal Split'))
  vim.keymap.set('n', '<C-v>', api.node.open.vertical, opts('Open: Vertical Split'))
  vim.keymap.set('n', '<C-t>', api.node.open.tab, opts('Open: New Tab'))
  vim.keymap.set('n', 'K', api.fs.create, opts('Create'))
  vim.keymap.set('n', 'N', api.fs.create, opts('Create'))
  vim.keymap.set('n', '<C-n>', api.fs.create, opts('Create'))
  vim.keymap.set('n', 'x', api.node.run.system, opts('Run System'))
  vim.keymap.set('n', 'P', api.fs.paste, opts('Paste'))
  vim.keymap.set('n', 'p', api.node.open.preview, opts('Open Preview'))
  vim.keymap.set('n', 'r', api.fs.rename, opts('Rename'))
  vim.keymap.set('n', 'yy', api.fs.copy.relative_path, opts('Copy Relative Path'))
  vim.keymap.set('n', '<C-y>', api.fs.copy.absolute_path, opts('Copy Absolute Path'))
  vim.keymap.set('n', '<C-c>', api.fs.copy.node, opts('Copy file'))
  vim.keymap.set('n', '<C-p>', api.fs.paste, opts('Paste file'))
  vim.keymap.set('n', '<C-x>', api.fs.cut, opts('Cut file'))
  vim.keymap.set('n', 'dd', api.fs.remove, opts('Delete'))
  vim.keymap.set('n', 'q', api.tree.close, opts('Close'))
end

require 'nvim-tree'.setup {
  on_attach = my_on_attach,
  respect_buf_cwd = true,
  view = {
    number = false,
    relativenumber = false,
    signcolumn = "no"
  },
  git = {
    ignore = false
  },
  renderer = {
    icons = {
      git_placement = "after"
    },
    indent_markers = {
      enable = true,
    },
  }
}
