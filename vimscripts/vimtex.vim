let g:vimtex_syntax_conceal_disable=1
let g:vimtex_mappings_enabled=0
let g:vimtex_compiler_latexmk = {
    \ 'build_dir' : '',
    \ 'callback' : 1,
    \ 'continuous' : 1,
    \ 'executable' : 'latexmk',
    \ 'hooks' : [],
    \ 'options' : [
    \   '-verbose',
    \   '-file-line-error',
    \   '-synctex=1',
    \   '-interaction=nonstopmode',
    \ ],
    \}

let g:vimtex_quickfix_ignore_filters = [
      \ 'Font Warning',
      \ 'Underfull',
      \]


let s:OSTYPE = substitute(system("uname"), '\n', '', 'g')
if s:OSTYPE == "Darwin"
  let g:vimtex_view_method = 'skim'
  let g:vimtex_view_skim_sync = 1
  let g:vimtex_view_skim_activate = 1
elseif s:OSTYPE == "Linux"
  if executable('zathura')
    let g:vimtex_view_method = 'zathura'
  else
    let g:vimtex_view_method = 'general'
    let g:vimtex_view_general_viewer = 'evince'
  end
endif
