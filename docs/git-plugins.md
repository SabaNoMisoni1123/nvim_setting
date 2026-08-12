# Git 関連プラグイン設定メモ

この資料は、現行の Neovim 設定に導入されている Git 関連プラグイン、利用方法、キーマッピングをまとめたものです。

前提:

- Neovim: v0.11.4
- プラグイン管理: lazy.nvim
- 主な定義元: `lua/plugins.lua`
- 表示連携: `lua/lua_line.lua`, `lua/nvim_tree.lua`, `lua/nvim_cmp.lua`
- ロックファイル: `lazy-lock.json`

## 導入プラグイン一覧

| 用途 | プラグイン | 定義元 | lazy-load 条件 | lock commit |
| --- | --- | --- | --- | --- |
| 行単位の Git 差分表示 | `lewis6991/gitsigns.nvim` | `lua/plugins.lua` | `VeryLazy` | `5be654f2232c10ddcad19c1607a67b6b4b78fc29` |
| Git UI | `TimUntersberger/neogit` | `lua/plugins.lua` | `:Neogit` / `<Leader>gs` | `37e0f22a2345bad1bffe01b31970885882f46275` |
| 競合解決補助 | `akinsho/git-conflict.nvim` | `lua/plugins.lua` | GitConflict 系コマンド | `a1badcd070d176172940eb55d9d59029dad1c5a6` |
| diff / 履歴表示 | `sindrets/diffview.nvim` | `lua/plugins.lua` | `<Leader>gd`, `<Leader>gq`, `<Leader>gh`, `<Leader>gH` | `4516612fe98ff56ae0415a259ff6361a89419b0a` |
| Git 差分をスクロールバーへ表示 | `petertriho/nvim-scrollbar` | `lua/plugins.lua` | `:ScrollbarToggle` / `<C-s>` | `f8e87b96cd6362ef8579be456afee3b38fd7e2a8` |

補助的な Git 表示・補完設定:

- `nvim-tree.lua`: ファイルツリー上で Git 状態アイコンを表示する。
- `lualine.nvim`: ブランチ名と gitsigns の差分件数をステータスラインへ表示する。
- `nvim-cmp`: `gitcommit` filetype では `buffer`, `look`, `dictionary` を補完ソースにする。

## gitsigns.nvim

### 目的

Git 管理下のバッファで、追加・変更・削除・未追跡行を signcolumn に表示します。現在は表示に加えて、hunk 単位の移動・preview・stage/reset・blame・quickfix 連携を buffer-local keymap として定義しています。

### 設定内容

`lua/plugins.lua` では `require("gitsigns").setup()` に `signs` を渡しています。

| 種別 | 表示文字 |
| --- | --- |
| 追加 | `│` |
| 変更 | `│` |
| 削除 | `_` |
| 先頭削除 | `‾` |
| 変更 + 削除 | `~` |
| 未追跡 | `┆` |

設定後に `pcall()` で `scrollbar.handlers.gitsigns` を有効化しています。これにより、gitsigns が取得した Git 差分をスクロールバー上にも表示します。

### 使い方

- Git 管理下のファイルを開くと、差分が signcolumn に自動表示されます。
- ステータスラインには、追加・変更・削除件数が ` +N ~N -N` 形式で表示されます。
- スクロールバーを有効化している場合、差分位置もスクロールバー上に表示されます。

| 操作 | キー | 説明 |
| --- | --- | --- |
| 次の hunk へ移動 | `<Leader>gn` | 次の Git 変更箇所へ移動 |
| 前の hunk へ移動 | `<Leader>gN` | 前の Git 変更箇所へ移動 |
| hunk preview | `<Leader>gp` | 現在 hunk の差分を floating window で確認 |
| inline hunk preview | `<Leader>gi` | 現在 hunk の差分をインライン表示 |
| blame line | `<Leader>gb` | 現在行の blame を詳細表示 |
| hunk stage | `<Leader>gS` | 現在 hunk を stage |
| 選択範囲 stage | visual `<Leader>gS` | 選択範囲の hunk を stage |
| hunk reset | `<Leader>gR` | 現在 hunk を reset |
| 選択範囲 reset | visual `<Leader>gR` | 選択範囲の hunk を reset |
| hunk 一覧 | `<Leader>gL` | 全 hunk を quickfix に投入 |
| hunk text object | `ih` | operator / visual mode で hunk を選択 |

## neogit

### 目的

Neovim 内から Git status、stage、commit、push、pull などの操作を行うための Git UI です。

### 設定内容

```lua
require("neogit").setup({ disable_insert_on_commit = true })
```

現行設定では、コミットメッセージ編集時に insert mode へ自動移行しない設定です。

### 使い方

| 操作 | コマンド / キー | 説明 |
| --- | --- | --- |
| Neogit を開く | `:Neogit` | Git UI を開く |
| Neogit を開く | `<Leader>gs` | `:Neogit` を実行 |

設定上の `<Leader>` は `init.lua` 側の leader 設定に従います。

## git-conflict.nvim

