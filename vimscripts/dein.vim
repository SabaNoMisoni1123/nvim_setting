" plugin settings
let s:cache_home = g:nvim_home_dir
let s:dein_dir = s:cache_home . '/dein'
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
let g:plugins_github_dir = s:dein_dir . '/repos/github.com'
if !isdirectory(s:dein_repo_dir)
  call system('git clone https://github.com/Shougo/dein.vim ' . shellescape(s:dein_repo_dir))
endif
let &runtimepath = s:dein_repo_dir .",". &runtimepath

let g:dein#types#git#clone_depth = 1
if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)
  let s:rc_dir                    = s:cache_home . '/toml'

  if !exists('g:vscode')
    let s:toml                      = s:rc_dir . '/dein.toml'
    let s:lazy_toml                 = s:rc_dir . '/dein_lazy.toml'
    let s:fileype_toml              = s:rc_dir . '/dein_filetype.toml'

    call dein#load_toml(s:toml, {'lazy': 0})
    call dein#load_toml(s:lazy_toml, {'lazy': 1})
    call dein#load_toml(s:fileype_toml, {'lazy': 0})
  else
    let s:vscode_toml               = s:rc_dir . '/dein_vscode.toml'
    call dein#load_toml(s:vscode_toml, {'lazy': 0})
  endif

  call dein#end()
  call dein#save_state()
endif

if has('vim_starting') && dein#check_install()
  call dein#install()
endif
