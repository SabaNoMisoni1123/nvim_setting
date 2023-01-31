vim.cmd('packadd packer.nvim')
-- vim.cmd [[packadd packer.nvim]]

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
    wants = { 'lsp_signature.nvim', 'nlsp-settings.nvim', 'telescope.nvim', 'nvim-cmp', 'cmp-nvim-lsp' },
    requires = {
      { 'ray-x/lsp_signature.nvim', opt = true },
      { 'tamago324/nlsp-settings.nvim', opt = true },
      { 'nvim-telescope/telescope.nvim', opt = true },
      { 'hrsh7th/nvim-cmp', opt = true },
      { 'hrsh7th/cmp-nvim-lsp', opt = true },
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
    keys = { ' x', '  x' },
    config = function()
      local bufopts = { noremap = false }
      vim.keymap.set('n', '<leader>x', '<Cmd>QuickRun<CR>', bufopts)
      vim.keymap.set('n', '<leader><leader>x', ':QuickRun ', bufopts)
      vim.cmd('source ' .. os.getenv("XDG_CONFIG_HOME") .. '/nvim/vimscripts/quickrun_setting.vim')
    end,
  }

  -- comment
  use {
    'scrooloose/nerdcommenter',
    opt = true,
    -- event = { 'BufRead' },
    keys = { { 'n', '<leader>c<leader>' }, { 'v', '<leader>c<leader>' } },
    config = function()
      local bufopts = { noremap = true }
      vim.g.NERDSpaceDelims = 1
      vim.g.NERDDefaultAlign = 'left'
      vim.g.NERDCreateDefaultMappings = 0
      vim.keymap.set('n', '<leader>c<leader>', '<Plug>NERDCommenterToggle', bufopts)
      vim.keymap.set('v', '<leader>c<leader>', '<Plug>NERDCommenterToggle', bufopts)
    end,
  }
  use {
    'folke/todo-comments.nvim',
    opt = true,
    requires = { 'nvim-telescope/telescope.nvim', opt = true },
    event = { 'BufRead' },
    config = function()
      local bufopts = { noremap = true }
      vim.keymap.set('n', '<leader>ft', '<Cmd>TodoTelescope<CR>', bufopts)

      require("todo-comments").setup {
        signs = true,
        sign_priority = 8,
        keywords = {
          FIX = {
            icon = "",
            color = "error",
            alt = { "FIXME", "BUG", "FIXIT", "ISSUE" },
          },
          TODO = { icon = "", color = "info" },
          HACK = { icon = "", color = "warning" },
          WARN = { icon = "", color = "warning", alt = { "WARNING", "XXX" } },
          PERF = { icon = "", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
          NOTE = { icon = "", color = "hint", alt = { "INFO", "MEMO", "HINT" } },
          TEST = { icon = "", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
        },
      }
    end,
  }

  -- indent line
  use {
    'lukas-reineke/indent-blankline.nvim',
    opt = true,
    event = { 'BufRead' },
    requires = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      vim.opt.list = true
      require("indent_blankline").setup {
        char = '|',
        use_treesitter = true,
        show_current_context = true,
        show_current_context_start = true,
        context_char = '|',
      }
    end,
  }

  -- ctag
  use {
    'preservim/tagbar',
    opt = true,
    keys = { { 'n', '<Leader>t' } },
    requires = { 'soramugi/auto-ctags.vim' },
    config = function()
      local bufopts = { noremap = true }
      vim.keymap.set('n', '<leader>t', '<Cmd>TagbarToggle<CR>', bufopts)
      vim.g.tagbar_map_togglesort = "S"
      vim.g.tagbar_map_togglepause = "T"
      vim.g.tagbar_map_toggleautoclose = "C"
      vim.g.auto_ctags_set_tags_option = 1
      vim.g.tagbar_width = 30
      vim.cmd [[
        let g:tagbar_type_go = {
          \ 'ctagstype' : 'go',
          \ 'kinds'     : [
          \   'p:package',
          \   'i:imports:1',
          \   'c:constants',
          \   'v:variables',
          \   't:types',
          \   'n:interfaces',
          \   'w:fields',
          \   'e:embedded',
          \   'm:methods',
          \   'r:constructor',
          \   'f:functions'
          \ ],
          \ 'sro' : '.',
          \ 'kind2scope' : {
          \   't' : 'ctype',
          \   'n' : 'ntype'
          \ },
          \ 'scope2kind' : {
          \   'ctype' : 't',
          \   'ntype' : 'n'
          \ },
          \ 'ctagsbin'  : 'gotags',
          \ 'ctagsargs' : '-sort -silent'
          \ }
      ]]
    end,
  }

  -- spell checker
  -- use {
  --   'kamykn/spelunker.vim',
  --   opt = true,
  --   ft = { 'markdown', 'latex', 'tex' }
  -- }



end)
