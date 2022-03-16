"key mapping

tnoremap <silent> <C-c> <C-\><C-n>

"move to the end of a text after copying/pasting it
vnoremap <silent> y y`]
vnoremap <silent> p p`]
nnoremap <silent> p p`]

" Space+something to move to an end
noremap <leader>h ^
noremap <leader>l $
noremap <leader>k gg
noremap <leader>j G

" unmap s,space
nnoremap s <Nop>
nnoremap <Space> <Nop>
" window control
nnoremap ss <Cmd>split<CR>
nnoremap sv <Cmd>vsplit<CR>
" st is used by defx
nnoremap sc <Cmd>tab sp<CR>
nnoremap sC <Cmd>-tab sp<CR>
nnoremap sj <C-w>j
nnoremap sk <C-w>k
nnoremap sl <C-w>l
nnoremap sh <C-w>h
nnoremap sJ <C-w>J
nnoremap sK <C-w>K
nnoremap sL <C-w>L
nnoremap sH <C-w>H
nnoremap sZ :tabnew<CR>:terminal<CR>
nnoremap sn <Cmd>tabn<CR>
nnoremap sp <Cmd>tabp<CR>
nnoremap s= <C-w>=
nnoremap sO <C-w>=
nnoremap so <C-w>_<C-w>\|
nnoremap sq <Cmd>tabc<CR>
nnoremap s1 <Cmd>1tabnext<CR>
nnoremap s2 <Cmd>2tabnext<CR>
nnoremap s3 <Cmd>3tabnext<CR>
nnoremap s4 <Cmd>4tabnext<CR>
nnoremap s5 <Cmd>5tabnext<CR>
nnoremap s6 <Cmd>6tabnext<CR>
nnoremap s7 <Cmd>7tabnext<CR>
nnoremap s8 <Cmd>8tabnext<CR>
nnoremap s9 <Cmd>9tabnext<CR>

" move by display line
noremap j  gj
noremap k  gk
noremap gj j
noremap gk k

" add space
inoremap , ,<Space>

" do not copy when deleting by x
nnoremap x "_x

" quit by q
nnoremap <silent> <leader>q  <Cmd>q<CR>
nnoremap <silent> <leader>wq <Cmd>qa<CR>
nnoremap <silent> <leader>Q  <Cmd>qa<CR>

" center cursor when jumped
nnoremap m jzz
nnoremap M kzz
" This option is deprecated. Instead, cursor should be somewhat inside window
setlocal scrolloff=5

" increase and decrease by plus/minus
nnoremap +  <C-a>
nnoremap -  <C-x>
vmap     g+ g<C-a>
vmap     g- g<C-x>

" switch quote and backquote
" nnoremap ' `
" nnoremap ` '

" save with <C-g> in insert mode
inoremap <C-g> <ESC>:update<CR>a

"save by <leader>s
nnoremap <silent> <leader>s <Cmd>update<CR>
nnoremap <silent> <leader>ws <Cmd>wall<CR>
inoremap <C-l> <Cmd>update<CR>

"reload init.vim
nnoremap <silent> <leader>r :<C-u>so ~/.config/nvim/init.vim<CR>

"open init.vim in new tab
nnoremap <silent> <leader>fed <Cmd>tabnew ~/.config/nvim/init.vim<CR>
nnoremap <silent> <leader>few <Cmd>tabnew ~/.config/nvim/mapping.vim<CR>
nnoremap <silent> <leader>fes <Cmd>tabnew ~/.config/nvim/set.vim<CR>

" grep
nnoremap <leader>vv :vimgrep // %:p:h/*<Left><Left><Left><Left><Left><Left><Left><Left><Left>

" recursive search
let s:use_vim_grep = 0
if s:use_vim_grep
    nnoremap <leader>vr :vimgrep // %:p:h/**<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>
else
    set grepprg=rg\ --vimgrep\ --no-heading\ -uuu
    nnoremap <leader>vr :grep -e ""<Left>
endif

" quickfix jump
nnoremap [q :cprevious<CR>   " 前へ
nnoremap ]q :cnext<CR>       " 次へ
nnoremap [Q :<C-u>cfirst<CR> " 最初へ
nnoremap ]Q :<C-u>clast<CR>  " 最後へ

"window-local quickfix jump
nnoremap [w :lprevious<CR>   " 前へ
nnoremap ]w :lnext<CR>       " 次へ
nnoremap [W :<C-u>lfirst<CR> " 最初へ
nnoremap ]W :<C-u>llast<CR>  " 最後へ

" In quickfix window...
" augroup QuickfixWindow
"     autocmd!
"     autocmd filetype qf nnoremap <buffer>p <CR>zz<C-w>j
"     autocmd filetype qf unmap j
"     autocmd filetype qf unmap k
" augroup END

" one push to add/remove tabs
nnoremap > >>
nnoremap < <<
" select again after tab action
vnoremap > >gv
vnoremap < <gv

" tagsジャンプの時に複数ある時は一覧表示
nnoremap <C-]> g<C-]>
""
" 行移動
inoremap <silent> <expr> <C-p> "<C-r>=ExecExCommand('normal k')<CR>"
inoremap <silent> <expr> <C-n> "<C-r>=ExecExCommand('normal j')<CR>"

function! ExecExCommand(cmd)
  silent exec a:cmd
  return ''
endfunction

set signcolumn=yes

set matchpairs+=「:」,（:）

" 最後に設定
filetype plugin indent on
syntax enable

" key mapping
nnoremap<silent> gss :SaveSession<CR>
nnoremap<silent> gsl :LoadSession<CR>
nnoremap<silent> gsc :CleanUpSession<CR>
let g:gitsession_tmp_dir = expand("~/.config/nvim/tmp/gitsession")

" 追加キーマップ
inoremap <silent>jj <ESC>
nnoremap O O<ESC>0D

augroup keymaps
  autocmd!
  autocmd FileType csv imap , ,
  autocmd FileType tex inoremap @ \
  autocmd FileType tex inoremap \ @
augroup END

" 行末空白の削除
nmap ds :%s/ *$//g<CR><C-o>zz
