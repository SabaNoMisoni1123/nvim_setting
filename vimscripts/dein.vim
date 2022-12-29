" plugin settings
let g:dein#install_progress_type = 'floating'
let g:dein#install_check_diff = v:true
let g:dein#enable_notification = v:true
let g:dein#types#git#clone_depth = 1

let s:cache_home = g:nvim_home_dir
let s:dein_dir = s:cache_home . '/dein'
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

let g:plugins_github_dir = s:dein_dir . '/repos/github.com'

if !isdirectory(s:dein_repo_dir)
  call system('git clone https://github.com/Shougo/dein.vim ' . shellescape(s:dein_repo_dir))
endif
let &runtimepath = &runtimepath .','. s:dein_repo_dir

let s:toml            = s:cache_home . '/toml/dein.toml'
let s:lazy_toml       = s:cache_home . '/toml/dein_lazy.toml'
let s:filetype_toml   = s:cache_home . '/toml/dein_filetype.toml'

let s:ddu_toml        = s:cache_home . '/toml/dein_ddu.toml'

if dein#min#load_state(s:dein_dir)
  call dein#begin(s:dein_dir, [s:toml, s:lazy_toml, s:filetype_toml])

  call dein#load_toml(s:toml, #{ lazy: 0 })
  call dein#load_toml(s:lazy_toml, #{ lazy: 1 })
  call dein#load_toml(s:filetype_toml, #{ lazy: 0 })

  call dein#load_toml(s:ddu_toml, #{ lazy: 1 })

  call dein#end()
  call dein#save_state()
endif

if has('vim_starting') && dein#check_install()
  call dein#install()
endif

autocmd VimEnter * call dein#call_hook('post_source')
