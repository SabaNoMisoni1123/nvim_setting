local M = {}

local default_width = 45
local request_id = 0
local panel_bufnr
local panel_winid
local source_winid
local pending = false
local collapsed = {}
local line_entries = {}
local groups = {}
local namespace = vim.api.nvim_create_namespace("todo-panel")

local function close_panel()
  if panel_winid and vim.api.nvim_win_is_valid(panel_winid) then
    vim.api.nvim_win_close(panel_winid, true)
  end

  if panel_bufnr and vim.api.nvim_buf_is_valid(panel_bufnr) then
    vim.api.nvim_buf_delete(panel_bufnr, { force = true })
  end

  local was_open = panel_winid ~= nil or panel_bufnr ~= nil
  panel_winid = nil
  panel_bufnr = nil
  line_entries = {}
  groups = {}
  return was_open
end

local function parse_results(output)
  local results = {}

  for line in output:gmatch("[^\r\n]+") do
    local filename, lnum, col, text = line:match("^(.+):(%d+):(%d+):(.*)$")
    if filename then
      col = tonumber(col)
      table.insert(results, {
        filename = filename,
        lnum = tonumber(lnum),
        col = col,
        text = vim.trim(text:sub(col)),
      })
    end
  end

  table.sort(results, function(left, right)
    if left.filename == right.filename then
      if left.lnum == right.lnum then
        return left.col < right.col
      end
      return left.lnum < right.lnum
    end
    return left.filename < right.filename
  end)

  return results
end

local function group_results(results, cwd)
  local by_filename = {}
  local result_groups = {}

  for _, item in ipairs(results) do
    local group = by_filename[item.filename]
    if not group then
      group = {
        filename = item.filename,
        display_name = vim.fs.relpath(cwd, item.filename) or item.filename,
        items = {},
      }
      by_filename[item.filename] = group
      table.insert(result_groups, group)
    end
    table.insert(group.items, item)
  end

  return result_groups
end

