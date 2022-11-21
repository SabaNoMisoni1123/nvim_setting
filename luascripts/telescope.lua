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
