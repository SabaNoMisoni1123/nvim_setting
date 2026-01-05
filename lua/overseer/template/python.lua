---@type overseer.TempleteDevinition

return {
  name = "Python Template",
  builder = function()
    local file = vim.fn.expand("%")
    ---@type overseer.taskDefinition
    return {
      cmd = { "python" },
      args = { file },
      -- cwd = "" -- set the working directory for the task
      -- env = {} -- additional environment variables
    }
  end,
  desc = "Python Template",
  tags = {},
  params = {
    -- See :help overseer-params
  },
  condition = {
    filetype = { "python" },
    -- dir = "str"
  },

}
