local M = {}

local panel_default_width = 40
local panel_width_step = 5

vim.g.todo_telescope_width = tonumber(vim.g.todo_telescope_width) or panel_default_width

local function get_telescope_extension()
  local ok_telescope, telescope = pcall(require, "telescope")
  if not ok_telescope then
    vim.notify("telescope.nvim を読み込めませんでした", vim.log.levels.ERROR)
    return
  end

  pcall(telescope.load_extension, "todo-comments")

  local extension = telescope.extensions["todo-comments"]
  if not extension or type(extension.todo) ~= "function" then
    vim.notify("todo-comments.nvim の Telescope 連携を読み込めませんでした", vim.log.levels.ERROR)
    return
  end

  return extension
end

local function ensure_todo_comments_loaded()
  local ok_lazy, lazy = pcall(require, "lazy")
  if ok_lazy then
    lazy.load({ plugins = { "todo-comments.nvim" } })
  end
end

local function resolve_panel_width(width)
  local value = tonumber(width) or tonumber(vim.g.todo_telescope_width) or panel_default_width
  local max_width = math.max(10, vim.o.columns - 8)
  return math.max(10, math.min(value, max_width))
end

function M.open(opts)
  opts = opts or {}
  ensure_todo_comments_loaded()

  local extension = get_telescope_extension()
  if not extension then
    return
  end

  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")
  local width = resolve_panel_width(opts.width)

  vim.g.todo_telescope_width = width

  extension.todo({
    previewer = false,
    sorting_strategy = "ascending",
    path_display = { "truncate" },
    default_text = opts.default_text,
    layout_strategy = "vertical",
    layout_config = {
      anchor = "E",
      width = width,
      height = math.max(10, vim.o.lines - 4),
      prompt_position = "top",
    },
    attach_mappings = function(prompt_bufnr, map)
      local function resize(delta)
        local current_line = action_state.get_current_line()
        vim.g.todo_telescope_width = resolve_panel_width(width + delta)
        actions.close(prompt_bufnr)
        vim.schedule(function()
          M.open({
            width = vim.g.todo_telescope_width,
            default_text = current_line,
          })
        end)
      end

      map({ "i", "n" }, "<", function() resize(panel_width_step) end, { desc = "Widen TODO panel" })
      map({ "i", "n" }, ">", function() resize(-panel_width_step) end, { desc = "Narrow TODO panel" })
      return true
    end,
  })
end

function M.create_user_commands()
  vim.api.nvim_create_user_command("TodoPanel", function(command_opts)
    local width = command_opts.args ~= "" and tonumber(command_opts.args) or nil
    M.open({ width = width })
  end, {
    nargs = "?",
    desc = "Open TODO/FIX Telescope panel on the right",
  })
end

return M
