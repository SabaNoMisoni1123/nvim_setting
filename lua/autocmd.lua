-- terminal mode
vim.api.nvim_create_autocmd("TermOpen", {
  command = "startinsert"
})

-- file type
local aug_filetype   = vim.api.nvim_create_augroup("FileType", { clear = true })
for k, v in pairs({
  ['*.jl'] = 'julia',
  ['*.plt'] = 'gnuplot',
  ['*.m'] = 'matlab',
  ['*.csv'] = 'csv',
  ['*.toml'] = 'conf',
}) do
  vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    pattern= { k },
    group = aug_filetype,
    callback = function() vim.opt_local.setfiletype = v end,
  })
end

-- binary setting
-- そのうちやる
