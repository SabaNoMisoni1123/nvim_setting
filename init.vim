" map space to leader
let mapleader = "\<Space>"
let maplocalleader = "\\"

let g:OSTYPE=substitute(system("uname"), '\n', '', 'g')

let g:python3_host_prog = substitute(system("which python"), '\n', '', 'g')

let g:nvim_home_dir = expand($XDG_CONFIG_HOME . "/nvim")

"  plugin settings
exe 'source' expand(g:nvim_home_dir . '/vim/dein.vim')

" other settings
if !exists('g:vscode')
  exe 'source' expand(g:nvim_home_dir . '/vim/set.vim')
  exe 'source' expand(g:nvim_home_dir . '/vim/mapping.vim')
else
  exe 'source' expand(g:nvim_home_dir . '/vim/set_with_vscode.vim')
  exe 'source' expand(g:nvim_home_dir . '/vim/mapping_vscode.vim')
endif

filetype plugin on
filetype indent on
syntax enable
set conceallevel=0

" local setting
if filereadable(expand(g:nvim_home_dir . '/init_local.vim'))
  exe 'source' expand(g:nvim_home_dir . '/init_local.vim')
endif
