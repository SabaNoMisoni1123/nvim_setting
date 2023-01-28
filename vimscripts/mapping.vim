"key mapping

" terminal mapping
tnoremap <Esc>  <C-\><C-n>
tnoremap jj     <C-\><C-n>
autocmd TermOpen * startinsert

" move to the end of a text after copying/pasting it
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
nnoremap sx <Cmd>tab sp<CR><Cmd>terminal<CR>
nnoremap sz <Cmd>10sp<CR><Cmd>terminal<CR>
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

" one push to add/remove tabs
nnoremap > >>
nnoremap < <<
" select again after tab action
vnoremap > >gv
vnoremap < <gv

set signcolumn=yes

set matchpairs+=「:」,（:）

" 追加キーマップ
inoremap <silent>jj <ESC>
nnoremap O O<ESC>0D
nnoremap <C-_> /

snoremap p      <C-g>cp
snoremap j      <C-g>cj
snoremap k      <C-g>ck
snoremap h      <C-g>ch
snoremap l      <C-g>cl
snoremap <tab>  <C-g>c<tab>

" 行末空白の削除
nmap ds :%s/\s\+$//e<CR><C-o>