### 目的

Git merge / rebase などで発生した conflict marker を検出し、競合箇所のハイライト、採用する変更の選択、競合間ジャンプを補助します。

### 設定内容

```lua
require("git-conflict").setup({})
```

現行設定ではデフォルト設定を使用しています。

`lua/plugins.lua` では次のコマンドを lazy-load 条件にしています。

- `:GitConflictChooseOurs`
- `:GitConflictChooseTheirs`
- `:GitConflictChooseBoth`
- `:GitConflictChooseNone`
- `:GitConflictNextConflict`
- `:GitConflictPrevConflict`
- `:GitConflictEnable`

### 使い方

| 操作 | コマンド | 説明 |
| --- | --- | --- |
| current 側を採用 | `:GitConflictChooseOurs` | 現在側の変更を残す |
| incoming 側を採用 | `:GitConflictChooseTheirs` | 取り込み側の変更を残す |
| 両方採用 | `:GitConflictChooseBoth` | 両方の変更を残す |
| どちらも採用しない | `:GitConflictChooseNone` | 競合ブロックの内容を残さない |
| 次の競合へ移動 | `:GitConflictNextConflict` | 次の conflict marker へ移動 |
| 前の競合へ移動 | `:GitConflictPrevConflict` | 前の conflict marker へ移動 |
| 有効化 | `:GitConflictEnable` | git-conflict を有効化 |

デフォルト設定では、競合検出時にプラグイン側の buffer-local mapping も有効になります。現行のユーザー設定としては、GitConflict 用の独自キーマップは追加していません。

## diffview.nvim

### 目的

Git diff を専用タブページで確認するためのプラグインです。変更ファイル一覧と差分ビューを行き来しながら確認できます。

### 設定内容

現行設定では独自 `setup()` は行わず、プラグインのデフォルト設定を使っています。

### 使い方

| 操作 | コマンド / キー | 説明 |
| --- | --- | --- |
| Diffview を開く | `:DiffviewOpen` | working tree / index の差分を表示 |
| Diffview を開く | `<Leader>gd` | `:DiffviewOpen` を実行 |
| Diffview を閉じる | `:DiffviewClose` | Diffview のタブページを閉じる |
| Diffview を閉じる | `<Leader>gq` | `:DiffviewClose` を実行 |
| 現在ファイルの履歴 | `<Leader>gh` | `:DiffviewFileHistory %` を実行 |
| repository / path 履歴 | `<Leader>gH` | `:DiffviewFileHistory` を実行 |

追加で、コマンド引数に revision や範囲を渡すことで過去 commit や branch 間の差分も確認できます。

例:

```vim
:DiffviewOpen HEAD~2
:DiffviewOpen origin/main...HEAD
:DiffviewOpen HEAD~2 -- lua/plugins.lua
```

## nvim-scrollbar

### 目的

画面右側にスクロールバーを表示し、現在位置や Git 差分位置を視覚的に把握しやすくします。Git 差分表示は `gitsigns.nvim` との連携です。

### 設定内容

`lua/plugins.lua` では `require("scrollbar").setup()` で次の方針にしています。

- アクティブウィンドウ以外でも表示する。
- 全体が見えている場合はハンドルを隠す。
- `CursorColumn` をハンドルの highlight に使う。
- `gitsigns.nvim` の設定後に `scrollbar.handlers.gitsigns` を有効化する。

### 使い方

| 操作 | コマンド / キー | 説明 |
| --- | --- | --- |
| スクロールバー表示切替 | `:ScrollbarToggle` | 表示 / 非表示を切り替える |
| スクロールバー表示切替 | `<C-s>` | `:ScrollbarToggle` を実行 |

注意:

- `nvim-tree` バッファ内では buffer-local に `<C-s>` が水平分割で開く操作へ割り当てられています。
- そのため通常バッファでは `<C-s>` は ScrollbarToggle、nvim-tree 上では水平分割 open として動作します。

## 表示連携

### lualine

`lua/lua_line.lua` では Git に関して次を表示します。

- `lualine_b`: 現在ブランチ名を `branch` コンポーネントで表示。
- `lualine_b`: `.git` などを探索してプロジェクトルート名を表示。
- `lualine_x`: `vim.b.gitsigns_status_dict` が存在する場合、追加・変更・削除件数を表示。
- `tabline.lualine_b`: ブランチ名を表示。

`vim.b.gitsigns_status_dict` は gitsigns がバッファへ設定する情報で、`added`, `changed`, `removed` を使っています。

### nvim-tree

`lua/nvim_tree.lua` では Git 状態表示について次を設定しています。

```lua
git = {
  ignore = false
},
renderer = {
  icons = {
    git_placement = "after"
  },
}
```

これにより、`.gitignore` 対象もツリーに表示し、Git 状態アイコンはファイル名の後ろに配置されます。

### nvim-cmp

`lua/nvim_cmp.lua` では `gitcommit` filetype の補完ソースを専用設定しています。

