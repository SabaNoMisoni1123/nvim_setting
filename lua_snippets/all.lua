local ls = require("luasnip")

local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node

local function japanese_date()
  local now = os.time()
  local weekdays = { "日", "月", "火", "水", "木", "金", "土" }
  local weekday_number = tonumber(os.date("%w", now)) or 0
  local weekday = weekdays[weekday_number + 1]

  return os.date("%Y年%m月%d日", now) .. "（" .. weekday .. "）"
end

-- 全 filetype で使用するスニペットをこのテーブルへ追加する。
return {
  s({ trig = "date-japanese-style", name = "日本語の日付" }, {
    f(japanese_date),
  }),
}
