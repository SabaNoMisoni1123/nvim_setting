require 'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    disable = { "tex", "latex" },
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "T",
      node_incremental = "M",
      scope_incremental = "S",
      node_decremental = "m",
    },
  },
  indent = {
    enable = false
  },
  auto_install = true,
  ignore_install = { "tex", "latex" },
}
