local mode_map  = {}
mode_map['n']   = ''
mode_map['no']  = ''
mode_map['nov'] = ''
mode_map['noV'] = ''
mode_map['no'] = ''
mode_map['niI'] = ''
mode_map['niR'] = ''
mode_map['niV'] = ''
mode_map['nt']  = ''
mode_map['v']   = ''
mode_map['vs']  = ''
mode_map['V']   = ''
mode_map['Vs']  = ''
mode_map['']   = ''
mode_map['s']  = ''
mode_map['s']   = ''
mode_map['S']   = ''
mode_map['']   = ''
mode_map['i']   = ''
mode_map['ic']  = ''
mode_map['ix']  = ''
mode_map['R']   = ''
mode_map['Rc']  = ''
mode_map['Rx']  = ''
mode_map['Rv']  = ''
mode_map['rvc'] = ''
mode_map['Rvx'] = ''
mode_map['c']   = ''
mode_map['cv']  = ''
mode_map['ce']  = ''
mode_map['r']   = ''
mode_map['!']   = ''
mode_map['t']   = ''

-- ---- small helpers (no plugin) ----
local function is_not_empty(s) return s ~= nil and s ~= '' end

-- LSP client names for current buffer
local function lsp_names()
  local bufnr = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_clients({ bufnr = bufnr })
  if not clients or vim.tbl_isempty(clients) then return '' end
  local names = {}
  for _, c in ipairs(clients) do
    if c and is_not_empty(c.name) then
      names[#names + 1] = c.name
    end
  end
  if #names == 0 then return '' end
  return ' ' .. table.concat(names, ',')
end

-- macro recording indicator
local function macro_recording()
  local reg = vim.fn.reg_recording()
  if reg == '' then return '' end
  return ' @' .. reg
end

-- search count
local function search_count()
  -- 直近検索パターン
  local pat = vim.fn.getreg('/')
  if not pat or pat == '' then return '' end

  -- 正規表現フラグを軽く除去（見た目用）
  pat = pat:gsub([[\\V]], '')
           :gsub([[\\c]], '')
           :gsub([[\\C]], '')

  local maxlen = 10
  if vim.fn.strchars(pat) > maxlen then
    pat = vim.fn.strcharpart(pat, 0, maxlen) .. '…'
  end

  -- ヒット数
  local ok, sc = pcall(vim.fn.searchcount, { recompute = 1, maxcount = 9999 })
  if not ok or not sc or sc.total == 0 then
    return (' %s'):format(pat)
  end

  if sc.incomplete == 1 then
    return (' %s ?/%d'):format(pat, sc.total)
  end

  return (' %s %d/%d'):format(pat, sc.current, sc.total)
end

-- indent settings
local function indent_info()
  local sw = vim.bo.shiftwidth
  local ts = vim.bo.tabstop
  local et = vim.bo.expandtab and 'sp' or 'tab'
  return ('󰌒 %s:%d/%d'):format(et, sw, ts)
end

-- project root (no project.nvim require; uses similar patterns)
local root_patterns = { ".git", "package.json", ".textlintrc.js", ".textlintrc", "pyproject.toml", "Makefile",
  "README.md" }
local function project_root()
  local bufname = vim.api.nvim_buf_get_name(0)
  if bufname == '' then return '' end
  local dir = vim.fs.dirname(bufname)
  if not dir then return '' end

  local found = vim.fs.find(root_patterns, { path = dir, upward = true, stop = vim.uv.os_homedir() })
  if not found or #found == 0 then return '' end

  local root = vim.fs.dirname(found[1])
  if not root or root == '' then return '' end
  return ' ' .. vim.fs.basename(root)
end

-- gitsigns (no require; shows only when gitsigns already populated buffer vars)
local function gitsigns_status()
  local d = vim.b.gitsigns_status_dict
  if type(d) ~= "table" then return '' end
  local parts = {}
  if (d.added or 0) > 0 then parts[#parts + 1] = ('+%d'):format(d.added) end
  if (d.changed or 0) > 0 then parts[#parts + 1] = ('~%d'):format(d.changed) end
  if (d.removed or 0) > 0 then parts[#parts + 1] = ('-%d'):format(d.removed) end
  if #parts == 0 then return '' end
  return ' ' .. table.concat(parts, ' ')
end

-- vimtex (safe: only call on tex buffers)
local function vimtex_status()
  if vim.bo.filetype ~= 'tex' then return '' end
  if vim.fn.exists('*vimtex#statusline') ~= 1 then return '' end
  local ok, s = pcall(vim.fn['vimtex#statusline'])
  if not ok or not is_not_empty(s) then return '' end
  return ' ' .. s
end

require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'auto',
    component_separators = { left = '│', right = '│' },
    section_separators = { left = '', right = '' },
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = true,
    refresh = {
      statusline = 500,
      tabline = 500,
      winbar = 500,
    }
  },
  sections = {
    lualine_a = { function() return mode_map[vim.api.nvim_get_mode()["mode"]] or '' end },
    lualine_b = {
      {
        'diagnostics',
        symbols = { error = '', warn = '', info = '', hint = '' },
      }
    },
    lualine_c = {
      'branch',
      {
        project_root, cond = function() return project_root() ~= '' end
      },
      {
        'filename',
        path = 1, -- 0:tail 1:relative 2:absolute 3:absolute
        shorting_target = 40,
        symbols = { modified = ' ●', readonly = ' ', unnamed = '[No Name]' },
      }
    },
    lualine_x = {
      { 'filetype',      icon_only = true },
      { vimtex_status,   cond = function() return vim.bo.filetype == 'tex' end },
      { gitsigns_status, cond = function() return type(vim.b.gitsigns_status_dict) == "table" end },
      { macro_recording, cond = function() return vim.fn.reg_recording() ~= '' end },
      { search_count },
      { lsp_names,       cond = function() return #vim.lsp.get_clients({ bufnr = 0 }) > 0 end },
      { 'encoding',      cond = function() return vim.bo.fileencoding ~= '' end },
      { 'fileformat' },
      { indent_info },
    },
    lualine_y = { 'progress' },
    lualine_z = { 'location' }
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { 'filename' },
    lualine_x = { 'location' },
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {
    lualine_a = { 'tabs' },
    lualine_b = { 'branch' },
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {}
  },
  winbar = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {}
  },
  inactive_winbar = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {}
  },
  extensions = {}
}
