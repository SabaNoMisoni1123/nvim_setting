vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true

-- mapping
local bufopts = { noremap = true, silent = true }
for k, v in pairs({
  ['<leader>d'] = '<Cmd>NvimTreeToggle expand(\'%:p:h\')<CR>',
  ['<leader>n'] = '<Cmd>NvimTreeFocus<CR>',
}) do
  vim.keymap.set('n', k, v, bufopts)
end

require 'nvim-tree'.setup {
  respect_buf_cwd = true,
  remove_keymaps = true,
  view = {
    mappings = {
      list = {
        { key = { "<CR>", "o", "<2-LeftMouse>" }, action = "edit" },
        { key = "h", action = "dir_up" },
        { key = "l", action = "cd" },
        { key = ".", action = "toggle_dotfiles" },
        { key = "<C-s>", action = "split" },
        { key = "<C-v>", action = "vsplit" },
        { key = "<C-t>", action = "tabnew" },
        { key = "K", action = "create" },
        { key = "x", action = "system_open" },
        { key = "C", action = "cut" },
        { key = "P", action = "paste" },
        { key = "p", action = "preview" },
        { key = "r", action = "rename" },
        { key = "yy", action = "copy_absolute_path" },
        { key = "dd", action = "remove" },
        { key = "q", action = "close" }
      }
    },
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