local function render_panel()
  if not panel_bufnr or not vim.api.nvim_buf_is_valid(panel_bufnr) then
    return
  end

  local lines = {}
  line_entries = {}

  for _, group in ipairs(groups) do
    local is_collapsed = collapsed[group.filename] == true
    table.insert(lines, (is_collapsed and "▸ " or "▾ ") .. group.display_name .. (" (%d)"):format(#group.items))
    line_entries[#lines] = { kind = "file", group = group }

    if not is_collapsed then
      for _, item in ipairs(group.items) do
        table.insert(lines, "  " .. item.text)
        line_entries[#lines] = { kind = "todo", item = item }
      end
    end
  end

  vim.bo[panel_bufnr].modifiable = true
  vim.api.nvim_buf_set_lines(panel_bufnr, 0, -1, false, lines)
  vim.bo[panel_bufnr].modifiable = false
  vim.api.nvim_buf_clear_namespace(panel_bufnr, namespace, 0, -1)

  for index, entry in pairs(line_entries) do
    local highlight = entry.kind == "file" and "Directory" or "Normal"
    vim.api.nvim_buf_add_highlight(panel_bufnr, namespace, highlight, index - 1, 0, -1)
  end
end

local function current_entry()
  if not panel_winid or not vim.api.nvim_win_is_valid(panel_winid) then
    return
  end
  return line_entries[vim.api.nvim_win_get_cursor(panel_winid)[1]]
end

local function toggle_current_file()
  local entry = current_entry()
  if not entry or entry.kind ~= "file" then
    return false
  end

  collapsed[entry.group.filename] = not collapsed[entry.group.filename]
  render_panel()
  return true
end

local function open_current_todo()
  local entry = current_entry()
  if not entry then
    return
  end

  if entry.kind == "file" then
    toggle_current_file()
    return
  end

  local item = entry.item
  if not source_winid or not vim.api.nvim_win_is_valid(source_winid) then
    for _, winid in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
      if winid ~= panel_winid then
        source_winid = winid
        break
      end
    end
  end

  if not source_winid or not vim.api.nvim_win_is_valid(source_winid) then
    return
  end

  vim.api.nvim_set_current_win(source_winid)
  vim.cmd.edit(vim.fn.fnameescape(item.filename))
  vim.api.nvim_win_set_cursor(source_winid, { item.lnum, math.max(0, item.col - 1) })
  vim.cmd("normal! zz")
end

local function resolve_width(width)
  local value = tonumber(width) or default_width
  local max_width = math.max(1, vim.o.columns - 20)
  return math.max(math.min(20, max_width), math.min(value, max_width))
end

local function open_panel(results, cwd, width)
  source_winid = vim.api.nvim_get_current_win()
  groups = group_results(results, cwd)

  vim.cmd("botright vsplit")
  panel_winid = vim.api.nvim_get_current_win()
  panel_bufnr = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_win_set_buf(panel_winid, panel_bufnr)
  vim.api.nvim_buf_set_name(panel_bufnr, "todo://panel")

  vim.bo[panel_bufnr].buftype = "nofile"
  vim.bo[panel_bufnr].bufhidden = "wipe"
  vim.bo[panel_bufnr].swapfile = false
  vim.bo[panel_bufnr].filetype = "todo-panel"
  vim.wo[panel_winid].cursorline = true
  vim.wo[panel_winid].number = false
  vim.wo[panel_winid].relativenumber = false
  vim.wo[panel_winid].signcolumn = "no"
  vim.wo[panel_winid].winfixwidth = true
  vim.wo[panel_winid].winbar = (" TODOs (%d) "):format(#results)
  vim.api.nvim_win_set_width(panel_winid, resolve_width(width))

  vim.keymap.set("n", "<CR>", open_current_todo, { buffer = panel_bufnr, desc = "Open TODO or toggle file" })
  vim.keymap.set("n", "<Space>", toggle_current_file, { buffer = panel_bufnr, desc = "Toggle TODO file" })
  vim.keymap.set("n", "q", close_panel, { buffer = panel_bufnr, desc = "Close TODO panel" })
  vim.keymap.set("n", "<C-g>", close_panel, { buffer = panel_bufnr, desc = "Close TODO panel" })

  render_panel()
end

function M.toggle(opts)
  opts = opts or {}

  request_id = request_id + 1
  local current_request = request_id

  if close_panel() then
    return
  end

  if pending then
    pending = false
    return
  end

  local command = "rg"
  if vim.fn.executable(command) ~= 1 then
    vim.notify(command .. " が見つかりません", vim.log.levels.ERROR)
    return
  end

  local pattern = opts.pattern or vim.g.todo_panel_search_pattern
  local cwd = vim.fn.fnamemodify(opts.cwd or vim.fn.getcwd(), ":p")

  pending = true
  vim.system({
    command,
    "--color=never",
    "--no-heading",
    "--with-filename",
    "--line-number",
    "--column",
    "--",
    pattern,
    cwd,
  }, { text = true }, function(result)
    vim.schedule(function()
      if current_request ~= request_id then
        return
      end
      pending = false

      if result.code ~= 0 and result.code ~= 1 then
        local message = vim.trim(result.stderr or "")
        vim.notify(message ~= "" and message or "TODO の検索に失敗しました", vim.log.levels.ERROR)
        return
      end

      local results = parse_results(result.stdout or "")
      if #results == 0 then
        vim.notify("TODO パターンに一致する項目はありません", vim.log.levels.INFO)
        return
      end

      open_panel(results, cwd, opts.width)
      vim.notify(("TODO パネル: %dファイル / %d件"):format(#groups, #results), vim.log.levels.INFO)
    end)
  end)
end

function M.create_user_commands()
  vim.api.nvim_create_user_command("TodoPanel", function(command_opts)
    M.toggle({ width = command_opts.args ~= "" and tonumber(command_opts.args) or nil })
  end, {
    nargs = "?",
    desc = "Toggle project TODO tree panel on the right",
  })
end

return M
