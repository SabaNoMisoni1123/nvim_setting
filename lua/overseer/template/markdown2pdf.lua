---@type overseer.TempleteDevinition

return {
  name = "pandoc: markdown -> pdf",
  desc = "Convert current markdown file to PDF using pandoc",
  builder = function()
    local md_file = vim.fn.expand("%:p")
    if md_file == "" then
      return nil
    end

    local dir        = vim.fn.fnamemodify(md_file, ":h")
    local base       = vim.fn.fnamemodify(md_file, ":t:r")
    local out_pdf   = dir .. "/" .. base .. ".pdf"
    local pdf_engine = vim.env.PDF_ENGINE

    local xdg_config = vim.env.XDG_CONFIG_HOME or (vim.fn.expand("~/.config"))
    local css_path   = xdg_config .. "/nvim/assets/my_style.css"

    ---@type overseer.taskDefinition
    return {
      name = ("[pandoc] %s -> %s"):format(md_file, out_pdf),
      cwd = dir, -- set the working directory for the task
      cmd = { "pandoc" },
      args = {
        "--standalone",
        "--pdf-engine=" .. pdf_engine,
        "--css", css_path,
        "--resource-path=" .. dir,
        "-o", out_pdf,
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
