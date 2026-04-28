# AGENTS.md

このリポジトリは Neovim の個人設定です。回答は日本語で行い、実装・説明では Neovim v0.11.4 を前提にしてください。

## 基本方針

- 変更前にリポジトリ内の実ファイルを確認し、既存の構成と書き方を優先する。
- Neovim 本体、Lua API、プラグイン API、設定項目について判断するときは、可能な限り Context7 MCP で最新または対象バージョンのドキュメントを確認する。
- プロジェクト固有の挙動は外部ドキュメントよりこのリポジトリ内のファイルを優先する。
- 既存の未コミット変更はユーザーの作業として扱い、明示依頼なしに戻さない。
- 不要な大規模リファクタリングやプラグインの入れ替えは避け、依頼された目的に対して最小限で一貫した変更にする。

## 対象バージョン

- Neovim: v0.11.4
- 設定言語: Lua
- プラグイン管理: lazy.nvim
- LSP 設定: Neovim 0.11 系の `vim.lsp.config()` と `vim.lsp.enable()` を前提にする。

## リポジトリ構成

- `init.lua`: 起動時の入口。WSL/PATH、クリップボード、leader、provider、各 Lua モジュールの読み込みを扱う。
- `lua/plugins.lua`: lazy.nvim の bootstrap とプラグイン定義を集約する。
- `lua/lsp.lua`: LSP 全体設定。サーバー有無を確認し、`vim.lsp.config()` / `vim.lsp.enable()` で有効化する。
- `lua/set.lua`: Neovim オプション設定。
- `lua/mapping.lua`: グローバルキーマップ。
- `lua/autocmd.lua`: autocmd。
- `lua/ftmapping.lua`: filetype 固有のキーマップ。
- `lua/nvim_cmp.lua`: nvim-cmp 設定。
- `lua/nvim_tree.lua`, `lua/lua_line.lua`, `lua/quickrun_config.lua`, `lua/pantran_config.lua`, `lua/img_clip.lua`: 各プラグイン・機能の個別設定。
- `lua/lsp/`: LSP 補助設定。
- `lua/overseer/template/`: overseer のテンプレート。
- `lazy-lock.json`: lazy.nvim のロックファイル。プラグイン更新依頼がない限り不用意に変更しない。

## 実装ルール

- Lua は既存スタイルに合わせ、`vim.opt`、`vim.g`、`vim.keymap.set`、`vim.api.nvim_create_autocmd` など Neovim Lua API を使う。
- Neovim 0.11.4 で非推奨の API は新規に増やさない。
  - LSP 診断は `vim.lsp.diagnostic.*` ではなく `vim.diagnostic.*` を使う。
  - 診断ジャンプは `vim.diagnostic.goto_next()` / `goto_prev()` ではなく `vim.diagnostic.jump()` を使う。
- LSP サーバー追加・変更は `lua/lsp.lua` の `enable_if_installed()` の流れに合わせ、外部コマンドが未導入でも起動エラーにしない。
- `nvim-lspconfig` を使う場合も、Neovim 0.11.4 前提では `require("lspconfig").SERVER.setup()` を新規追加せず、`vim.lsp.config()` / `vim.lsp.enable()` を優先する。
- プラグイン追加・変更は原則 `lua/plugins.lua` に集約し、設定が大きくなる場合だけ `lua/` 配下に専用モジュールを分ける。
- キーマップは `vim.keymap.set()` を使い、可能な限り `desc` を付ける。既存キーマップとの衝突を確認してから追加する。
- ファイルタイプ固有の設定は、グローバル設定へ混ぜず `ftmapping.lua`、autocmd、または専用モジュールに寄せる。
- OS/WSL/外部コマンド依存の処理は存在確認を入れ、未導入環境でエラーにならないようにする。

## 検証

- Lua 構文確認には `nvim --headless -u init.lua +qa` を基本にする。
- LSP やプラグインの起動確認が必要な場合は、対象ファイルを指定した headless 起動や `:checkhealth` 相当の確認を行う。
- プラグイン更新や lockfile 変更を伴う場合は、変更理由と影響範囲を明記する。
- 実行できなかった検証がある場合は、その理由を回答に明記する。

## 回答スタイル

- 回答は日本語で簡潔に行う。
- 変更したファイル、主な変更点、実行した検証を最後にまとめる。
- ライブラリ/API/フレームワーク/設定項目に関する提案では、Context7 MCP で確認した内容を必要に応じて反映する。
