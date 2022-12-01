" tmux cursor shape setting
if exists('$TMUX')
  let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
  let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
  let &t_SI = "\<Esc>]50;CursorShape=1\x7"
  let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif

" if you can't type quickly, change this.
set timeoutlen=400

" update quickly
set updatetime=100

" show cursor line
set cursorline

" shada=viminfo
set shada=!,'100,<0,s10,h,%0

" do not include buffer info in session
set sessionoptions-=buffers

" file encoding
set encoding=utf-8 fileencodings=utf-8,ios-2022-jp,euc-jp,sjis,cp932

" assign temporary file
set backupdir=~/.config/nvim/tmp//
set directory=~/.config/nvim/tmp//
set undodir=~/.config/nvim/tmp//
set viewdir=~/.config/nvim/tmp//

" don't use preview window; I prefer popup/floating window
set completeopt-=preview

set nf=alpha,octal,hex,bin

" search settings
set ignorecase
set smartcase
set incsearch
set nohlsearch
set nowrapscan

" line number settings
" set number
set relativenumber

" always show finetabline,statusline
set showtabline=2 laststatus=2

" transparent popup window
set winblend=8 pumblend=30

" tab settings
set tabstop=2 shiftwidth=2
set expandtab smartindent

"日本語(マルチバイト文字)行の連結時には空白を入力しない
setlocal formatoptions+=mM

" show the result of command with split window
set inccommand=split

" don't fold by default
set foldlevel=99
" reserve two columns for fold
" set foldcolumn=2

" listchar settings
set list listchars=tab:»-,trail:~,extends:»,precedes:«,nbsp:%

" show double width characters properly
set ambiwidth=double

set backspace=eol,indent,start

set wildmenu
set wildmode=list:full
set wildignore=*.o,*.obj,*.pyc,*.so,*.dll

let g:python_highlight_all = 1

set clipboard+=unnamedplus

" use termdebug
packadd termdebug

set mouse=a

" 追加設定
set conceallevel=0

" 分割の位置
set splitbelow
set splitright

" .tex setting
let g:tex_flavor = "latex"

augroup fileType
  autocmd!
  autocmd BufNewFile,BufRead *.grg    setlocal nowrap
  autocmd BufNewFile,BufRead *.jl     setfiletype julia
  autocmd BufNewFile,BufRead *.plt    setfiletype gnuplot
  autocmd BufNewFile,BufRead *.m      setfiletype matlab
  autocmd BufNewFile,BufRead *.csv    setfiletype csv
  autocmd BufNewFile,BufRead *.toml   setfiletype conf
augroup END

augroup Binary
  au!
  au BufReadPre   *.bin let &bin=1
  au BufReadPost  *.bin if &bin | %!xxd
  au BufReadPost  *.bin set ft=xxd | endif
  au BufWritePre  *.bin if &bin | %!xxd -r
  au BufWritePre  *.bin endif
  au BufWritePost *.bin if &bin | %!xxd
  au BufWritePost *.bin set nomod | endif

  au BufReadPre   *.pcap let &bin=1
  au BufReadPost  *.pcap if &bin | %!xxd
  au BufReadPost  *.pcap set ft=xxd | endif
  au BufWritePre  *.pcap if &bin | %!xxd -r
  au BufWritePre  *.pcap endif
  au BufWritePost *.pcap if &bin | %!xxd
  au BufWritePost *.pcap set nomod | endif

  au BufReadPre   *.npy let &bin=1
  au BufReadPost  *.npy if &bin | %!xxd
  au BufReadPost  *.npy set ft=xxd | endif
  au BufWritePre  *.npy if &bin | %!xxd -r
  au BufWritePre  *.npy endif
  au BufWritePost *.npy if &bin | %!xxd
  au BufWritePost *.npy set nomod | endif

  au BufReadPre   *.pkl let &bin=1
  au BufReadPost  *.pkl if &bin | %!xxd
  au BufReadPost  *.pkl set ft=xxd | endif
  au BufWritePre  *.pkl if &bin | %!xxd -r
  au BufWritePre  *.pkl endif
  au BufWritePost *.pkl if &bin | %!xxd
  au BufWritePost *.pkl set nomod | endif
augroup END