```lua
cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'buffer' },
    { name = 'look' },
    { name = 'dictionary' },
  })
})
```

コミットメッセージ編集時は、バッファ内単語、`look`、辞書補完が使われます。

## Telescope Git picker

Telescope の Git 組み込み picker も `<Leader>g` 配下に追加しています。

| 操作 | キー | 説明 |
| --- | --- | --- |
| Git 管理ファイル検索 | `<Leader>gf` | `telescope.builtin.git_files()` |
| commit 検索 | `<Leader>gc` | `telescope.builtin.git_commits()` |
| 現在バッファの commit 検索 | `<Leader>gC` | `telescope.builtin.git_bcommits()` |
| branch 検索 | `<Leader>gB` | `telescope.builtin.git_branches()` |

## Git 関連キーマップ一覧

| モード | キー | 実行内容 | 定義元 | 備考 |
| --- | --- | --- | --- | --- |
| normal | `<Leader>gs` | `<Cmd>Neogit<CR>` | `lua/plugins.lua` | Neogit を開く |
| normal | `<Leader>gd` | `<Cmd>DiffviewOpen<CR>` | `lua/plugins.lua` | Diffview を開く |
| normal | `<Leader>gq` | `<Cmd>DiffviewClose<CR>` | `lua/plugins.lua` | Diffview を閉じる |
| normal | `<Leader>gh` | `<Cmd>DiffviewFileHistory %<CR>` | `lua/plugins.lua` | 現在ファイルの履歴 |
| normal | `<Leader>gH` | `<Cmd>DiffviewFileHistory<CR>` | `lua/plugins.lua` | Git 履歴 |
| normal | `<Leader>gf` | `telescope.builtin.git_files()` | `lua/plugins.lua` | Git 管理ファイル検索 |
| normal | `<Leader>gc` | `telescope.builtin.git_commits()` | `lua/plugins.lua` | commit 検索 |
| normal | `<Leader>gC` | `telescope.builtin.git_bcommits()` | `lua/plugins.lua` | 現在バッファの commit 検索 |
| normal | `<Leader>gB` | `telescope.builtin.git_branches()` | `lua/plugins.lua` | branch 検索 |
| normal | `<Leader>gn` | `gitsigns.nav_hunk("next")` | `lua/plugins.lua` | 次の hunk |
| normal | `<Leader>gN` | `gitsigns.nav_hunk("prev")` | `lua/plugins.lua` | 前の hunk |
| normal | `<Leader>gp` | `gitsigns.preview_hunk()` | `lua/plugins.lua` | hunk preview |
| normal | `<Leader>gi` | `gitsigns.preview_hunk_inline()` | `lua/plugins.lua` | inline hunk preview |
| normal | `<Leader>gb` | `gitsigns.blame_line({ full = true })` | `lua/plugins.lua` | blame line |
| normal / visual | `<Leader>gS` | `gitsigns.stage_hunk()` | `lua/plugins.lua` | hunk / 選択範囲 stage |
| normal / visual | `<Leader>gR` | `gitsigns.reset_hunk()` | `lua/plugins.lua` | hunk / 選択範囲 reset |
| normal | `<Leader>gL` | `gitsigns.setqflist("all")` | `lua/plugins.lua` | hunk quickfix |
| operator / visual | `ih` | `gitsigns.select_hunk()` | `lua/plugins.lua` | hunk text object |
| normal | `<C-s>` | `<Cmd>ScrollbarToggle<CR>` | `lua/plugins.lua` | 通常バッファでスクロールバー切替 |
| normal, nvim-tree buffer-local | `<C-s>` | `api.node.open.horizontal` | `lua/nvim_tree.lua` | nvim-tree 上では水平分割 open |

## 関連して追加した活用キーマップ

Git 以外でも、既存プラグインの未活用機能を衝突しないキーへ追加しています。

| 分類 | キー | 実行内容 | 説明 |
| --- | --- | --- | --- |
| TODO | `<Leader>fo` | `<Cmd>TodoTelescope<CR>` | todo-comments の Telescope UI |
| TODO | `<Leader>fQ` | `<Cmd>TodoQuickFix<CR>` | TODO 一覧を quickfix に投入 |
| TODO | `<Leader>fL` | `<Cmd>TodoLocList<CR>` | TODO 一覧を location list に投入 |
| Overseer | `<Leader>or` | `<Cmd>OverseerRun<CR>` | task 実行 |
| Overseer | `<Leader>oa` | `<Cmd>OverseerQuickAction<CR>` | task に対する quick action |

## 確認した外部ドキュメント

プラグイン API・コマンド仕様の確認には、可能な範囲で Context7 MCP を使用しました。

- `lewis6991/gitsigns.nvim`: `setup({ signs = ... })` と `b:gitsigns_status_dict` の利用を確認。
- `sindrets/diffview.nvim`: `:DiffviewOpen`, `:DiffviewClose` と revision 指定の使い方を確認。

Context7 で解決できなかったものは、現行リポジトリの実ファイルとプラグイン README 相当の情報をもとに整理しています。
