-- setting
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
-- move to plugins.lua

-- local builtin = require('telescope.builtin')
-- local bufopts = { noremap = true, silent = true }
-- vim.keymap.set('n', '<C-t>', ':Telescope ', {noremap=true})
-- vim.keymap.set('n', '<leader>ff', builtin.find_files, bufopts)
-- vim.keymap.set('n', '<leader>fr', builtin.oldfiles, bufopts)
-- vim.keymap.set('n', '<leader>fc', builtin.command_history, bufopts)
-- vim.keymap.set('n', '<leader>fs', builtin.spell_suggest, bufopts)
-- vim.keymap.set('n', '<leader>fC', builtin.commands, bufopts)
-- vim.keymap.set('n', '<leader>fg', builtin.live_grep, bufopts)
-- vim.keymap.set('n', '<leader>fT', builtin.treesitter, bufopts)
-- vim.keymap.set('n', '<leader>fq', builtin.quickfix, bufopts)
-- vim.keymap.set('n', '<leader>fh', builtin.help_tags, bufopts)
-- vim.keymap.set('n', '<leader>fm', builtin.man_pages, bufopts)
-- vim.keymap.set('n', '/', builtin.current_buffer_fuzzy_find, bufopts)
-- vim.keymap.set('n', '<leader>fd', function() builtin.diagnostics({ bufnr = 0 }) end, bufopts)
