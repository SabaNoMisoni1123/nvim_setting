-- default setting
require("telescope").setup{
  defaults = {
    mappings = {
      n = {
        ["q"] = require("telescope.actions").close,
        ["<esc>"] = require("telescope.actions").close,
      },
      i = {
        ["<esc>"] = require("telescope.actions").close,
      },
    },
  },
}

-- keymap
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fr', builtin.oldfiles, {})
vim.keymap.set('n', '<leader>fc', builtin.commands, {})
