-- lua/mapping.lua

local default_opts = { silent = true }

local function map(mode, lhs, rhs, desc, opts)
  opts = vim.tbl_extend("force", default_opts, opts or {})
  if desc then
    opts.desc = desc
  end
  vim.keymap.set(mode, lhs, rhs, opts)
end

-- terminal mapping
map('t', '<ESC>', '<C-\\><C-n>', 'Exit terminal mode')
map('t', 'jj', '<C-\\><C-n>', 'Exit terminal mode')

-- visual mapping
map('v', 'y', 'y`]', 'Yank and keep cursor at selection end')
map('v', 'p', 'p`]', 'Paste and keep cursor at selection end')
map('v', 'g+', 'g<C-a>', 'Increment selection')
map('v', 'g-', 'g<C-x>', 'Decrement selection')
map('v', '>', '>gv', 'Indent selection')
map('v', '<', '<gv', 'Dedent selection')
map('v', '<Leader>h', '^', 'Move to first non-blank')
map('v', '<Leader>l', '$', 'Move to line end')
map('v', '<Leader>k', 'gg', 'Move to first line')
map('v', '<Leader>j', 'G', 'Move to last line')

-- insert mapping
map('i', ',', ',<Space>', 'Insert comma and space')
map('i', '<C-g>', '<Esc><Cmd>update<CR>a', 'Save and continue insert')
map('i', '<C-l>', '<Esc><Cmd>update<CR>', 'Save and leave insert')
map('i', 'jj', '<Esc>', 'Exit insert mode')

-- select mapping
map('s', 'p', '<C-g>cp', 'Select mode paste')
map('s', 'j', '<C-g>cj', 'Select mode move down')
map('s', 'k', '<C-g>ck', 'Select mode move up')
map('s', 'h', '<C-g>ch', 'Select mode move left')
map('s', 'l', '<C-g>cl', 'Select mode move right')
map('s', '<Tab>', '<C-g>c<Tab>', 'Select mode tab')

-- normal mapping
map('n', '<Space>', '<Nop>', 'Disable Space')
map('n', 's', '<Nop>', 'Disable s prefix')
map('n', 'p', 'p`]', 'Paste and keep cursor at text end')
map('n', '<Leader>h', '^', 'Move to first non-blank')
map('n', '<Leader>l', '$', 'Move to line end')
map('n', '<Leader>k', 'gg', 'Move to first line')
map('n', '<Leader>j', 'G', 'Move to last line')
map('n', '<C-h>', '^', 'Move to first non-blank')
map('n', '<C-l>', '$', 'Move to line end')
map('n', '<C-k>', 'gg', 'Move to first line')
map('n', '<C-j>', 'G', 'Move to last line')
map('n', 'ss', '<Cmd>split<CR>', 'Horizontal split')
map('n', 'sv', '<Cmd>vsplit<CR>', 'Vertical split')
map('n', 'sc', '<Cmd>tab split<CR>', 'Open current buffer in new tab')
map('n', 'sC', '<Cmd>-tab split<CR>', 'Open current buffer in previous tab')
map('n', 'sj', '<C-w>j', 'Move to lower window')
map('n', 'sk', '<C-w>k', 'Move to upper window')
map('n', 'sh', '<C-w>h', 'Move to left window')
map('n', 'sl', '<C-w>l', 'Move to right window')
map('n', 'sJ', '<C-w>J', 'Move window down')
map('n', 'sK', '<C-w>K', 'Move window up')
map('n', 'sH', '<C-w>H', 'Move window left')
map('n', 'sL', '<C-w>L', 'Move window right')
map('n', 'sx', '<Cmd>tab split<CR><Cmd>terminal<CR>', 'Open terminal in new tab')
map('n', 'sz', '<Cmd>10split | setlocal winfixheight<CR><Cmd>terminal<CR>', 'Open fixed-height terminal')
map('n', 'sn', '<Cmd>tabnext<CR>', 'Next tab')
map('n', 'sp', '<Cmd>tabprevious<CR>', 'Previous tab')
map('n', 's=', '<C-w>=', 'Equalize window sizes')
map('n', 'sO', '<C-w>=', 'Equalize window sizes')
map('n', 'so', '<C-w>_<C-w>\\|', 'Maximize current window')
map('n', 'sq', '<Cmd>tabclose<CR>', 'Close tab')
map('n', 'j', 'gj', 'Move down by display line')
map('n', 'k', 'gk', 'Move up by display line')
map('n', 'gj', 'j', 'Move down by file line')
map('n', 'gk', 'k', 'Move up by file line')
map('n', 'x', '"_x', 'Delete character without yank')
map('n', 'm', 'jzz', 'Move down and center')
map('n', 'M', 'kzz', 'Move up and center')
map('n', '+', '<C-a>', 'Increment number')
map('n', '-', '<C-x>', 'Decrement number')
map('n', '<Leader>s', '<Cmd>update<CR>', 'Save current file')
map('n', '<Leader>ws', '<Cmd>wall<CR>', 'Save all files')
map('n', '<Leader>q', '<Cmd>quit<CR>', 'Quit window')
map('n', '<Leader>wq', '<Cmd>wqall<CR>', 'Save all files and quit')
map('n', '<Leader>Q', '<Cmd>quitall<CR>', 'Quit all')
map('n', '<Leader>r', function()
  vim.cmd.source(vim.fn.stdpath('config') .. '/init.lua')
end, 'Reload Neovim config')
map('n', '<Leader>R', '<Cmd>bufdo edit!<CR>', 'Reload all buffers')
map('n', '<Leader>fed', '<Cmd>tabnew ~/.config/nvim/init.lua<CR>', 'Edit Neovim init.lua')
map('n', '>', '>>', 'Indent line')
map('n', '<', '<<', 'Dedent line')
map('n', 'O', 'O<Esc>0D', 'Open blank line above')
map('n', '?', '/', 'Forward search')
map('n', 'ds', '<Cmd>%s/\\s\\+$//e<CR><C-o>', 'Remove trailing whitespace')

-- <C-space> for IME
do
  local opts = { silent = true }
  vim.keymap.set({ "i", "c" }, "<Nul>", "<Nop>", vim.tbl_extend("force", opts, { desc = "Disable IME control key" }))
  vim.keymap.set({ "i", "c" }, "<C-@>", "<Nop>", vim.tbl_extend("force", opts, { desc = "Disable IME control key" }))
  -- GUI等で <C-Space> として届く場合もあるため念のため
  vim.keymap.set({ "i", "c" }, "<C-Space>", "<Nop>", vim.tbl_extend("force", opts, { desc = "Disable IME control key" }))
end

-- <C-x> for ftmapping
do
  local opts = { silent = true, desc = "Reserved for filetype mapping" }
  vim.keymap.set("n", "<C-x>", "<Nop>", opts)
end
