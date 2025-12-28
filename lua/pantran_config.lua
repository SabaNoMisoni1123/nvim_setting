-- lua/pantran_config.lua
local M = {}

-- 状態（確認コマンドで参照）
local state = {
  engine = "google",
  deepl = { ok = false, count = nil, limit = nil },
}

-- DeepL Free のキーは api-free エンドポイントを使う（末尾 :fx 判定）
-- DeepL公式：Free と Pro でエンドポイントが異なる :contentReference[oaicite:3]{index=3}
local function deepl_base_url(auth_key)
  if auth_key and auth_key:sub(-3) == ":fx" then
    return "https://api-free.deepl.com"
  end
  return "https://api.deepl.com"
end

local function refresh_deepl_usage(cb)
  local key = vim.env.DEEPL_AUTH_KEY
  if not key or key == "" then
    state.deepl = { ok = false, count = nil, limit = nil }
    cb(false)
    return
  end

  local url = deepl_base_url(key) .. "/v2/usage"

  vim.system({
    "curl", "-sS",
    "-H", "Authorization: DeepL-Auth-Key " .. key,
    url,
  }, { text = true }, function(res)
    if res.code ~= 0 then
      state.deepl = { ok = false, count = nil, limit = nil }
      cb(false)
      return
    end

    local ok, json = pcall(vim.json.decode, res.stdout)
    if not ok or type(json) ~= "table" then
      state.deepl = { ok = false, count = nil, limit = nil }
      cb(false)
      return
    end

    state.deepl.count = tonumber(json.character_count)
    state.deepl.limit = tonumber(json.character_limit)
    state.deepl.ok = (state.deepl.count ~= nil and state.deepl.limit ~= nil)
    cb(state.deepl.ok)
  end)
end

local function choose_engine(cb)
  refresh_deepl_usage(function(ok)
    if ok and state.deepl.count < state.deepl.limit then
      state.engine = "deepl"
    else
      state.engine = "google"
    end
    cb(state.engine)
  end)
end

function M.setup()
  local pantran = require("pantran")
  local actions = require("pantran.ui.actions")

  pantran.setup({
    default_engine = "google",
    engines = {
      google = {
        default_source = "auto",
        default_target = "en",
      },
      deepl = {
        default_source = "auto",
        default_target = "en",
      },
    },
    ui = {
      width_percentage = 0.6,
      height_percentage = 0.6,
      min_width = 40,
      min_height = 40,
    },
    window = {
      options = {
        number         = true,
        relativenumber = false,
        cursorline     = true,
        cursorcolumn   = false,
        linebreak      = true,
        breakindent    = true,
        wrap           = true,
        foldcolumn     = "0",
        signcolumn     = "auto",
        colorcolumn    = "",
        fillchars      = "eob: ",
        winhighlight   = "Normal:PantranNormal,SignColumn:PantranNormal,FloatBorder:PantranBorder",
        textwidth      = 0
      }
    },
    controls = {
      mappings = {
        edit = {
          i = {
            ["<C-h>"] = actions.help,
            ["<C-_>"] = false,
          }
        }
      }
    }
  })

  vim.api.nvim_create_user_command("PantranEngine", function()
    local msg = ("engine=%s"):format(state.engine)
    if state.deepl.ok then
      msg = msg .. (" | DeepL usage %d/%d chars"):format(state.deepl.count, state.deepl.limit)
    else
      msg = msg .. " | DeepL usage unavailable"
    end
    vim.notify(msg)
  end, {})

  vim.api.nvim_create_user_command("PantranSmart", function(cmdopts)
    choose_engine(function(engine)
      pantran.setup({
        default_engine = engine,
        engines = {
          google = { default_source = "auto", default_target = "en" },
          deepl  = { default_source = "auto", default_target = "en" },
        },
      })

      local range = ""
      if cmdopts.range == 2 then
        range = ("%d,%d"):format(cmdopts.line1, cmdopts.line2)
      elseif cmdopts.range == 1 then
        range = ("%d"):format(cmdopts.line1)
      end

      local args = table.concat(cmdopts.fargs or {}, " ")
      local ex = (range ~= "" and (":" .. range .. "Pantran") or ":Pantran")
      if args ~= "" then
        ex = ex .. " " .. args
      end
      vim.cmd(ex)
    end)
  end, { nargs = "*", range = true })
end

return M
