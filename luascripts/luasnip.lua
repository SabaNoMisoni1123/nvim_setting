local ls = require("luasnip")
local s = ls.snippet

local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node

local events = require("luasnip.util.events")
local ai = require("luasnip.nodes.absolute_indexer")
local fmt = require("luasnip.extras.fmt").fmt
local extras = require("luasnip.extras")
local m = extras.m
local l = extras.l
local rep = extras.rep
local postfix = require("luasnip.extras.postfix").postfix

-- load vim-snippets
require("luasnip.loaders.from_snipmate").lazy_load({
  path=vim.g.plugins_github_dir .. '/honza/vim-snippets/snippets/',
  default_priority = 1,
  override_priority = 1,
})
-- load my snippets
require("luasnip.loaders.from_snipmate").lazy_load({
  path=vim.g.nvim_home_dir .. '/snippets/',
  default_priority = 10,
  override_priority = 10,
})
