-- default setting
require('telescope').setup {
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
    winblend = 15,
  },
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = "smart_case",
    }
  },
}

-- load extensions
require('telescope').load_extension('fzf')

-- keymap
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fr', builtin.oldfiles, {})
vim.keymap.set('n', '<leader>fc', builtin.command_history, {})
vim.keymap.set('n', '<leader>fs', builtin.spell_suggest, {})
vim.keymap.set('n', '<leader>fC', builtin.commands, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '/', builtin.current_buffer_fuzzy_find, {})
