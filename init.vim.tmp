" map space to leader
let mapleader = "\<Space>"
let maplocalleader = "\\"

let g:OSTYPE = substitute(system("uname"), '\n', '', 'g')
let g:python3_host_prog = substitute(system("which python"), '\n', '', 'g')
let g:nvim_home_dir = expand($XDG_CONFIG_HOME . "/nvim")
if $XDG_CONFIG_HOME == ""
  let g:nvim_home_dir = expand("~/.config/nvim")
endif

"  plugin settings
exe 'source' expand(g:nvim_home_dir . '/vimscripts/dein.vim')

" other settings
if !exists('g:vscode')
  exe 'source' expand(g:nvim_home_dir . '/vimscripts/set.vim')
  exe 'source' expand(g:nvim_home_dir . '/vimscripts/mapping.vim')
else
  exe 'source' expand(g:nvim_home_dir . '/vimscripts/set_with_vscode.vim')
  exe 'source' expand(g:nvim_home_dir . '/vimscripts/mapping_vscode.vim')
endif

" load local setting
if filereadable(expand(g:nvim_home_dir . '/local_settings.vim'))
  exe 'source' expand(g:nvim_home_dir . '/local_settings.vim')
endif

filetype plugin on
filetype indent on
syntax enable
