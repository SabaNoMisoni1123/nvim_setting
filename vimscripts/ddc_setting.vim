let s:ftypes = ['c', 'cpp', 'rust', 'python', 'gnuplot', 'typescript', 'javascript', 'html', 'css', 'vue']

call ddc#custom#patch_global('ui', 'native')

call ddc#custom#patch_global('sources', ['nvim-lsp', 'neosnippet', 'around', 'buffer', 'file'])
setlocal dictionary+=/usr/share/dict/words

call ddc#custom#set_context_filetype(s:ftypes, { ->
  \ ddc#syntax#in(['Comment', 'String']) ? {
  \   'sources': ['file', 'around', 'buffer', 'dictionary'],
  \ } : {} })

call ddc#custom#patch_filetype(["text", "markdown", "gitcommit", "conf", "csv", "tsv", "toml", "json", "no ft"], 'sources', ['around', 'buffer', 'file', 'dictionary'])
call ddc#custom#patch_filetype(["tex", "latex", "vue", "html", "css"], 'sources', ['nvim-lsp', 'neosnippet', 'around', 'buffer', 'file', 'dictionary'])

call ddc#custom#patch_global('sourceOptions', {
  \ 'file': { 'mark': 'F', 'forceCompletionPattern': '\S/\S*'},
  \ 'nvim-lsp': { 'mark':'lsp', 'forceCompletionPattern': '\.\w*|:\w*|->\w*'},
  \ 'around': { 'mark': 'A' },
  \ 'buffer': { 'mark': 'B' },
  \ 'ultisnips': { 'mark': 'US'},
  \ 'neosnippet': { 'mark': 'NS', 'dup': v:true},
  \ 'dictionary': { 'mark': 'D' },
  \ '_': { 'matchers': ['matcher_fuzzy'],
  \        'sorters':  ['sorter_fuzzy'],
  \        'converters':  ['converter_fuzzy'],
  \        'ignoreCase': v:true},
  \ })

call ddc#custom#patch_global('sourceParams', {
  \ 'nvim-lsp': { 'kindLabels': { 'Class': 'c' } },
  \ 'buffer': {'requireSameFiletype': v:false},
  \ 'dictionary': {
  \   'dictPaths': ['/usr/share/dict/words'],
  \   'smartCase': v:true,
  \ },
  \ })

call ddc#custom#patch_global('filterParams', {
  \ 'converter_fuzzy': {
  \   'hlGroup': 'SpellBad',
  \ }
  \ })

call ddc#custom#patch_global({
  \ 'backspaceCompletion': v:true,
  \ })

inoremap <silent><expr> <TAB>
  \ pumvisible() ? '<C-n>' :
  \ (col('.') <= 1 <Bar><Bar> getline('.')[col('.') - 2] =~# '\s') ?
  \ '<TAB>' : ddc#map#manual_complete()

" <S-TAB>: completion back.
inoremap <expr><S-TAB>  pumvisible() ? '<C-p>' : '<C-h>'

call ddc#enable()
