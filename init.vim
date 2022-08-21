" map space to leader
let mapleader = "\<Space>"
let maplocalleader = "\\"

let g:OSTYPE=substitute(system("uname"), '\n', '', 'g')

let g:python3_host_prog = substitute(system("which python"), '\n', '', 'g')

let g:nvim_home_dir = expand('~/.config/nvim')

"  plugin settings
exe 'source' expand(g:nvim_home_dir . '/dein.vim')

" other settings
if !exists('g:vscode')
  exe 'source' expand(g:nvim_home_dir . '/set.vim')
  exe 'source' expand(g:nvim_home_dir . '/mapping.vim')
else
  exe 'source' expand(g:nvim_home_dir . '/set_with_vscode.vim')
  exe 'source' expand(g:nvim_home_dir . '/mapping_vscode.vim')
endif

filetype plugin indent on
syntax enable
set conceallevel=0

" local setting
if filereadable(expand(g:nvim_home_dir . '/init_local.vim'))
  exe 'source' expand(g:nvim_home_dir . '/init_local.vim')
endif
