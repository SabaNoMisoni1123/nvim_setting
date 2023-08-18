vim.opt.signcolumn = "yes"
vim.opt.timeoutlen = 400
vim.opt.updatetime = 100
vim.opt.cursorline = true
vim.opt.encoding = 'utf-8'
vim.opt.fileencodings = 'utf-8,ios-2022-jp,euc-jp,sjis,cp932'
vim.opt.nf = "alpha,octal,hex,bin"
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.hlsearch = false
vim.opt.wrapscan = false
vim.opt.relativenumber = true
vim.opt.showtabline = 2
vim.opt.laststatus = 2
vim.opt.winblend = 15
vim.opt.pumblend = 15
vim.opt.termguicolors = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.inccommand = "split"
vim.opt.foldlevel = 99
vim.opt.foldmethod = "indent"
vim.opt.list = true
vim.opt.listchars = { tab = '»-', trail = '~', extends = '»', precedes = '«', nbsp = '%' }
vim.opt.ambiwidth = "double"
vim.opt.backspace = "eol,indent,start"
vim.opt.wildmode = "list:full"
vim.opt.wildignore = vim.opt.wildignore + { '*.o', '*.obj', '*.pyc', '*.so', '*.dll' }
vim.opt.mouse = "a"
vim.opt.conceallevel = 0
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.matchpairs:append { "「:」", "（:）" }
vim.opt.formatoptions:append { "mM" }
vim.opt.clipboard:append { 'unnamedplus' }
vim.opt.sessionoptions:remove { "buffers" }
vim.opt.completeopt:remove { "preview" }
vim.o.shada = "!,'100,<0,s10,h,%0"



vim.opt.backupdir = os.getenv("XDG_CONFIG_HOME") .. "/nvim/tmp"
vim.opt.directory = os.getenv("XDG_CONFIG_HOME") .. "/nvim/tmp"
vim.opt.undodir = os.getenv("XDG_CONFIG_HOME") .. "/nvim/tmp"
vim.opt.viewdir = os.getenv("XDG_CONFIG_HOME") .. "/nvim/tmp"

vim.g.tex_flavor = "latex"
