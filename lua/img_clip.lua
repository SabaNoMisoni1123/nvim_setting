-- lua/img_clip.lua
-- https://github.com/hakonharnes/img-clip.nvim?tab=readme-ov-file#setup

local M = {}

function M.opts()
  -- 共通設定（default）
  local default = {
    dir_path = "img", -- 画像保存先
    extension = "png",
    file_name = "%Y%m%d_%H%M_%S",

    use_absolute_path = false,
    relative_to_current_file = false,

    template = "$FILE_PATH", -- filetype側で上書きする前提
    url_encode_path = false,
    relative_template_path = true,

    use_cursor_in_template = true,
    insert_mode_after_paste = true,
    insert_template_after_cursor = true,

    prompt_for_file_name = true,
    show_dir_path_in_prompt = false,

    process_cmd = "", -- 例: "magick convert $FILE_PATH -resize 1200x1200\\> $FILE_PATH"
    copy_images = false,
    download_images = true,
    formats = { "jpeg", "jpg", "png" },

    drag_and_drop = {
      enabled = true,
      insert_mode = false,
    },

    verbose = true,
  }

  -- filetype別（READMEの例をベースに必要最低限）
  local filetypes = {
    markdown = {
      url_encode_path = true,
      template = "![$CURSOR]($FILE_PATH)",
      download_images = false,
    },
    vimwiki = { -- markdown互換に寄せる例
      url_encode_path = true,
      template = "![$CURSOR]($FILE_PATH)",
      download_images = false,
    },
    tex = {
      relative_template_path = false,
      template = [[
\begin{figure}[h]
  \centering
  \includegraphics[width=0.8\textwidth]{$FILE_PATH}
  \caption{$CURSOR}
  \label{fig:$LABEL}
\end{figure}
      ]],
      formats = { "jpeg", "jpg", "png", "pdf" },
    },
    typst = {
      template = [[#figure(image("$FILE_PATH"), caption: [$CURSOR])]],
    },
    html = {
      template = '<img src="$FILE_PATH" alt="$CURSOR">',
    },
  }

  return {
    default = default,
    filetypes = filetypes,
  }
end

return M
