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
    globalstatus = false,
    refresh = {
      statusline = 500,
      tabline = 500,
      winbar = 500,
    }
  },
  sections = {
    lualine_a = { function() return mode_map[vim.api.nvim_get_mode()["mode"]] or '' end },
    lualine_b = {
      'branch',
      'diff',
      {
        'diagnostics',
        symbols = { error = '', warn = '', info = '', hint = '' },
      }
    },
    lualine_c = { 'filename' },
    lualine_x = {
      {
        'filetype',
        icon_only = true,
      }
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
    lualine_c = { 'filename' },
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
