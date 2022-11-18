require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "M",
      node_incremental = "M",
      scope_incremental = "S",
      node_decremental = "m",
    },
  },
  indent = {
    enable = false
  },
  auto_install = true,
}
