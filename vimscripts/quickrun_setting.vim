autocmd FileType quickrun call s:quickrun_py_settings()
function! s:quickrun_py_settings() abort
  nnoremap <buffer><silent> q   <Cmd>quit!<CR>
endfunction

let g:quickrun_config = {}

let g:quickrun_config._ = {
  \ 'outputter/buffer/opener': '10new',
  \ 'outputter/buffer/into': 0,
  \ 'outputter/buffer/close_on_empty': 1,
  \ }

let g:quickrun_config['gnuplot'] = {
  \ 'type' : 'gnuplot',
  \ 'command' : 'gnuplot',
  \ 'cmdopt' : '--persist',
  \ 'exec' : 'cd %s:h;%c %s %o',
  \ 'hook/cd/directory' : '%S:h',
  \}

let g:quickrun_config['matlab'] = {
  \ 'type' : 'matlab',
  \ 'command' : 'octave',
  \ 'exec' : 'cd %s:h;%c %s',
  \ 'hook/cd/directory' : '%S:h',
  \}

let g:quickrun_config['tex']={
  \ 'type' : 'tex',
  \ 'command' : 'latexmk',
  \ 'exec' : '%c %s',
  \ 'hook/cd/directory' : '%S:h',
  \}

let g:quickrun_config["c"]={
  \ 'type':
  \ executable('gcc')            ? 'c/gcc' :
  \ executable('clang')          ? 'c/clang' :
  \ executable('clang-9')        ? 'c/clang-9' : '',
  \}

let g:quickrun_config['c/gcc']={
  \ 'cmdopt' : '-std=c11',
  \ 'hook/cd/directory' : '%S:h',
  \}

let g:quickrun_config['c/clang']={
  \ 'command' : 'clang',
  \ 'cmdopt' : '-std=c11',
  \ 'hook/cd/directory' : '%S:h',
  \}

let g:quickrun_config['c/clang-9']={
  \ 'command' : 'clang-9',
  \ 'cmdopt' : '-std=c11',
  \ 'hook/cd/directory' : '%S:h',
  \}

let g:quickrun_config["cpp"]={
  \ 'type':
  \ executable('g++')            ? 'cpp/g++' :
  \ executable('clang++')        ? 'cpp/clang++'  :
  \ executable('clang++-9')      ? 'cpp/clang++-9'  : '',
  \}

let g:quickrun_config['cpp/g++']={
  \ 'cmdopt' : '-std=c++2a',
  \ 'hook/cd/directory' : '%S:h',
  \}

let g:quickrun_config['cpp/clang++']={
  \ 'command' : 'clang++-9',
  \ 'cmdopt' : '-std=c++2a',
  \ 'hook/cd/directory' : '%S:h',
  \}

let g:quickrun_config['cpp/clang++-9']={
  \ 'command' : 'clang++-9',
  \ 'cmdopt' : '-std=c++2a',
  \ 'hook/cd/directory' : '%S:h',
  \}

let g:quickrun_config['cmake'] = {
  \ 'command': 'cmake',
  \ 'exec': [
  \   '%c -B build',
  \   'make -j -C build',
  \   'echo "\n\n===output==="',
  \   './build/a.out'
  \ ],
  \ 'hook/cd/directory' : '%S:h',
  \}

let g:quickrun_config['cmake/first'] = {
  \ 'command': 'cmake',
  \ 'exec': [
  \   '%c -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -B build',
  \   'cp ./build/compile_commands.json ./',
  \   'make -j -C build',
  \   'echo "\n\n===output==="',
  \   './build/a.out'
  \ ],
  \ 'hook/cd/directory' : '%S:h',
  \}

let g:quickrun_config['make'] = {
  \ 'command': 'make',
  \ 'exec': ['%c -j', 'echo "\n\n===output==="', './a.out'],
  \ 'hook/cd/directory' : '%S:h',
  \}

let g:quickrun_config['cmake/src'] = {
  \ 'command': 'cmake',
  \ 'exec': [
  \   '%c -DCMAKE_EXPORT_COMPILE_COMMANDS=ON ..',
  \   'cp ./compile_commands.json ./../',
  \   'make -j',
  \   'echo "\n\n===output==="',
  \   './a.out'
  \ ],
  \ 'hook/cd/directory' : '%S:h:h'.'/build',
  \}

let g:quickrun_config['make/src'] = {
  \ 'command': 'make',
  \ 'exec': ['%c -j', 'echo "\n\n===output==="', './a.out'],
  \ 'hook/cd/directory' : '%S:h:h'.'/build',
  \}

let g:quickrun_config['python'] = {
  \ 'hook/cd/directory' : '%S:h',
  \}

let g:quickrun_config['scilab'] = {
  \ 'command' : 'scilab-cli',
  \ 'exec': ['%c -f %s -quit'],
  \ 'hook/cd/directory' : '%S:h',
  \}

let g:quickrun_config['markdown']={
  \ 'type':
  \ executable('pandoc') ? 'markdown/mysetting':
  \ executable('marp') ? 'markdown/marp':
  \ '',
  \}

let g:quickrun_config['markdown/mysetting'] = {
  \ 'command': 'pandoc',
  \ 'exec': [
  \   '%c %s %o %a -o %s:r.html',
  \   'cat %s:r.html',
  \ ],
  \ 'cmdopt' : '-f markdown -t html5 -s --self-contained --css=$XDG_CONFIG_HOME/nvim/template/memo-template.css',
  \ 'hook/cd/directory' : '%S:h',
  \ }

let g:quickrun_config['markdown/marp'] = {
  \ 'command': 'marp',
  \ 'exec': [
  \   '%c --allow-local-files %s',
  \ ],
  \ 'hook/cd/directory' : '%S:h',
  \ }

let g:quickrun_config['markdown/marp-pdf'] = {
  \ 'command': 'marp',
  \ 'exec': [
  \   '%c --pdf --pdf-outlines --allow-local-files %s',
  \ ],
  \ 'hook/cd/directory' : '%S:h',
  \ }

let g:quickrun_config['javascript'] = {
  \ 'type':
  \ executable('js') ? 'javascript/spidermonkey':
  \ executable('d8') ? 'javascript/v8':
  \ executable('node') ? 'javascript/nodejs':
  \ executable('phantomjs') ? 'javascript/phantomjs':
  \ executable('jrunscript') ? 'javascript/rhino':
  \ executable('cscript') ? 'javascript/cscript':
  \ executable('deno') ? 'javascript/deno':
  \ '',
  \ }

let g:quickrun_config['javascript/deno'] = {
  \ 'command': 'deno',
  \ 'exec': ['%c run -q %s'],
  \ 'hook/cd/directory' : '%S:h',
  \ }
