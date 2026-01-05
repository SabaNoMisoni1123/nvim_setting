-- lua/quickrun_config.lua
local M = {}

local function exe(cmd)
  return vim.fn.executable(cmd) == 1
end

local configured = false

function M.setup()

  if configured then
    return
  end
  configured = true

  -- ここに「長い設定」をまとめる
  -- Vimscript の g:quickrun_config を Lua テーブルとして作る
  local c_type = ""
  if exe("gcc") then
    c_type = "c/gcc"
  elseif exe("clang") then
    c_type = "c/clang"
  elseif exe("clang-9") then
    c_type = "c/clang-9"
  end

  local cpp_type = ""
  if exe("g++") then
    cpp_type = "cpp/g++"
  elseif exe("clang++") then
    cpp_type = "cpp/clang++"
  elseif exe("clang++-9") then
    cpp_type = "cpp/clang++-9"
  end

  local markdown_type = ""
  if exe("pandoc") then
    markdown_type = "markdown/mysetting"
  elseif exe("marp") then
    markdown_type = "markdown/marp"
  end

  local javascript_type = ""
  if exe("js") then
    javascript_type = "javascript/spidermonkey"
  elseif exe("d8") then
    javascript_type = "javascript/v8"
  elseif exe("node") then
    javascript_type = "javascript/nodejs"
  elseif exe("phantomjs") then
    javascript_type = "javascript/phantomjs"
  elseif exe("jrunscript") then
    javascript_type = "javascript/rhino"
  elseif exe("cscript") then
    javascript_type = "javascript/cscript"
  elseif exe("deno") then
    javascript_type = "javascript/deno"
  end

  vim.g.quickrun_config = {
    ["_"] = {
      ["outputter/buffer/opener"] = "10new",
      ["outputter/buffer/into"] = 0,
      ["outputter/buffer/close_on_empty"] = 1,
    },

    gnuplot = {
      type = "gnuplot",
      command = "gnuplot",
      cmdopt = "--persist",
      exec = "cd %s:h;%c %s %o",
      ["hook/cd/directory"] = "%S:h",
    },

    matlab = {
      type = "matlab",
      command = "octave",
      exec = "cd %s:h;%c %s",
      ["hook/cd/directory"] = "%S:h",
    },

    tex = {
      type = "tex",
      command = "latexmk",
      exec = "%c %s",
      ["hook/cd/directory"] = "%S:h",
    },

    c = { type = c_type },
    ["c/gcc"] = { cmdopt = "-std=c11", ["hook/cd/directory"] = "%S:h" },
    ["c/clang"] = { command = "clang", cmdopt = "-std=c11", ["hook/cd/directory"] = "%S:h" },
    ["c/clang-9"] = { command = "clang-9", cmdopt = "-std=c11", ["hook/cd/directory"] = "%S:h" },

    cpp = { type = cpp_type },
    ["cpp/g++"] = { cmdopt = "-std=c++2a", ["hook/cd/directory"] = "%S:h" },
    ["cpp/clang++"] = { command = "clang++-9", cmdopt = "-std=c++2a", ["hook/cd/directory"] = "%S:h" },
    ["cpp/clang++-9"] = { command = "clang++-9", cmdopt = "-std=c++2a", ["hook/cd/directory"] = "%S:h" },

    cmake = {
      command = "cmake",
      exec = {
        "%c -B build",
        "make -j -C build",
        'echo "\\n\\n===output==="',
        "./build/a.out",
      },
      ["hook/cd/directory"] = "%S:h",
    },

    ["cmake/first"] = {
      command = "cmake",
      exec = {
        "%c -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -B build",
        "cp ./build/compile_commands.json ./",
        "make -j -C build",
        'echo "\\n\\n===output==="',
        "./build/a.out",
      },
      ["hook/cd/directory"] = "%S:h",
    },

    make = {
      command = "make",
      exec = { "%c -j", 'echo "\\n\\n===output==="', "./a.out" },
      ["hook/cd/directory"] = "%S:h",
    },

    ["cmake/src"] = {
      command = "cmake",
      exec = {
        "%c -DCMAKE_EXPORT_COMPILE_COMMANDS=ON ..",
        "cp ./compile_commands.json ./../",
        "make -j",
        'echo "\\n\\n===output==="',
        "./a.out",
      },
      ["hook/cd/directory"] = "%S:h:h/build",
    },

    ["make/src"] = {
      command = "make",
      exec = { "%c -j", 'echo "\\n\\n===output==="', "./a.out" },
      ["hook/cd/directory"] = "%S:h:h/build",
    },

    python = { ["hook/cd/directory"] = "%S:h" },

    scilab = {
      command = "scilab-cli",
      exec = { "%c -f %s -quit" },
      ["hook/cd/directory"] = "%S:h",
    },

    markdown = { type = markdown_type },

    ["markdown/mysetting"] = {
      command = "pandoc",
      exec = { "%c %s %o %a -o %s:r.html", "cat %s:r.html" },
      cmdopt = "-f markdown+yaml_metadata_block+east_asian_line_breaks -t html5 -s --self-contained --webtex",
      ["hook/cd/directory"] = "%S:h",
    },

    ["markdown/marp"] = {
      command = "marp",
      exec = { "%c --allow-local-files %s" },
      ["hook/cd/directory"] = "%S:h",
    },

    ["markdown/marp-pdf"] = {
      command = "marp",
      exec = { "%c --pdf --pdf-outlines --allow-local-files %s" },
      ["hook/cd/directory"] = "%S:h",
    },

    javascript = { type = javascript_type },

    ["javascript/deno"] = {
      command = "deno",
      exec = { "%c run -q %s" },
      ["hook/cd/directory"] = "%S:h",
    },

    ["typescript/tsc"] = {
      command = "tsc",
      exec = {
        "%c --target es5 --module commonjs %o %s",
        "node %s:r.js",
      },
      ["hook/sweep/files"] = { "%S:p:r.js" },
    },
  }
end

return M
