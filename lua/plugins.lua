-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
-- vim.cmd [[packadd packer.nvim]]

vim.cmd('packadd packer.nvim')

return require('packer').startup(function(use)
  -- package manager
  use 'wbthomason/packer.nvim'

  -- lua support
  use 'nvim-lua/plenary.nvim'

  -- colorscheme
  use {
    'morhetz/gruvbox',
    config = function()
      vim.cmd 'colorscheme gruvbox'
    end,
  }

  -- line
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons' },
    config = function() require("lua_line") end,
  }

  -- lsp
  use {
    'neovim/nvim-lspconfig',
    opt = true,
    event = { 'BufRead', 'InsertEnter', 'CmdlineEnter' },
    config = function() require("lsp") end,
    wants = { 'lsp_signature.nvim', 'nlsp-settings.nvim', 'telescope.nvim', 'nvim-cmp' },
    requires = {
      { 'ray-x/lsp_signature.nvim', opt = true },
      { 'tamago324/nlsp-settings.nvim', opt = true },
      { 'nvim-telescope/telescope.nvim', opt = true },
      { 'hrsh7th/nvim-cmp', opt = true },
    },
  }

  -- auto complete
  use {
    'hrsh7th/nvim-cmp',
    wants = { "LuaSnip", 'lspkind.nvim' },
    requires = {
      { 'onsails/lspkind.nvim', opt = true },
      { 'L3MON4D3/LuaSnip', opt = true },
    },
    opt = true,
    event = { 'InsertEnter', 'CmdlineEnter' },
    config = function()
      require("nvim_cmp")
    end,
  }
  use { 'saadparwaiz1/cmp_luasnip', opt = true, after = 'nvim-cmp' }
  use { 'octaltree/cmp-look', opt = true, after = 'nvim-cmp' }
  use { 'hrsh7th/cmp-omni', opt = true, after = 'nvim-cmp' }
  use { 'hrsh7th/cmp-nvim-lsp', opt = true, after = 'nvim-cmp' }
  use { 'hrsh7th/cmp-buffer', opt = true, after = 'nvim-cmp' }
  use { 'hrsh7th/cmp-path', opt = true, after = 'nvim-cmp' }
  use { 'hrsh7th/cmp-cmdline', opt = true, after = 'nvim-cmp' }
  use { 'hrsh7th/cmp-nvim-lsp-signature-help', opt = true, after = 'nvim-cmp' }
  use {
    'uga-rosa/cmp-dictionary',
    after = 'nvim-cmp',
    config = function()
      require("cmp_dictionary").setup({
        dic = {
          -- If you always use the English dictionary, The following settings are suitable:
          ["*"] = "/usr/share/dict/words",
        },
        max_items = 50,
      })
    end,
  }

  -- fuzzy finder
  use {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    wants = { "telescope-fzf-native.nvim" },
    requires = { 'nvim-telescope/telescope-fzf-native.nvim', opt = true, run = 'make' },
    config = function() require("tele_scope") end,
    opt = true,
    keys = { { 'n', '<Space>' }, { 'n', '<C-t>' } },
  }

  -- filer
  use {
    'kyazdani42/nvim-tree.lua',
    config = function() require("nvim_tree") end,
    opt = true,
    event = { 'InsertEnter', 'CmdlineEnter', 'CursorHold' },
  }

  -- tree sitter
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    opt = true,
    event = { "BufRead" },
    config = function()
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
    end,
  }

  -- quick run
  use {
    'thinca/vim-quickrun',
    opt = true,
    keys = { '<space>x', '<space><space>x' },
    config = function()
      local bufopts = { noremap = false }
      vim.keymaps.set('n', '<leader>x', ':Quickrun', bufopts)
      vim.keymaps.set('n', '<leader><leader>x', ':Quickrun ', bufopts)
      vim.cmd('source ' .. os.getenv("XDG_CONFIG_HOME") .. '/nvim/vimscript/quickrun_setting.vim')
    end,
  }

end)
