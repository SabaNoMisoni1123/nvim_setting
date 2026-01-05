-- lazy.nvim bootstrap
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
local uv = vim.uv or vim.loop
if not uv.fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    lazyrepo,
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out,                            "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- colorscheme（local_colorscheme.lua があればそれを優先）
local colorscheme_cfg_path = vim.fn.stdpath("config") .. "/local_colorscheme.lua"
local colorspec

if vim.fn.filereadable(colorscheme_cfg_path) == 1 then
  local cfg = dofile(colorscheme_cfg_path)
  colorspec = {
    cfg.repo,
    event = "UIEnter",
    priority = 1000,
    config = function()
      if type(cfg.cmd) == "string" and cfg.cmd ~= "" then
        vim.cmd(cfg.cmd)
      end
    end,
  }
else
  colorspec = {
    "morhetz/gruvbox",
    event = "UIEnter",
    priority = 1000,
    config = function()
      vim.cmd("colorscheme gruvbox")
    end,
  }
end

require("lazy").setup({
    ---------------------------------------------------------------------------
    -- 基盤 / 見た目
    ---------------------------------------------------------------------------
    colorspec,

    {
      "nvim-tree/nvim-web-devicons",
      event = "VeryLazy",
      config = function()
        require("nvim-web-devicons").setup({
          override = {
            txt = { icon = "", color = "#89e051", cterm_color = "113", name = "Txt" },
            tex = { icon = "", color = "#3D6117", cterm_color = "22", name = "Tex" },
          },
        })
      end,
    },

    { "nvim-lua/plenary.nvim",   lazy = true },

    {
      "nvim-lualine/lualine.nvim",
      event = "VeryLazy",
      dependencies = { "nvim-tree/nvim-web-devicons" },
      config = function()
        require("lua_line")
      end,
    },

    ---------------------------------------------------------------------------
    -- Telescope
    ---------------------------------------------------------------------------
    {
      "nvim-telescope/telescope.nvim",
      version = "0.1.8",
      cmd = "Telescope",
      keys = {
        { "<Leader>ff", function() require("telescope.builtin").find_files() end,      desc = "Find files" },
        { "<Leader>fr", function() require("telescope.builtin").oldfiles() end,        desc = "Recent files" },
        { "<C-o>",      function() require("telescope.builtin").oldfiles() end,        desc = "Recent files" },
        { "<Leader>fc", function() require("telescope.builtin").command_history() end, desc = "Command history" },
        { "<Leader>fs", function() require("telescope.builtin").spell_suggest() end,   desc = "Spell suggest" },
        { "<Leader>fC", function() require("telescope.builtin").commands() end,        desc = "Commands" },
        { "<Leader>fg", function() require("telescope.builtin").live_grep() end,       desc = "Live grep" },
        { "<C-_>",      function() require("telescope.builtin").live_grep() end,       desc = "Live grep" },
        { "<Leader>fT", function() require("telescope.builtin").treesitter() end,      desc = "Treesitter" },
        { "<Leader>fq", function() require("telescope.builtin").quickfix() end,        desc = "Quickfix" },
        { "<Leader>fh", function() require("telescope.builtin").help_tags() end,       desc = "Help tags" },
        { "<Leader>fm", function() require("telescope.builtin").man_pages() end,       desc = "Man pages" },
        {
          "<Leader>fd",
          function() require("telescope.builtin").diagnostics({ bufnr = 0 }) end,
          desc = "Buffer diagnostics"
        },
        {
          "/",
          function() require("telescope.builtin").current_buffer_fuzzy_find() end,
          desc = "Fuzzy find in buffer"
        },
        {
          "<C-f>",
          function() require("telescope.builtin").current_buffer_fuzzy_find() end,
          desc = "Fuzzy find in buffer"
        },
        { "<C-t>", ":Telescope ", desc = "Telescope prompt" },
      },
      dependencies = {
        "nvim-lua/plenary.nvim",
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      },
      config = function()
        local actions = require("telescope.actions")
        require("telescope").setup({
          defaults = {
            mappings = {
              n = { ["q"] = actions.close, ["<esc>"] = actions.close },
              i = { ["<esc>"] = actions.close },
            },
            winblend = 15,
          },
          extensions = {
            fzf = { fuzzy = true, override_generic_sorter = true, override_file_sorter = true, case_mode = "smart_case" },
          },
        })
        pcall(require("telescope").load_extension, "fzf")
      end,
    },

    ---------------------------------------------------------------------------
    -- project.nvim
    ---------------------------------------------------------------------------
    {
      "ahmedkhalf/project.nvim",
      keys = {
        { "<Leader>fp", "<Cmd>Telescope projects<CR>", desc = "Projects" },
      },
      dependencies = { "nvim-telescope/telescope.nvim" },
      config = function()
        require("project_nvim").setup({
          detection_methods = { "pattern", "lsp" },
          patterns = { ".git", "package.json", ".textlintrc.js", ".textlintrc", "pyproject.toml", "Makefile", "README.md" },
          show_hidden = true,
          silent_chdir = true,
          scope_chdir = "global",
        })
        pcall(require("telescope").load_extension, "projects")
      end,
    },

    ---------------------------------------------------------------------------
    -- LSP
    ---------------------------------------------------------------------------
    {
      "neovim/nvim-lspconfig",
      event = { "BufReadPre", "BufNewFile" },
      dependencies = {
        "ray-x/lsp_signature.nvim",
      },
      config = function()
        require("lsp")
      end,
    },

    ---------------------------------------------------------------------------
    -- nvim-cmp
    ---------------------------------------------------------------------------
    {
      "hrsh7th/nvim-cmp",
      event = "InsertEnter",
      dependencies = {
        { "onsails/lspkind.nvim" },
        { "hrsh7th/cmp-nvim-lsp" },

        { "L3MON4D3/LuaSnip",                   build = "make install_jsregexp" },
        { "honza/vim-snippets" },

        { "saadparwaiz1/cmp_luasnip" },
        { "octaltree/cmp-look" },
        { "hrsh7th/cmp-omni" },
        { "hrsh7th/cmp-buffer" },
        { "hrsh7th/cmp-path" },
        { "hrsh7th/cmp-cmdline" },
        { "hrsh7th/cmp-nvim-lsp-signature-help" },
        {
          "uga-rosa/cmp-dictionary",
          config = function()
            require("cmp_dictionary").setup({
              dic = { ["*"] = "/usr/share/dict/words" },
              max_number_items = 50,
            })
          end,
        },
        { "yutkat/cmp-mocword" },
      },
      config = function()
        require("nvim_cmp")
      end,
    },

    ---------------------------------------------------------------------------
    -- codex
    ---------------------------------------------------------------------------
    {
      "johnseth97/codex.nvim",
      cmd = { "Codex", "CodexToggle" },
      config = function()
        require("codex").setup({
          keymaps = { toggle = nil, quit = "<C-w>" },
          border = "single",
          width = 0.8,
          height = 0.8,
          model = nil,
          autoinstall = true,
        })
      end,
    },

    ---------------------------------------------------------------------------
    -- filer
    ---------------------------------------------------------------------------
    {
      "nvim-tree/nvim-tree.lua",
      cmd = { "NvimTreeToggle", "NvimTreeOpen", "NvimTreeFocus", "NvimTreeFindFile" },
      keys = {
        { "<C-n>",     "<Cmd>NvimTreeToggle<CR>", desc = "Toggle NvimTree" },
        { "<Leader>d", "<Cmd>NvimTreeToggle<CR>", desc = "Toggle NvimTree" },
      },
      dependencies = { "nvim-tree/nvim-web-devicons" },
      config = function()
        require("nvim_tree")
      end,
    },

    ---------------------------------------------------------------------------
    -- treesitter
    ---------------------------------------------------------------------------
    {
      "nvim-treesitter/nvim-treesitter",
      branch = "master",
      build = ":TSUpdate",
      event = "VeryLazy",
      config = function()
        local ok, configs = pcall(require, "nvim-treesitter.configs")
        if not ok then
          vim.notify("nvim-treesitter.configs not found (check install)", vim.log.levels.ERROR)
          return
        end
        configs.setup({
          ensure_installed = { "c", "cpp", "python", "markdown" },
          sync_install = false,
          auto_install = false,
          ignore_install = { "tex", "latex" },
          highlight = {
            enable = true,
            disable = { "tex", "latex" },
            additional_vim_regex_highlighting = false,
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
          indent = { enable = false },
        })
      end,
    },

    ---------------------------------------------------------------------------
    -- overseer
    ---------------------------------------------------------------------------
    {
      "stevearc/overseer.nvim",
      cmd = {
        "OverseerOpen",
        "OverseerClose",
        "OverseerToggle",
        "OverseerSaveBundle",
        "OverseerLoadBundle",
        "OverseerDeleteBundle",
        "OverseerRunCmd",
        "OverseerRun",
        "OverseerInfo",
        "OverseerBuild",
        "OverseerQuickAction",
        "OverseerTaskAction ",
        "OverseerClearCache",
      },
      keys = {
        { "<Leader>x", "<Cmd>OverseerRun<CR>",    desc = "Run task" },
        { "<Leader>o", "<Cmd>OverseerToggle<CR>", desc = "Toggle task list" },
      },
      config = function()
        require("overseer").setup({
          templates = {
            "markdown2html",
            "python",
            "builtin",
          }
        })
      end,
    },

    ---------------------------------------------------------------------------
    -- comment
    ---------------------------------------------------------------------------
    {
      "scrooloose/nerdcommenter",
      keys = {
        { "<Leader>c<Leader>", "<Plug>NERDCommenterToggle", mode = { "n", "v" }, desc = "Toggle comment" },
      },
      init = function()
        vim.g.NERDCreateDefaultMappings = 0
      end,
      config = function()
        vim.g.NERDSpaceDelims = 1
        vim.g.NERDDefaultAlign = "left"
        vim.g.NERDCreateDefaultMappings = 0
        vim.keymap.set("n", "<Leader>c<Leader>", "<Plug>NERDCommenterToggle", { remap = true })
        vim.keymap.set("v", "<Leader>c<Leader>", "<Plug>NERDCommenterToggle", { remap = true })
      end,
    },

    {
      "folke/todo-comments.nvim",
      dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
      cmd = { "TodoTelescope", "TodoQuickFix", "TodoLocList" },
      keys = {
        { "<Leader>ft", "<Cmd>TodoTelescope<CR>", desc = "TodoTelescope" },
      },
      config = function()
        require("todo-comments").setup({
          signs = true,
          sign_priority = 8,
          keywords = {
            FIX  = { icon = "", color = "error", alt = { "FIXME", "BUG", "FIXIT", "ISSUE" } },
            TODO = { icon = "", color = "info" },
            HACK = { icon = "", color = "warning" },
            WARN = { icon = "", color = "warning", alt = { "WARNING", "XXX" } },
            PERF = { icon = "", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
            NOTE = { icon = "", color = "hint", alt = { "INFO", "MEMO", "HINT" } },
            TEST = { icon = "", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
          },
        })
      end,
    },

    {
      "lukas-reineke/indent-blankline.nvim",
      event = "VeryLazy",
      dependencies = { "nvim-treesitter/nvim-treesitter" },
      config = function()
        require("ibl").setup({ indent = { char = "|" } })
      end,
    },

    ---------------------------------------------------------------------------
    -- ctag
    ---------------------------------------------------------------------------
    { "soramugi/auto-ctags.vim", lazy = true },

    {
      "preservim/tagbar",
      keys = {
        { "<Leader>t", "<Cmd>TagbarToggle<CR>", desc = "Tagbar" },
      },
      dependencies = { "soramugi/auto-ctags.vim" },
      config = function()
        vim.g.tagbar_map_togglesort = "S"
        vim.g.tagbar_map_togglepause = "T"
        vim.g.tagbar_map_toggleautoclose = "C"
        vim.g.auto_ctags_set_tags_option = 1
        vim.g.tagbar_width = 30
        vim.cmd([[
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
      ]])
      end,
    },

    ---------------------------------------------------------------------------
    -- git
    ---------------------------------------------------------------------------
    {
      "petertriho/nvim-scrollbar",
      cmd = { "ScrollbarToggle" },
      keys = {
        { "<C-s>", "<Cmd>ScrollbarToggle<CR>", desc = "Toggle Scrollbar" },
      },
      config = function()
        require("scrollbar").setup({
          show_in_active_only = false,
          set_highlights = true,
          folds = 1000,
          max_lines = false,
          hide_if_all_visible = false,
          throttle_ms = 100,
          handle = {
            text = " ",
            blend = 30,
            color = nil,
            color_nr = nil,
            highlight = "CursorColumn",
            hide_if_all_visible = true,
          },
        })
      end,
    },

    {
      "lewis6991/gitsigns.nvim",
      event = "VeryLazy",
      dependencies = { "petertriho/nvim-scrollbar" },
      config = function()
        require("gitsigns").setup({
          signs = {
            add          = { text = "│" },
            change       = { text = "│" },
            delete       = { text = "_" },
            topdelete    = { text = "‾" },
            changedelete = { text = "~" },
            untracked    = { text = "┆" },
          },
        })
        pcall(function()
          require("scrollbar.handlers.gitsigns").setup()
        end)
      end,
    },

    {
      "TimUntersberger/neogit",
      cmd = { "Neogit" },
      dependencies = { "nvim-lua/plenary.nvim" },
      keys = {
        { "<Leader>gs", "<Cmd>Neogit<CR>", desc = "Neogit" },
      },
      config = function()
        require("neogit").setup({ disable_insert_on_commit = true })
      end,
    },

    {
      "akinsho/git-conflict.nvim",
      cmd = {
        "GitConflictChooseOurs", "GitConflictChooseTheirs",
        "GitConflictChooseBoth", "GitConflictChooseNone",
        "GitConflictNextConflict", "GitConflictPrevConflict",
        "GitConflictEnable",
      },
      config = function()
        require("git-conflict").setup({})
      end,
    },

    {
      "sindrets/diffview.nvim",
      keys = {
        { "<Leader>gd", "<Cmd>DiffviewOpen<CR>",  desc = "DiffviewOpen" },
        { "<Leader>gq", "<Cmd>DiffviewClose<CR>", desc = "DiffviewClose" },
      },
      dependencies = { "nvim-lua/plenary.nvim" },
    },

    ---------------------------------------------------------------------------
    -- translate / memo / utility
    ---------------------------------------------------------------------------
    {
      "voldikss/vim-translator",
      cmd = "Translate",
      keys = {
        { "<Leader>x", ":'<,'>Translate<CR>", mode = { "v", "x" }, desc = "Translate selection" },
      },
      init = function()
        vim.g.translator_target_lang = "ja"
        vim.g.translator_default_engines = { "google" }
        vim.g.translator_window_type = "popup"
        vim.g.translator_window_max_width = 0.6
        vim.g.translator_window_max_height = 0.6
      end,
    },
    {
      "potamides/pantran.nvim",
      cmd = { "Pantran", "PantranSmart", "PantranEngine" },
      config = function()
        require("pantran_config").setup()
      end,
    },

    {
      "glidenote/memolist.vim",
      keys = {
        { "<Leader><Leader>mn", "<Cmd>MemoNew<CR>",  desc = "MemoNew" },
        { "<Leader><Leader>ml", "<Cmd>MemoList<CR>", desc = "MemoList" },
        { "<Leader><Leader>mg", "<Cmd>MemoGrep<CR>", desc = "MemoGrep" },
      },
      config = function()
        vim.g.memolist_path                 = "$MEMO_DIR"
        vim.g.memolist_memo_date            = "%Y%m%d-%H%M"
        vim.g.memolist_vimfiler_option      = "-split -winwidth=50 -simple"
        vim.g.memolist_memo_suffix          = "md"
        vim.g.memolist_filename_date        = "%y%m%d_"
        vim.g.memolist_delimiter_yaml_start = "---"
        vim.g.memolist_delimiter_yaml_end   = "---"
      end,
    },

    { "junegunn/vim-easy-align", keys = { { "ga", mode = "x", desc = "EasyAlign" } } },
    { "cohama/lexima.vim",       event = "InsertEnter" },

    {
      "t9md/vim-quickhl",
      keys = {
        { "<Leader>m", mode = "n", desc = "Quickhl mark" },
        { "<Leader>m", mode = "x", desc = "Quickhl mark" },
      },
      config = function()
        vim.keymap.set("n", "<Leader>m", "<Plug>(quickhl-manual-this)", { noremap = true })
        vim.keymap.set("x", "<Leader>m", "<Plug>(quickhl-manual-this)", { noremap = true })
        vim.keymap.set("n", "<Leader>M", "<Plug>(quickhl-manual-reset)", { noremap = true })
        vim.keymap.set("x", "<Leader>M", "<Plug>(quickhl-manual-reset)", { noremap = true })
      end,
    },

    {
      "easymotion/vim-easymotion",
      keys = {
        { "<Leader>e",  "<Plug>(easymotion-prefix)", desc = "EasyMotion" },
        { "<Leader>ed", "<Plug>(easymotion-bd-w)",   desc = "EasyMotion word" },
      },
    },

    {
      "tyru/open-browser.vim",
      keys = {
        { "<Leader>b", "<Plug>(openbrowser-smart-search)", mode = "n", desc = "OpenBrowser search" },
        { "<Leader>b", "<Plug>(openbrowser-smart-search)", mode = "x", desc = "OpenBrowser search" },
      },
    },

    { "gpanders/editorconfig.nvim", event = { "BufReadPost", "BufNewFile" } },

    ---------------------------------------------------------------------------
    -- filetype
    ---------------------------------------------------------------------------
    {
      "lervag/vimtex",
      ft = { "tex" },
      init = function()
        vim.g.vimtex_syntax_conceal_disable = 1
        vim.g.vimtex_mappings_enabled = 0

        vim.g.vimtex_compiler_latexmk = {
          build_dir = "",
          callback = 1,
          continuous = 1,
          executable = "latexmk",
          hooks = {},
          options = {
            "-verbose",
            "-file-line-error",
            "-synctex=1",
            "-interaction=nonstopmode",
            "-interaction=nonstopmode",
          },
        }

        vim.g.vimtex_quickfix_ignore_filters = {
          "Font Warning",
          "Underfull",
        }

        local ostype = vim.loop.os_uname().sysname
        if ostype == "Darwin" then
          vim.g.vimtex_view_method = "skim"
          vim.g.vimtex_view_skim_sync = 1
          vim.g.vimtex_view_skim_activate = 1
        elseif ostype == "Linux" then
          if vim.fn.executable("zathura") == 1 then
            vim.g.vimtex_view_method = "zathura"
          else
            vim.g.vimtex_view_method = "general"
            vim.g.vimtex_view_general_viewer = "evince"
          end
        end
      end,
      config = function()
        vim.keymap.set("n", "<localLeader>ll", "<Plug>(vimtex-compile)", { remap = true, silent = true })
        vim.keymap.set("n", "<localLeader>lv", "<Plug>(vimtex-view)", { remap = true, silent = true })
      end,
    },

    {
      "mattn/emmet-vim",
      event = "InsertEnter",
      ft = { "html", "htm", "md", "markdown", "vue" },
      init = function()
        vim.g.user_emmet_leader_key = ",,"
      end,
    },

    {
      "plasticboy/vim-markdown",
      ft = { "markdown" },
      config = function()
        vim.g.vim_markdown_no_default_key_mappings = 1
        vim.g.vim_markdown_conceal = 0
        vim.g.vim_markdown_conceal_code_blocks = 0
        vim.g.vim_markdown_math = 1
        vim.g.vim_markdown_new_list_item_indent = 0
      end,
    },

    {
      "dkarter/bullets.vim",
      ft = { "markdown", "text", "gitcommit" },
      init = function()
        vim.g.bullets_set_mappings = 0
        vim.cmd([[
        let g:bullets_enabled_file_types = [
          \ 'markdown',
          \ 'text',
          \ 'gitcommit',
          \]
      ]])
        vim.g.bullets_outline_levels = { "- " }
      end,
      config = function()
        vim.keymap.set("n", "o", "<Plug>(bullets-newline)", { noremap = true })
        vim.keymap.set("n", "<leader>cn", "<Plug>(bullets-renumber)", { noremap = true })
        vim.keymap.set("n", "<leader>cc", "<Plug>(bullets-toggle-checkbox)", { noremap = true })
        vim.keymap.set("n", ">", "<Plug>(bullets-demote)", { noremap = true })
        vim.keymap.set("n", "<", "<Plug>(bullets-promote)", { noremap = true })

        vim.keymap.set("v", "<leader>cn", "<Plug>(bullets-renumber)", { noremap = true })
        vim.keymap.set("v", ">", "<Plug>(bullets-demote)", { noremap = true })
        vim.keymap.set("v", "<", "<Plug>(bullets-promote)", { noremap = true })

        vim.keymap.set("i", "<cr>", "<Plug>(bullets-newline)", { noremap = true })
        vim.keymap.set("i", "<C-t>", "<Plug>(bullets-demote)", { noremap = true })
        vim.keymap.set("i", "<C-d>", "<Plug>(bullets-promote)", { noremap = true })
        vim.keymap.set("i", "<Tab>", "<Plug>(bullets-demote)", { noremap = true })
        vim.keymap.set("i", "<S-tab>", "<Plug>(bullets-promote)", { noremap = true })
      end,
    },

    {
      "iamcco/markdown-preview.nvim",
      ft = { "markdown" },
      cmd = { "MarkdownPreview", "MarkdownPreviewToggle", "MarkdownPreviewStop" },
      build = function()
        vim.fn["mkdp#util#install"]()
      end,
      init = function()
        vim.g.mkdp_filetypes = { "markdown" }
        vim.g.mkdp_markdown_css = vim.fn.stdpath("config") .. "/assets/my_style.css"
      end,
      -- copy cmd.exe to wsl env
    },

    -- {
    --   "HakonHarnes/img-clip.nvim",
    --   cmd = { "PasteImage", "ImgClipDebug", "ImgClipConfig" },
    --   keys = {
    --     { "<Leader>p", "<Cmd>PasteImage<CR>", desc = "Paste image from clipboard" },
    --   },
    --   opts = function()
    --     return require("img_clip").opts()
    --   end,
    -- },

    ---------------------------------------------------------------------------
    -- textobj 系（vimscript）
    ---------------------------------------------------------------------------
    { "kana/vim-textobj-user",      lazy = true },

    {
      "kana/vim-textobj-syntax",
      keys = { { "ay", mode = "o" }, { "iy", mode = "o" }, { "ay", mode = "v" }, { "iy", mode = "v" } },
      dependencies = { "kana/vim-textobj-user" },
      config = function()
        vim.keymap.set("o", "ay", "<Plug>(textobj-syntax-a)", { noremap = true })
        vim.keymap.set("o", "iy", "<Plug>(textobj-syntax-i)", { noremap = true })
        vim.keymap.set("v", "ay", "<Plug>(textobj-syntax-a)", { noremap = true })
        vim.keymap.set("v", "iy", "<Plug>(textobj-syntax-i)", { noremap = true })
      end,
    },

    {
      "thinca/vim-textobj-between",
      keys = { { "af", mode = "o" }, { "if", mode = "o" }, { "af", mode = "v" }, { "if", mode = "v" } },
      dependencies = { "kana/vim-textobj-user" },
      config = function()
        vim.g.textobj_between_no_default_key_mappings = 1
        vim.keymap.set("o", "af", "<Plug>(textobj-between-a)", { noremap = true })
        vim.keymap.set("o", "if", "<Plug>(textobj-between-i)", { noremap = true })
        vim.keymap.set("v", "af", "<Plug>(textobj-between-a)", { noremap = true })
        vim.keymap.set("v", "if", "<Plug>(textobj-between-i)", { noremap = true })
      end,
    },

    { "kana/vim-operator-user",            lazy = true },
    { "osyo-manga/vim-textobj-multiblock", lazy = true, dependencies = { "kana/vim-textobj-user" } },

    {
      "rhysd/vim-operator-surround",
      keys = {
        { "sa",  mode = "v" }, { "sd", mode = "v" }, { "sr", mode = "v" },
        { "sdd", mode = "n" }, { "srr", mode = "n" },
      },
      dependencies = { "kana/vim-operator-user", "osyo-manga/vim-textobj-multiblock" },
      config = function()
        vim.keymap.set("v", "sa", "<Plug>(operator-surround-append)", { noremap = true })
        vim.keymap.set("v", "sd", "<Plug>(operator-surround-delete)", { noremap = true })
        vim.keymap.set("v", "sr", "<Plug>(operator-surround-replace)", { noremap = true })
        vim.keymap.set("n", "sdd", "<Plug>(operator-surround-delete)<Plug>(textobj-multiblock-a)", { noremap = true })
        vim.keymap.set("n", "srr", "<Plug>(operator-surround-replace)<Plug>(textobj-multiblock-a)", { noremap = true })
      end,
    },

    {
      "kana/vim-textobj-entire",
      keys = {
        { "av", mode = "o" }, { "iv", mode = "o" },
        { "av", mode = "v" }, { "iv", mode = "v" },
      },
      dependencies = { "kana/vim-textobj-user" },
    },

    { "fuenor/jpmoveword.vim", event = { "BufReadPost", "BufNewFile" } },
  },
  {
    ui = { border = "single" },
    rocks = { enabled = false },
    ---------------------------------------------------------------------------
    -- runtime標準pluginの無効化
    ---------------------------------------------------------------------------
    performance = {
      cache = { enabled = true },
      reset_packpath = true,
      rtp = {
        reset = true,
        disabled_plugins = {
          "gzip",
          "tarPlugin",
          "zipPlugin",
          "tohtml",
          "tutor",
          "man",
          "netrwPlugin",
          "matchit",
          -- "matchparen",
          -- "shada",
          -- "spellfile",
          -- "rplugin",
          -- "osc52",
        },
      },
    },
  })
