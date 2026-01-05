-- lua/mapping.lua

local bufopts = { noremap = true, silent = true }

-- terminal mapping
for k, v in pairs({
  ['<ESC>'] = '<C-\\><C-n>',
  ['jj'] = '<C-\\><C-n>',
}) do
  vim.keymap.set('t', k, v, bufopts)
end

-- visual mapping
for k, v in pairs({
  ['y'] = 'y`]',
  ['p'] = 'p`]',
  ['g+'] = 'g<C-a>',
  ['g-'] = 'g<C-x>',
  ['>'] = '>gv',
  ['<'] = '<gv',
  ['<Leader>h'] = '^',
  ['<Leader>l'] = '$',
  ['<Leader>k'] = 'gg',
  ['<Leader>j'] = 'G',
}) do
  vim.keymap.set('v', k, v, bufopts)
end

-- insert mapping
for k, v in pairs({
  [','] = ',<Space>',
  ['<C-g>'] = '<ESC>:update<CR>a',
  ['<C-l>'] = '<ESC>:update<CR>',
  ['jj'] = '<ESC>',
}) do
  vim.keymap.set('i', k, v, bufopts)
end

-- select mapping
for k, v in pairs({
  ['p'] = '<C-g>cp',
  ['j'] = '<C-g>cj',
  ['k'] = '<C-g>ck',
  ['h'] = '<C-g>ch',
  ['l'] = '<C-g>cl',
  ['<tab>'] = '<C-g>c<tab>',
}) do
  vim.keymap.set('s', k, v, bufopts)
end

-- normal mapping
for k, v in pairs({
  ['<Space>'] = '<Nop>',
  ['s'] = '<Nop>',
  ['p'] = 'p`]',
  ['<Leader>h'] = '^',
  ['<Leader>l'] = '$',
  ['<Leader>k'] = 'gg',
  ['<Leader>j'] = 'G',
  ['<C-h>'] = '^',
  ['<C-l>'] = '$',
  ['<C-k>'] = 'gg',
  ['<C-j>'] = 'G',
  ['ss'] = '<Cmd>split<CR>',
  ['sv'] = '<Cmd>vsplit<CR>',
  ['sc'] = '<Cmd>tab sp<CR>',
  ['sC'] = '<Cmd>-tab sp<CR>',
  ['sj'] = '<C-w>j',
  ['sk'] = '<C-w>k',
  ['sh'] = '<C-w>h',
  ['sl'] = '<C-w>l',
  ['sJ'] = '<C-w>J',
  ['sK'] = '<C-w>K',
  ['sH'] = '<C-w>H',
  ['sL'] = '<C-w>L',
  ['sx'] = '<Cmd>tab sp<CR><Cmd>terminal<CR>',
  ['sz'] = '<Cmd>10sp | set winfixheight<CR><Cmd>terminal<CR>',
  ['sn'] = '<Cmd>tabn<CR>',
  ['sp'] = '<Cmd>tabp<CR>',
  ['s='] = '<C-w>=',
  ['sO'] = '<C-w>=',
  ['so'] = '<C-w>_<C-w>\\|',
  ['sq'] = '<Cmd>tabc<CR>',
  ['j'] = 'gj',
  ['k'] = 'gk',
  ['gj'] = 'j',
  ['gk'] = 'k',
  ['x'] = '\"_x',
  ['m'] = 'jzz',
  ['M'] = 'kzz',
  ['+'] = '<C-a>',
  ['-'] = '<C-x>',
  ['<Leader>s'] = '<Cmd>update<CR>',
  ['<Leader>ws'] = '<Cmd>wall<CR>',
  ['<Leader>q'] = '<Cmd>q<CR>',
  ['<Leader>wq'] = '<Cmd>qa<CR>',
  ['<Leader>Q'] = '<Cmd>qa<CR>',
  ['<Leader>r'] = ':<C-u>so ~/.config/nvim/init.lua<CR>',
  ['<Leader>R'] = '<CMD>bufdo e!<CR>',
  ['<Leader>fed'] = '<Cmd>tabnew ~/.config/nvim/init.vim<CR>',
  ['>'] = '>>',
  ['<'] = '<<',
  ['O'] = 'O<ESC>0D',
  ['?'] = '/',
  ['ds'] = ':%s/\\s\\+$//e<CR><C-o>',
}) do
  vim.keymap.set('n', k, v, bufopts)
end

-- <C-space> for IME
do
  local opts = { noremap = true, silent = true }
  vim.keymap.set({ "i", "c" }, "<Nul>", "<Nop>", opts)
  vim.keymap.set({ "i", "c" }, "<C-@>", "<Nop>", opts)
  -- GUI等で <C-Space> として届く場合もあるため念のため
  vim.keymap.set({ "i", "c" }, "<C-Space>", "<Nop>", opts)
end
