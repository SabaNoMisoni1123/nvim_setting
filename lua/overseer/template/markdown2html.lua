---@type overseer.TempleteDevinition

return {
  name = "pandoc: markdown -> html (self-contained)",
  desc = "Convert current markdown file to standalone self-contained HTML using pandoc",
  builder = function()
    local md_file = vim.fn.expand("%:p")
    if md_file == "" then
      return nil
    end

    local dir        = vim.fn.fnamemodify(md_file, ":h")
    local base       = vim.fn.fnamemodify(md_file, ":t:r")
    local out_html   = dir .. "/" .. base .. ".html"

    local xdg_config = vim.env.XDG_CONFIG_HOME or (vim.fn.expand("~/.config"))
    local css_path   = xdg_config .. "/nvim/assets/my_style.css"

    ---@type overseer.taskDefinition
    return {
      name = ("[pandoc] %s -> %s"):format(md_file, out_html),
      cwd = dir, -- set the working directory for the task
      cmd = { "pandoc" },
      args = {
        "-f", "markdown+east_asian_line_breaks",
        "-t", "html",
        "--self-contained",
        "--standalone",
        "--css", css_path,
        "--resource-path=" .. dir,
        "-o", out_html,
        md_file,
      },
      -- env = {}, -- additional environment variables
    }
  end,
  -- tags = {},
  -- params = {
  --   -- See :help overseer-params
  -- },
  condition = {
    filetype = { "markdown" },
  },

}
