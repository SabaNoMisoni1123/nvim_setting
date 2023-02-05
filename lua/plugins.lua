vim.cmd('packadd packer.nvim')
-- vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- package manager
  use 'wbthomason/packer.nvim'

  -- icon
  use 'kyazdani42/nvim-web-devicons'

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
    config = function() require("lua_line") end,
    opt = true,
    event = { 'BufRead' },
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
    opt = true,
    event = { 'CursorHold', 'BufRead' },
    config = function()
      -- keymap
      local bufopts = { noremap = true, silent = true }
      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<Leader>ff', builtin.find_files, bufopts)
      vim.keymap.set('n', '<Leader>fr', builtin.oldfiles, bufopts)
      vim.keymap.set('n', '<Leader>fc', builtin.command_history, bufopts)
      vim.keymap.set('n', '<Leader>fs', builtin.spell_suggest, bufopts)
      vim.keymap.set('n', '<Leader>fC', builtin.commands, bufopts)
      vim.keymap.set('n', '<Leader>fg', builtin.live_grep, bufopts)
      vim.keymap.set('n', '<Leader>fT', builtin.treesitter, bufopts)
      vim.keymap.set('n', '<Leader>fq', builtin.quickfix, bufopts)
      vim.keymap.set('n', '<Leader>fh', builtin.help_tags, bufopts)
      vim.keymap.set('n', '<Leader>fm', builtin.man_pages, bufopts)
      vim.keymap.set('n', '<Leader>fd', function() builtin.diagnostics({ bufnr = 0 }) end,
        bufopts)
      vim.keymap.set('n', '/', builtin.current_buffer_fuzzy_find, bufopts)

      vim.keymap.set('n', '<C-t>', ':Telescope ', { noremap = true })

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
    end,
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
    cmd = { "QuickRun" },
    setup = function()
      local bufopts = { noremap = true, buffer = 0 }
      vim.keymap.set('n', '<Leader>x', '<Cmd>QuickRun<CR>', bufopts)
      vim.keymap.set('n', '<Leader><Leader>x', ':QuickRun ', bufopts)
    end,
    config = function()
      vim.cmd('source ' .. os.getenv("XDG_CONFIG_HOME") .. '/nvim/vimscripts/quickrun_setting.vim')
    end,
  }

  -- comment
  use {
    'scrooloose/nerdcommenter',
    opt = true,
    -- event = { 'BufRead' },
    keys = { { 'n', '<Leader>c<Leader>' }, { 'v', '<Leader>c<Leader>' } },
    config = function()
      local bufopts = { noremap = true, buffer = 0 }
      vim.g.NERDSpaceDelims = 1
      vim.g.NERDDefaultAlign = 'left'
      vim.g.NERDCreateDefaultMappings = 0
      vim.keymap.set('n', '<Leader>c<Leader>', '<Plug>NERDCommenterToggle', bufopts)
      vim.keymap.set('v', '<Leader>c<Leader>', '<Plug>NERDCommenterToggle', bufopts)
    end,
  }
  use {
    'folke/todo-comments.nvim',
    opt = true,
    requires = { 'nvim-telescope/telescope.nvim', opt = true },
    event = { 'BufRead' },
    config = function()
      local bufopts = { noremap = true, buffer = 0 }
      vim.keymap.set('n', '<Leader>ft', '<Cmd>TodoTelescope<CR>', bufopts)

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
    keys = { { 'n', '<Space>t' } },
    requires = { 'soramugi/auto-ctags.vim' },
    setup = function()
      local bufopts = { noremap = true, buffer = 0 }
      vim.keymap.set('n', '<Leader>t', '<Cmd>TagbarToggle<CR>', bufopts)
      vim.g.tagbar_map_togglesort = "S"
      vim.g.tagbar_map_togglepause = "T"
      vim.g.tagbar_map_toggleautoclose = "C"
      vim.g.auto_ctags_set_tags_option = 1
      vim.g.tagbar_width = 30
    end,
    config = function()
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

  -- git
  use {
    'airblade/vim-gitgutter',
    opt = true,
    event = { 'InsertEnter', 'CmdlineEnter', 'CursorHold' },
    config = function()
      vim.g.gitgutter_preview_win_floating = 0
      vim.g.gitgutter_map_keys = 0

      local bufopts = { noremap = true, buffer = 0 }
      vim.keymap.set('n', '<Leader>hs', '<Plug>(GitGutterStageHunk)', bufopts)
      vim.keymap.set('n', '<Leader>hu', '<Plug>(GitGutterUndoHunk)', bufopts)
      vim.keymap.set('n', '<Leader>hp', '<Plug>(GitGutterPreviewHunk)', bufopts)
      vim.keymap.set('n', ']h', '<Plug>(GitGutterNextHunk)', bufopts)
      vim.keymap.set('n', '[h', '<Plug>(GitGutterPrevHunk)', bufopts)

      vim.keymap.set('o', 'ih', '<Plug>(GitGutterTextObjectInnerPending)', bufopts)
      vim.keymap.set('o', 'ah', '<Plug>(GitGutterTextObjectOuterPending)', bufopts)

      vim.keymap.set('x', 'ih', '<Plug>(GitGutterTextObjectInnerVisual)', bufopts)
      vim.keymap.set('x', 'ah', '<Plug>(GitGutterTextObjectOuterVisual)', bufopts)
    end,
  }
  use {
    'tpope/vim-fugitive',
    opt = true,
    event = { 'InsertEnter', 'CmdlineEnter', 'CursorHold' },
    config = function()
      local bufopts = { noremap = true, buffer = 0 }
      vim.keymap.set('n', '<Leader>gs', '<CMD>Git<CR>', bufopts)
      vim.keymap.set('n', '<Leader>ga', '<CMD>Gwrite<CR>', bufopts)
      vim.keymap.set('n', '<Leader>gc', '<CMD>Git commit<CR>', bufopts)
      vim.keymap.set('n', '<Leader>gb', '<CMD>Git blame<CR>', bufopts)
      vim.keymap.set('n', '<Leader>gl', '<CMD>Gclog<CR>', bufopts)
      vim.keymap.set('n', '<Leader>gp', '<CMD>Gpush<CR>', bufopts)
      vim.keymap.set('n', '<Leader>gf', '<CMD>Gfetch<CR>', bufopts)
      vim.keymap.set('n', '<Leader>gd', '<CMD>Gvdiffsplit<CR>', bufopts)
      vim.keymap.set('n', '<Leader>gr', '<CMD>Git rebase<CR>', bufopts)
      vim.keymap.set('n', '<Leader>gg', '<CMD>Glgrep ""<Left>', bufopts)
      vim.keymap.set('n', '<Leader>gm', '<CMD>Git merge', bufopts)
    end,
  }

  -- translate
  use {
    'skanehira/translate.vim',
    opt = true,
    event = { 'InsertEnter', 'CmdlineEnter', 'CursorHold' },
    config = function()
      vim.g.translate_source = 'en'
      vim.g.translate_target = 'ja'
      vim.g.translate_popup_window = 0
      vim.g.translate_winsize = 10

      local bufopts = { noremap = true }
      vim.keymap.set('v', '<Leader>x', '<Plug>(VTranslate)', bufopts)

      vim.api.nvim_create_user_command(
        'SwapTransrateLang',
        function()
          if vim.g.translate_source == 'en' then
            local tmp = vim.g.translate_source
            vim.g.translate_source = vim.g.translate_target
            vim.g.translate_target = tmp
          end
        end,
        { nargs = 0 }
      )

      vim.api.nvim_create_user_command(
        'CheckTransrateLang',
        function()
          print(vim.g.translate_source .. " > " .. vim.g.translate_target)
        end,
        { nargs = 0 }
      )
    end,
  }

  -- memo
  use { 'glidenote/memolist.vim',
    opt = true,
    cmd = { 'MemoNew', 'MemoList', 'MemoGrep' },
    setup = function()
      local bufopts = { noremap = true, buffer = 0 }
      vim.keymap.set('n', '<Leader><Leader>mn', '<Cmd>MemoNew<CR>', bufopts)
      vim.keymap.set('n', '<Leader><Leader>ml', '<Cmd>MemoList<CR>', bufopts)
      vim.keymap.set('n', '<Leader><Leader>mg', '<Cmd>MemoGrep<CR>', bufopts)
    end,
    config = function()
      vim.g.memolist_path                 = '$MEMO_DIR'
      vim.g.memolist_memo_date            = '%Y%m%d-%H%M'
      vim.g.memolist_vimfiler_option      = '-split -winwidth=50 -simple'
      vim.g.memolist_memo_suffix          = 'md'
      vim.g.memolist_filename_date        = '%y%m%d_'
      vim.g.memolist_delimiter_yaml_start = '---'
      vim.g.memolist_delimiter_yaml_end   = '---'

      vim.g.memolist_memo_suffix = 'md'
      vim.g.memolist_template_dir_path = os.getenv("XDG_CONFIG_HOME") .. '/nvim/template'
    end,
  }

  -- support writing tool
  use {
    'junegunn/vim-easy-align',
    opt = true,
    keys = { { 'x', 'ga' } },
    config = function()
      local bufopts = { noremap = true, buffer = 0 }
      vim.keymap.set('x', 'ga', '<Plug>(EasyAlign)', bufopts)
    end,
  }

  use {
    'cohama/lexima.vim',
    opt = true,
    event = { 'InsertEnter' },
  }

  use {
    't9md/vim-quickhl',
    opt = true,
    keys = { { 'n', '<Leader>m' }, { 'x', '<Leader>m' } },
    config = function()
      local bufopts = { noremap = true, buffer = 0 }
      vim.keymap.set('n', '<Leader>m', '<Plug>(quickhl-manual-this)', bufopts)
      vim.keymap.set('x', '<Leader>m', '<Plug>(quickhl-manual-this)', bufopts)
      vim.keymap.set('n', '<Leader>M', '<Plug>(quickhl-manual-reset)', bufopts)
      vim.keymap.set('x', '<Leader>M', '<Plug>(quickhl-manual-reset)', bufopts)
    end,
  }

  use {
    'easymotion/vim-easymotion',
    opt = true,
    keys = { { 'n', '<Leader>e' } },
    config = function()
      local bufopts = { noremap = true, buffer = 0 }
      vim.keymap.set('n', '<Leader>e', '<Plug>(easymotion-prefix)', bufopts)
    end,
  }

  -- other tool
  use {
    'tyru/open-browser.vim',
    opt = true,
    keys = { { 'n', '<Leader>b' }, { 'x', '<Leader>b' } },
    config = function()
      local bufopts = { noremap = true, buffer = 0 }
      vim.keymap.set('n', '<Leader>b', '<Plug>(openbrowser-smart-search)', bufopts)
      vim.keymap.set('x', '<Leader>b', '<Plug>(openbrowser-smart-search)', bufopts)
    end,
  }

  -- filetype

  -- tex
  use {
    'lervag/vimtex',
    opt = true,
    ft = { 'tex', 'cls' },
    config = function()
      local bufopts = { noremap = true, buffer = 0 }
      vim.keymap.set('n', '<localLeader>ll', '<Plug>(vimtex-compile)', bufopts)
      vim.keymap.set('n', '<localLeader>lv', '<Plug>(vimtex-view)', bufopts)

      vim.cmd('source ' .. os.getenv("XDG_CONFIG_HOME") .. '/nvim/vimscripts/vimtex.vim')
    end,
  }

  -- html / css / js
  use {
    'mattn/emmet-vim',
    opt = true,
    ft = { 'html', 'htm', 'md', 'markdown', 'vue' },
    config = function()
      vim.g.user_emmet_Leader_key = ',,'
    end,
  }

  use {
    'maksimr/vim-jsbeautify',
    opt = true,
    ft = { 'js', 'html', 'jsx', 'json', 'css' },
    config = function()
      vim.cmd [[
        augroup Beautifytype
          autocmd FileType javascript nnoremap <buffer> <Leader>aj :call JsBeautify()<cr>
          autocmd FileType json nnoremap <buffer> <Leader>aj :call JsonBeautify()<cr>
          autocmd FileType jsx nnoremap <buffer> <Leader>aj :call JsxBeautify()<cr>
          autocmd FileType html nnoremap <buffer> <Leader>aj :call HtmlBeautify()<cr>
          autocmd FileType css nnoremap <buffer> <Leader>aj :call CSSBeautify()<cr>
        augroup END
      ]]
    end,
  }

  -- markdown
  use {
    'plasticboy/vim-markdown',
    opt = true,
    ft = { 'markdown' },
    config = function()
      vim.g.vim_markdown_no_default_key_mappings = 1
      vim.g.vim_markdown_conceal = 0
      vim.g.vim_markdown_conceal_code_blocks = 0
      vim.g.vim_markdown_math = 1
      vim.g.vim_markdown_new_list_item_indent = 0
    end,
  }

  use {
    'dkarter/bullets.vim',
    opt = true,
    ft = { 'markdown', 'text', 'gitcommit' },
    config = function()
      vim.g.bullets_enable_in_empty_buffers = 0
      vim.g.bullets_set_mappings = 0
      vim.cmd [[
        let g:bullets_enabled_file_types = [
          \ 'markdown',
          \ 'text',
          \ 'gitcommit',
          \]

        let g:bullets_custom_mappings = [
          \ ['inoremap', '<cr>', '<Plug>(bullets-newline)'],
          \ ['inoremap', '<C-cr>', '<cr>'],
          \ ['nnoremap', 'o', '<Plug>(bullets-newline)'],
          \ ['vnoremap', '<Leader>cn', '<Plug>(bullets-renumber)'],
          \ ['nnoremap', '<Leader>cn', '<Plug>(bullets-renumber)'],
          \ ['nnoremap', '<Leader>cc', '<Plug>(bullets-toggle-checkbox)'],
          \ ['inoremap', '<C-t>', '<Plug>(bullets-demote)'],
          \ ['nnoremap', '>', '<Plug>(bullets-demote)'],
          \ ['vnoremap', '>', '<Plug>(bullets-demote)'],
          \ ['inoremap', '<C-d>', '<Plug>(bullets-promote)'],
          \ ['nnoremap', '<', '<Plug>(bullets-promote)'],
          \ ['vnoremap', '<', '<Plug>(bullets-promote)'],
          \ ]
      ]]
    end,
  }

  -- text object
  use {
    'kana/vim-textobj-syntax',
    opt = true,
    requires = { { 'kana/vim-textobj-user', opt = true } },
    wants = { 'vim-textobj-user' },
    keys = { { 'o', 'ay' }, { 'o', 'iy' }, { 'v', 'ay' }, { 'v', 'iy' } },
    config = function()
      local bufopts = { noremap = true, buffer = 0 }
      vim.keymap.set('o', 'ay', '<Plug>(textobj-syntax-a)', bufopts)
      vim.keymap.set('o', 'iy', '<Plug>(textobj-syntax-i)', bufopts)
      vim.keymap.set('v', 'ay', '<Plug>(textobj-syntax-a)', bufopts)
      vim.keymap.set('v', 'iy', '<Plug>(textobj-syntax-i)', bufopts)
    end,
  }

  use {
    'thinca/vim-textobj-between',
    opt = true,
    requires = { { 'kana/vim-textobj-user', opt = true } },
    wants = { 'vim-textobj-user' },
    keys = { { 'o', 'af' }, { 'o', 'if' }, { 'v', 'af' }, { 'v', 'if' } },
    config = function()
      vim.g.textobj_between_no_default_key_mappings = 1

      local bufopts = { noremap = true, buffer = 0 }
      vim.keymap.set('o', 'af', '<Plug>(textobj-between-a)', bufopts)
      vim.keymap.set('o', 'if', '<Plug>(textobj-between-i)', bufopts)
      vim.keymap.set('v', 'af', '<Plug>(textobj-between-a)', bufopts)
      vim.keymap.set('v', 'if', '<Plug>(textobj-between-i)', bufopts)
    end,
  }

  use {
    'osyo-manga/vim-textobj-multiblock',
    opt = true,
    after = { 'vim-operator-surround' },
    requires = { { 'kana/vim-textobj-user', opt = true } },
    wants = { 'vim-textobj-user' },
    keys = { { 'o', 'ab' }, { 'o', 'ib' }, { 'v', 'ab' }, { 'v', 'ib' } },
    config = function()
      local bufopts = { noremap = true, buffer = 0 }
      vim.keymap.set('o', 'ab', '<Plug>(textobj-multiblock-a)', bufopts)
      vim.keymap.set('o', 'ib', '<Plug>(textobj-multiblock-i)', bufopts)
      vim.keymap.set('v', 'ab', '<Plug>(textobj-multiblock-a)', bufopts)
      vim.keymap.set('v', 'ib', '<Plug>(textobj-multiblock-i)', bufopts)
    end,
  }

  use {
    'kana/vim-textobj-entire',
    opt = true,
    requires = { { 'kana/vim-textobj-user', opt = true } },
    wants = { 'vim-textobj-user' },
    keys = { { 'o', 'av' }, { 'o', 'iv' }, { 'v', 'av' }, { 'v', 'iv' } },
    config = function()
      vim.g.textobj_entire_no_default_key_mappings = 1

      local bufopts = { noremap = true, buffer = 0 }
      vim.keymap.set('o', 'av', '<Plug>(textobj-entire-a)', bufopts)
      vim.keymap.set('o', 'iv', '<Plug>(textobj-entire-i)', bufopts)
      vim.keymap.set('v', 'av', '<Plug>(textobj-entire-a)', bufopts)
      vim.keymap.set('v', 'iv', '<Plug>(textobj-entire-i)', bufopts)
    end,
  }

  use {
    'rhysd/vim-operator-surround',
    opt = true,
    requires = { { 'kana/vim-operator-user', opt = true }, { 'osyo-manga/vim-textobj-multiblock', opt = true } },
    wants = { 'vim-operator-user', 'vim-textobj-multiblock' },
    keys = { { 'v', 'sa' }, { 'v', 'sd' }, { 'v', 'sr' }, { 'n', 'sdd' }, { 'n', 'srr' } },
    config = function()
      vim.g.textobj_entire_no_default_key_mappings = 1

      local bufopts = { noremap = true, buffer = 0 }
      vim.keymap.set('v', 'sa', '<Plug>(operator-surround-append)', bufopts)
      vim.keymap.set('v', 'sd', '<Plug>(operator-surround-delete)', bufopts)
      vim.keymap.set('v', 'sr', '<Plug>(operator-surround-replace)', bufopts)

      vim.keymap.set('n', 'sdd', '<Plug>(operator-surround-delete)<Plug>(textobj-multiblock-a)', bufopts)
      vim.keymap.set('n', 'srr', '<Plug>(operator-surround-replace)<Plug>(textobj-multiblock-a)', bufopts)
    end,
  }

  use {
    'fuenor/jpmoveword.vim',
    opt = true,
    event = { 'BufRead' },
  }

end)
