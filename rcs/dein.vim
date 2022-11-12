" plugin settings
let s:cache_home = expand('~/.config/nvim')
let s:dein_dir = s:cache_home . '/dein'
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
if !isdirectory(s:dein_repo_dir)
  call system('git clone https://github.com/Shougo/dein.vim ' . shellescape(s:dein_repo_dir))
endif
let &runtimepath = s:dein_repo_dir .",". &runtimepath

let g:dein#types#git#clone_depth = 1
if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)
  " locate toml directory beforehand
  let g:rc_dir                    = s:cache_home . '/toml'
  let s:toml                      = g:rc_dir . '/dein.toml'
  let s:lazy_toml                 = g:rc_dir . '/dein_lazy.toml'
  let s:ddc_toml                  = g:rc_dir . '/dein_ddc.toml'
  let s:ddu_toml                  = g:rc_dir . '/dein_ddu.toml'
  let s:quickrun_toml             = g:rc_dir . '/dein_quickrun.toml'
  let s:fileype_toml              = g:rc_dir . '/dein_filetype.toml'

  let s:vscode_toml               = g:rc_dir . '/dein_vscode.toml'

  let s:colorscheme_toml          = g:rc_dir . '/dein_colorscheme.toml'
  let s:colorscheme_local_toml    = g:rc_dir . '/dein_colorscheme_local.toml'

  " read toml file and cache them
  if !exists('g:vscode')
    "  neovim
    call dein#load_toml(s:toml, {'lazy': 0})

    call dein#load_toml(s:quickrun_toml, {'lazy': 1})
    call dein#load_toml(s:ddc_toml, {'lazy': 1})
    call dein#load_toml(s:lazy_toml, {'lazy': 1})
    call dein#load_toml(s:ddu_toml, {'lazy': 1})

    call dein#load_toml(s:fileype_toml, {'lazy': 0})

    "  colorscheme
    if filereadable(expand(s:colorscheme_local_toml))
      call dein#load_toml(s:colorscheme_local_toml, {'lazy': 0})
    else
      call dein#load_toml(s:colorscheme_toml, {'lazy': 0})
    endif
  else
    " vscode
    call dein#load_toml(s:vscode_toml, {'lazy': 0})
  endif

  call dein#end()
  call dein#save_state()
endif

if has('vim_starting') && dein#check_install()
  call dein#install()
endif
