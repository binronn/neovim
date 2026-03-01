# Neovim 配置文档

> 基于 Neovim 0.11+ 的个人完整配置，支持 Windows / Linux，使用 lazy.nvim 管理插件。

---

## 目录

- [目录结构](#目录结构)
- [安装教程](#安装教程)
  - [前置依赖](#前置依赖)
  - [Windows 安装](#windows-安装)
  - [Linux 安装](#linux-安装)
- [LSP 配置](#lsp-配置)
  - [C/C++ (clangd)](#cc-clangd)
  - [Python (pyright)](#python-pyright)
  - [TypeScript/JavaScript (ts_ls)](#typescriptjavascript-ts_ls)
  - [C# (OmniSharp)](#c-omnisharp)
  - [动态切换编译器](#动态切换编译器)
- [插件列表](#插件列表)
- [快捷键总览](#快捷键总览)
  - [基础操作](#基础操作)
  - [窗口管理](#窗口管理)
  - [缓冲区操作](#缓冲区操作)
  - [LSP 相关](#lsp-相关)
  - [Telescope 搜索](#telescope-搜索)
  - [文件树 Neo-tree](#文件树-neo-tree)
  - [符号大纲 Aerial](#符号大纲-aerial)
  - [Git 操作](#git-操作)
  - [调试 DAP](#调试-dap)
  - [书签 Bookmarks](#书签-bookmarks)
  - [高亮 Mark](#高亮-mark)
  - [终端 FTerm](#终端-fterm)
  - [AI 助手 CodeCompanion](#ai-助手-codecompanion)
  - [补全 nvim-cmp](#补全-nvim-cmp)
  - [会话管理](#会话管理)
  - [构建项目](#构建项目)
- [主题配置](#主题配置)
- [自定义命令](#自定义命令)
- [常见问题](#常见问题)

---

## 目录结构

```
nvim/
├── init.vim                        # 入口文件，设置 mapleader，加载 lua/init.lua
├── ginit.vim                       # GUI 初始化（nvim-qt 等）
├── .clang-format                   # C/C++ 格式化配置
└── lua/
    ├── init.lua                    # 核心入口：lazy.nvim 初始化，加载顺序定义
    ├── plugins.lua                 # 插件定义列表（lazy.nvim spec）
    ├── keymaps.lua                 # 全局快捷键映射
    ├── autocmd.lua                 # 自动命令（构建、会话、路径修复等）
    ├── keymap_help.lua             # 快捷键辅助函数封装
    ├── common_func.lua             # 通用函数（工作区目录、ctags 等）
    ├── projects_template.lua       # 新建项目模板
    └── config/
        ├── basic.lua               # 基础 vim 选项配置
        ├── lsp.lua                 # LSP 配置（clangd, pyright, ts_ls, omnisharp）
        ├── compiles.lua            # 编译器路径管理（动态切换工具链）
        ├── dap.lua                 # DAP 调试配置（GDB / codelldb）
        ├── plugins.lua             # 各插件的 setup 函数
        ├── luasnip.lua             # LuaSnip 代码片段配置
        ├── avante.lua              # Avante AI 插件配置（已注释）
        └── codecomp/
            ├── codecomp.lua        # CodeCompanion 主配置（lualine 集成）
            ├── adapters.lua        # AI 适配器配置（OpenAI 兼容接口）
            ├── extensions.lua      # 插件扩展
            ├── mcp/base.lua        # MCP 协议配置
            ├── prompt_library/     # 提示词库
            │   ├── base.lua
            │   └── commit_message.lua
            ├── rules/base.lua      # AI 规则配置
            └── tools/
                ├── calculator.lua  # 计算器工具
                └── run_command.lua # 运行命令工具
```

---

## 安装教程

### 前置依赖

#### 必须安装的工具

| 工具 | 用途 | 安装方式 |
|------|------|----------|
| **Neovim 0.11+** | 编辑器本体 | [官网下载](https://github.com/neovim/neovim/releases) |
| **Git** | 插件管理、版本控制 | [git-scm.com](https://git-scm.com) |
| **ripgrep (rg)** | Telescope 全文搜索后端 | `winget install BurntSushi.ripgrep.MSVC` |
| **make** | telescope-fzf-native 编译 | MinGW / msys2 内置 |
| **Nerd Fonts** | 图标字体（任意一款） | [nerdfonts.com](https://www.nerdfonts.com) |
| **Node.js + npm** | TypeScript LSP、lua-fmt | [nodejs.org](https://nodejs.org) |
| **Python 3** | Pyright LSP、部分插件 | [python.org](https://www.python.org) |

#### LSP 工具安装

| LSP | 语言 | 安装命令 |
|-----|------|----------|
| **clangd** | C/C++ | 随 LLVM/Clang 发行包安装 |
| **clang-format** | C/C++ 格式化 | 随 LLVM 安装 |
| **pyright-langserver** | Python | `npm install -g pyright` |
| **typescript-language-server** | TS/JS | `npm install -g typescript typescript-language-server` |
| **OmniSharp** | C# | 下载放置到 `../nvim-tools/omnisharp/OmniSharp.exe` |

#### 可选工具

| 工具 | 用途 |
|------|------|
| **codelldb** | C/C++ 调试适配器（推荐） |
| **GDB** | C/C++ 调试替代方案（Windows 需设置 `gdb_path` 环境变量） |
| **claude CLI** | Claude AI 终端 |
| **gemini CLI** | Gemini AI 终端 |
| **aider** | Aider AI 终端 |
| **ctags / universal-ctags** | 代码标签索引 |
| **compiledb** | Makefile 项目生成 compile_commands.json |

---

### Windows 安装

**1. 克隆配置**

```powershell
git clone <your-repo-url> $env:LOCALAPPDATA\nvim
```

或者将配置放在：
```
C:\SoftFolder\develop_env\nvim-win64\nvim-config\nvim\
```
然后在 `$env:LOCALAPPDATA\nvim` 创建符号链接：
```powershell
New-Item -ItemType SymbolicLink -Path "$env:LOCALAPPDATA\nvim" -Target "C:\SoftFolder\develop_env\nvim-win64\nvim-config\nvim"
```

**2. 安装 ripgrep**

```powershell
winget install BurntSushi.ripgrep.MSVC
# 或通过 scoop
scoop install ripgrep
```

**3. 安装 Nerd Font**

下载 [JetBrainsMono Nerd Font](https://www.nerdfonts.com/font-downloads) 并在终端中设置该字体。

**4. 设置编译器环境变量（C/C++）**

在系统环境变量中配置：
```
COMPILERS=C:\path\to\your\compilers\folder
```
`COMPILERS` 目录下每个子文件夹代表一个工具链，例如：
```
COMPILERS/
├── llvm-19.0/
│   └── bin/
│       ├── clang++.exe
│       ├── clang.exe
│       └── clangd.exe
└── mingw-gcc-13/
    └── bin/
        ├── g++.exe
        └── gcc.exe
```

**5. 设置 GDB 路径（Windows 调试）**

```powershell
[Environment]::SetEnvironmentVariable("gdb_path", "C:\path\to\gdb\bin", "User")
```

**6. 设置 codelldb 路径（Windows 调试）**

将 codelldb 解压后放置路径，并设置环境变量：
```powershell
[Environment]::SetEnvironmentVariable("DEVELOP_BASE", "C:\your\develop\base\", "User")
# codelldb 路径：%DEVELOP_BASE%codelldb\extension\adapter\codelldb.exe
```

**7. 安装 OmniSharp（C#）**

将 OmniSharp 放置到：
```
<nvim-config-parent-dir>/nvim-tools/omnisharp/OmniSharp.exe
```

**8. 首次启动 Neovim**

```powershell
nvim
```
lazy.nvim 会自动安装，插件将自动下载，`nvim-treesitter` 将编译语法解析器。

---

### Linux 安装

**1. 克隆配置**

```bash
git clone <your-repo-url> ~/.config/nvim
```

**2. 安装依赖**

```bash
# Ubuntu/Debian
sudo apt install ripgrep nodejs npm python3 python3-pip clang clangd clang-format

# Arch Linux
sudo pacman -S ripgrep nodejs npm python clang

# 安装 Pyright
npm install -g pyright

# 安装 TypeScript LSP
npm install -g typescript typescript-language-server
```

**3. 安装 codelldb（Linux 调试）**

```bash
# 下载 codelldb VSIX 并解压
# https://github.com/vadimcn/codelldb/releases
unzip codelldb.vsix -d ~/codelldb
# 配置路径在 config/dap.lua 中：
# command = "/home/<user>/codelldb/extension/adapter/codelldb"
```

**4. 首次启动**

```bash
nvim
```

---

## LSP 配置

LSP 配置文件位于 `lua/config/lsp.lua`，使用原生 `vim.lsp` API（无需 nvim-lspconfig 的 `setup()`）。

### C/C++ (clangd)

**要求：** `clangd` 可执行文件在 PATH 中（或通过 `Comps` 命令动态切换）。

**特性：**
- 自动索引（background-index）
- clang-tidy 静态分析
- 详细补全样式
- 自动识别 `compile_commands.json`、`.git`、`CMakeLists.txt` 作为项目根
- 支持 C, C++, ObjC, ObjC++, CUDA, Proto 等

**clangd 启动参数：**
```
--limit-results=20
--background-index=true
--clang-tidy
--compile-commands-dir=build
--pch-storage=memory
--header-insertion=never
--completion-style=detailed
--function-arg-placeholders
--header-insertion-decorators
-j=6
--query-driver=<compiler_path>
```

**项目根标记文件：** `.git`, `compile_commands.json`, `CMakeLists.txt`

### Python (pyright)

**要求：** `pyright-langserver` 已安装（`npm install -g pyright`）。

**特性：**
- 懒加载模式，按项目根目录缓存配置，避免重复启动
- 自动检测虚拟环境（按优先级：`.venv_win` → `.venv_wsl` → `.venv`）
- 项目根标记：`.git`, `pyproject.toml`, `setup.py`, `requirements.txt`, `.venv*`

**排除分析目录：**
- `**/.venv*`, `**/venv*`, `**/env`
- `**/__pycache__`, `**/.pytest_cache`
- `**/build`, `**/dist`, `**/node_modules`

### TypeScript/JavaScript (ts_ls)

**要求：** `typescript-language-server` 已安装。

```bash
npm install -g typescript typescript-language-server
```

**项目根标记：** `package.json`, `tsconfig.json`, `jsconfig.json`, `.git`

### C# (OmniSharp) 弃用

**要求：** `OmniSharp.exe` 放置在以下路径：
```
<nvim_config_parent>/nvim-tools/omnisharp/OmniSharp.exe
```

**特性：**
- 启用分析器支持
- 仅分析打开的文件（减少 CPU 占用）
- 启用导入补全
- 项目根标记：`.root`, `*.sln`, `*.csproj`, `.git`

### 动态切换编译器

在打开 C/C++ 文件后，执行命令：
```vim
:Comps
```
通过 Telescope 选择 `COMPILERS` 环境变量目录下的工具链，支持：
- `clang++.exe` / `clang.exe`
- `clang-cl.exe`
- `g++.exe` / `gcc.exe`

选择后 clangd 会自动重启并使用新编译器。

---

## 插件列表

| 插件 | 功能 |
|------|------|
| `folke/lazy.nvim` | 插件管理器 |
| `nvim-lua/plenary.nvim` | Lua 工具库（依赖） |
| `LunarVim/bigfile.nvim` | 大文件优化（禁用 LSP、treesitter 等） |
| `jiangmiao/auto-pairs` | 自动括号补全 |
| `goolord/alpha-nvim` | 启动界面 |
| `nvim-lualine/lualine.nvim` | 状态栏 |
| `stevearc/aerial.nvim` | 代码符号大纲 |
| `inkarkat/vim-mark` | 多关键词彩色高亮 |
| `numToStr/Comment.nvim` | 注释插件 |
| `MattesGroeger/vim-bookmarks` | 书签管理 |
| `skywind3000/asyncrun.vim` | 异步执行 Shell 命令 |
| `sainnhe/gruvbox-material` | 主题：Gruvbox Material（默认） |
| `AlexvZyl/nordic.nvim` | 主题：Nordic |
| `catppuccin/nvim` | 主题：Catppuccin |
| `rcarriga/nvim-notify` | 通知弹窗 |
| `lewis6991/gitsigns.nvim` | Git 状态侧边栏显示 |
| `nvim-treesitter/nvim-treesitter` | 语法高亮 |
| `numToStr/FTerm.nvim` | 浮动终端 |
| `sindrets/diffview.nvim` | Git Diff/Merge 视图 |
| `tpope/vim-fugitive` | Git 命令集成 |
| `lukas-reineke/indent-blankline.nvim` | 缩进参考线 |
| `nvim-neo-tree/neo-tree.nvim` | 文件树浏览器 |
| `neovim/nvim-lspconfig` | LSP 配置基础框架 |
| `hrsh7th/nvim-cmp` | 自动补全引擎 |
| `hrsh7th/cmp-nvim-lsp` | LSP 补全源 |
| `hrsh7th/cmp-buffer` | Buffer 补全源 |
| `hrsh7th/cmp-path` | 路径补全源 |
| `L3MON4D3/LuaSnip` | 代码片段引擎 |
| `saadparwaiz1/cmp_luasnip` | LuaSnip 补全源 |
| `nvim-telescope/telescope.nvim` | 模糊搜索框架 |
| `nvim-telescope/telescope-fzf-native.nvim` | FZF 加速排序 |
| `nvim-telescope/telescope-file-browser.nvim` | 文件浏览扩展 |
| `nvim-telescope/telescope-live-grep-args.nvim` | 增强全文搜索 |
| `nvim-telescope/telescope-ui-select.nvim` | UI 选择增强 |
| `mfussenegger/nvim-dap` | 调试适配器协议 |
| `rcarriga/nvim-dap-ui` | DAP UI 界面 |
| `theHamsta/nvim-dap-virtual-text` | 调试变量虚拟文字显示 |
| `nvim-telescope/telescope-dap.nvim` | Telescope DAP 集成 |
| `stevearc/dressing.nvim` | UI 输入/选择增强 |
| `MeanderingProgrammer/render-markdown.nvim` | Markdown 渲染 |
| `olimorris/codecompanion.nvim` | AI 编程助手 |

---

## 快捷键总览

> **Leader 键 = `<Space>`（空格键）**

### 基础操作

| 快捷键 | 模式 | 功能 |
|--------|------|------|
| `<leader>fs` | Normal | 保存文件 (`:w`) |
| `<leader>fS` | Normal | 保存所有文件 (`:wa`) |
| `<leader>fo` | Normal | 打开文件 (`:e `) |
| `<leader>wq` | Normal | 保存并退出 (`:wq`) |
| `<leader>wQ` | Normal | 保存所有并退出 (`:wqa`) |
| `<leader>fq` | Normal | 强制退出所有 (`:qa!`) |
| `-b` | Normal | 关闭当前 Buffer |
| `qw` | Normal | 关闭当前窗口 (`<C-w>c`) |
| `H` | Normal/Visual | 跳转到行首 (`^`) |
| `L` | Normal/Visual | 跳转到行尾 (`$`) |
| `<C-h>` | Normal/Visual | 括号跳转 (`%`) |
| `<leader>hl` | Normal | 开启搜索高亮 |
| `<leader>hc` | Normal | 关闭搜索高亮 |
| `<leader>hx` | Normal | 以十六进制模式查看文件 |
| `<leader>hr` | Normal | 从十六进制恢复正常模式 |
| `<C-S-v>` | Normal/Insert/Command | 粘贴系统剪贴板 |
| `<Esc>` | Terminal | 退出终端模式到 Normal |

### 窗口管理

| 快捷键 | 模式 | 功能 |
|--------|------|------|
| `<leader>wk` | Normal | 切换到上方窗口 |
| `<leader>wl` | Normal | 切换到右方窗口 |
| `<leader>wh` | Normal | 切换到左方窗口 |
| `<leader>wj` | Normal | 切换到下方窗口 |
| `<leader>wp` | Normal | 切换到上一个窗口 |
| `<leader>w=` | Normal | 均等化窗口大小 |
| `<leader>wm` | Normal | 最大化当前窗口宽度 |
| `<leader>wK` | Normal | 将窗口移动到顶部 |
| `<leader>wL` | Normal | 将窗口移动到右侧 |
| `<leader>wH` | Normal | 将窗口移动到左侧 |
| `<leader>wJ` | Normal | 将窗口移动到底部 |
| `<leader>wo` | Normal | 仅保留当前窗口 |
| `<leader>ws` | Normal | 调整窗口宽度 (`:vertical resize `) |
| `<leader>wv` | Normal | 调整窗口高度 (`:resize `) |
| `<leader>ls` | Normal | 上一个文件垂直分屏 |
| `<leader>lv` | Normal | 上一个文件水平分屏 |
| `<leader>lo` | Normal | 跳转到上一个文件 |
| `<leader>wc` | Normal | 关闭 QuickFix 窗口 |

### 缓冲区操作

| 快捷键 | 模式 | 功能 |
|--------|------|------|
| `]b` | Normal | 下一个 Buffer |
| `[b` | Normal | 上一个 Buffer |
| `=b` | Normal | 切换到交替 Buffer |

### 选区包裹

| 快捷键 | 模式 | 功能 |
|--------|------|------|
| `S"` | Visual | 用双引号包裹选区 |
| `S(` | Visual | 用圆括号包裹选区 |
| `S{` | Visual | 用花括号包裹选区 |

### 缩进

| 快捷键 | 模式 | 功能 |
|--------|------|------|
| `<<` | Visual | 向左缩进并保持选中 |
| `>>` | Visual | 向右缩进并保持选中 |

---

### LSP 相关

> 以下快捷键在 LSP 附加到 Buffer 时生效

| 快捷键 | 模式 | 功能 |
|--------|------|------|
| `gd` | Normal | 跳转到定义（Telescope） |
| `gi` | Normal | 跳转到实现（Telescope） |
| `gr` | Normal | 查找引用（Telescope） |
| `gl` | Normal | 文档符号列表（Telescope） |
| `ga` | Normal | 工作区符号搜索（Telescope） |
| `K` | Normal | 显示悬停文档 |
| `<leader>rn` | Normal | 重命名符号 |
| `<leader>fx` | Normal | 代码操作（Code Action） |
| `<M-k>` | Insert | 显示函数签名帮助 |
| `]e` | Normal | 跳转到下一个错误 |
| `[e` | Normal | 跳转到上一个错误 |
| `]d` | Normal | 跳转到下一个警告 |
| `[d` | Normal | 跳转到上一个警告 |
| `<leader>ff` | Normal | 格式化文件（C/C++ 使用 clang-format） |
| `<leader>hs` | Normal | C/C++ 头文件↔源文件切换（clangd） |
| `<leader>hS` | Normal | 搜索对应头文件/源文件（Telescope） |

---

### Telescope 搜索

| 快捷键 | 模式 | 功能 |
|--------|------|------|
| `<leader>sb` | Normal | 搜索已打开的 Buffer |
| `<leader>sf` | Normal | 在工作区搜索文件 |
| `<leader>sF` | Normal | 搜索所有文件（含隐藏文件，忽略 .gitignore） |
| `<leader>sw` | Normal | 在工作区全文搜索（live grep） |
| `<leader>sc` | Normal | 在当前文件所在目录全文搜索 |
| `<leader>sd` | Normal | 搜索光标下的单词（全文搜索） |
| `<leader>sl` | Normal | 当前 Buffer 模糊搜索 |
| `<leader>ss` | Normal | 搜索光标下的 Tag |
| `<leader>st` | Normal | 搜索所有 Tags |
| `<leader>sg` | Normal | 生成 ctags |
| `<leader>sw` | Visual | 搜索选中文本（全文搜索） |
| `<F1>` | Normal/Insert | 快速打开 Telescope 命令行 |

---

### 文件树 Neo-tree

| 快捷键 | 模式 | 功能 |
|--------|------|------|
| `<F3>` | Normal | 切换 Neo-tree 文件树显示/隐藏 |
| `<CR>` / `oo` | Neo-tree | 打开文件或目录 |

---

### 符号大纲 Aerial

| 快捷键 | 模式 | 功能 |
|--------|------|------|
| `<F2>` | Normal | 切换 Aerial 符号大纲 |
| `<CR>` | Aerial | 跳转到符号 |
| `p` | Aerial | 预览符号 |
| `q` | Aerial | 关闭大纲 |
| `o` / `za` | Aerial | 展开/折叠节点 |
| `O` / `zA` | Aerial | 递归展开/折叠 |
| `h` / `zc` | Aerial | 折叠节点 |
| `l` / `zo` | Aerial | 展开节点 |
| `{` / `}` | Aerial | 上一个/下一个符号 |
| `[[` / `]]` | Aerial | 上一级/下一级符号 |
| `<C-j>` | Aerial | 向下滚动并跳转 |
| `<C-k>` | Aerial | 向上滚动并跳转 |

---

### Git 操作

| 快捷键 | 模式 | 功能 |
|--------|------|------|
| `<leader>gr` | Normal | 刷新 Git 状态 (Gitsigns) |
| `<leader>gb` | Normal | 显示当前行 Git blame |
| `<leader>gi` | Normal | 预览当前 Hunk |
| `<leader>gd` | Normal | 打开 Git Diff 分屏 |
| `gkn` | Normal | 跳到下一个 Git Hunk |
| `gkp` | Normal | 跳到上一个 Git Hunk |
| `gku` | Normal | 重置当前 Hunk |
| `gks` | Normal | 暂存当前 Hunk |
| `:G` | Command | vim-fugitive Git 状态 |
| `:DiffviewOpen` | Command | 打开全项目 Git Diff 视图 |
| `:DiffviewFileHistory` | Command | 文件提交历史 |

#### DiffView 内快捷键

| 快捷键 | 功能 |
|--------|------|
| `<Tab>` | 下一个文件 |
| `<S-Tab>` | 上一个文件 |
| `<leader>co` | 选择 OURS 版本（冲突解决） |
| `<leader>ct` | 选择 THEIRS 版本（冲突解决） |
| `<leader>cb` | 选择 BASE 版本（冲突解决） |
| `<leader>ca` | 接受所有版本 |
| `[x` / `]x` | 上一个/下一个冲突 |
| `s` / `-` | Stage / Unstage 文件 |
| `S` | Stage 所有文件 |
| `U` | Unstage 所有文件 |

---

### 调试 DAP

> 调试快捷键在调试会话启动后才生效，退出调试后自动恢复

| 快捷键 | 模式 | 功能 |
|--------|------|------|
| `<F9>` | Normal | 切换断点 |
| `<C-F9>` | Normal | 设置条件断点 |
| `<leader>dr` | Normal | 启动调试会话 |
| `<leader>dR` | Normal | 重新选择可执行文件启动调试 |
| `<leader>db` | Normal | 查看断点列表（Telescope） |
| `<leader>dc` | Normal | 查看 DAP 命令列表（Telescope） |
| `<F5>` | Normal | 继续执行（调试中） |
| `<F7>` | Normal | 单步进入（调试中） |
| `<F8>` | Normal | 单步跳过（调试中） |
| `<F4>` | Normal | 运行到光标处（调试中） |
| `I` | Normal | 查看光标下表达式的值（调试中） |
| `<leader>dk` | Normal | 关闭调试会话（调试中） |
| `<leader>1~9` | Normal | 切换调试 UI 窗口（调试中） |

#### DAP 调试器配置

**Linux/macOS：** 使用 `codelldb`（推荐），路径：
```
~/codelldb/extension/adapter/codelldb
```
回退为 `gdb --interpreter=dap`

**Windows：** 使用 `codelldb`，路径：
```
%DEVELOP_BASE%codelldb\extension\adapter\codelldb.exe
```
回退为 `%gdb_path%\gdb.exe --interpreter=dap`

#### 调试 UI 布局

- **左侧面板（宽度 40）：** Watches（20%）、Breakpoints（25%）、Call Stack（25%）、Scopes（30%）
- **底部面板（高度 20）：** REPL（50%）、Console（50%）
- 调试会话在新 Tab 中打开，退出后自动关闭 Tab

---

### 书签 Bookmarks

| 快捷键 | 模式 | 功能 |
|--------|------|------|
| `mm` | Normal | 切换书签 |
| `mi` | Normal | 添加书签注释 |
| `ma` | Normal | 显示所有书签 |
| `mp` | Normal | 跳到上一个书签 |
| `mn` | Normal | 跳到下一个书签 |
| `mc` | Normal | 清除当前行书签 |
| `<leader>mx` | Normal | 清除所有书签 |

> 书签自动保存到工作目录（`vim.g.bookmark_save_per_working_dir = 1`）

---

### 高亮 Mark (vim-mark)

| 快捷键 | 模式 | 功能 |
|--------|------|------|
| `<leader>mh` | Normal | 高亮/设置当前词 |
| `<leader>mH` | Normal | 切换当前词高亮 |
| `<leader>mr` | Normal/Visual | 通过正则表达式高亮 |
| `<leader>mn` | Normal | 清除当前词高亮 |
| `<leader>mN` | Normal | 清除所有高亮 |

---

### 终端 FTerm

| 快捷键 | 模式 | 功能 |
|--------|------|------|
| `<A-``>` | Normal/Terminal | 切换主终端（bash/cmd） |
| `<A-1>` | Normal/Terminal | 切换 Claude AI 终端 |
| `<A-2>` | Normal/Terminal | 切换 Gemini AI 终端 |
| `<A-3>` | Normal/Terminal | 切换 Aider AI 终端 |
| `<A-x>` | Terminal | 强制关闭当前终端进程（Kill） |

> 各终端互斥显示，切换时自动关闭其他终端。

---

### AI 助手 CodeCompanion

| 快捷键 | 模式 | 功能 |
|--------|------|------|
| `<M-c>` | Normal | 切换 AI 聊天窗口 |
| `<M-c>` | Visual | 将选中内容发送到 AI |
| `<leader>ce` | Normal/Visual | 内联 AI 命令 (`:CodeCompanion `) |
| `<leader>cs` | Normal | AI 聊天命令 (`:CodeCompanionChat `) |
| `<leader>ca` | Normal | AI 操作菜单 |

**Chat 内快捷键：**

| 快捷键 | 功能 |
|--------|------|
| `<Enter>` (Normal) | 发送消息 |
| `<C-s>` (Insert) | 发送消息 |
| `<C-c>` | 关闭聊天 |

**Command 模式缩写：**
- 输入 `cc<Space>` 自动扩展为 `CodeCompanion`

---

### 补全 nvim-cmp

| 快捷键 | 模式 | 功能 |
|--------|------|------|
| `<Tab>` | Insert/Select | 选择下一个补全项 |
| `<S-Tab>` | Insert/Select | 选择上一个补全项 |
| `<M-j>` | Insert/Select | 确认选中补全项 / 触发补全 |
| `<M-l>` | Insert/Select | LuaSnip：跳到下一个占位符 |
| `<M-h>` | Insert/Select | LuaSnip：跳到上一个占位符 |

---

### 会话管理

| 命令 | 功能 |
|------|------|
| `:Ss` | 保存当前会话到工作目录 `Session.vim` |
| `:Sq` | 保存当前会话并退出 |
| `:Ls` | 加载工作目录中的会话 |

> 启动界面按 `s` 可选择���近工作区（保存在 `$LOCALAPPDATA\nvim-data\work_dirs`）

---

### 构建项目

> 在 C/C++ 文件中生效（`.c`, `.cpp`, `.h`, `.hpp`, `.cxx`）

| 命令 | 功能 |
|------|------|
| `:Cb` | 构建项目（Debug 模式） |
| `:Cg` | 生成 CMake 构建文件（Debug） |
| `:Cgr` | 生成 CMake 构建文件（Release） |

**构建逻辑（自动判断）：**
1. 若 `build/` 目录已有 `Makefile` → 直接 `make -j4`
2. 若根目录有 `CMakeLists.txt` → 创建 `build/` 目录并运行 `cmake` + `make`
3. 若根目录有 `Makefile` → 直接 `make -j4`
4. 否则 → 直接编译当前文件

**命令行工具缩写：**

| 缩写 | 展开 | 功能 |
|------|------|------|
| `Ar<Space>` | `AsyncRun ` | 异步执行 Shell 命令 |
| `As` | `AsyncStop` | 停止异步任务 |
| `Rw` | `lua vim.g.reset_workspace_dir.get()` | 重置工作目录 |
| `Rg` | `cd %:h \| lua vim.g.reset_workspace_dir_nop()` | 切换到文件目录 |

---

## 主题配置

默认主题：**gruvbox-material**（在 `lua/init.lua` 中设置）

```lua
vim.g.colorscheme = 'gruvbox-material'
```

**可用主题：**

| 主题 | 插件 |
|------|------|
| `gruvbox-material` | `sainnhe/gruvbox-material`（默认） |
| `nordic` | `AlexvZyl/nordic.nvim` |
| `catppuccin` / `catppuccin-mocha` 等 | `catppuccin/nvim` |

**切换主题：**
```vim
:colorscheme nordic
:colorscheme catppuccin-mocha
```

---

## 自定义命令

| 命令 | 功能 |
|------|------|
| `:Comps` | 切换 C/C++ 编译器工具链（Telescope 选择） |
| `:Ss` | 保存会话 |
| `:Ls` | 加载会话 |
| `:Sq` | 保存并退出 |
| `:Cb` | 构建项目（C/C++） |
| `:Cg` | CMake 生成（Debug） |
| `:Cgr` | CMake 生成（Release） |
| `:AsyncRun <cmd>` | 异步运行 Shell 命令（结果显示在 QuickFix） |
| `:AsyncStop` | 停止 AsyncRun 任务 |
| `:DiffviewOpen` | 打开 Git Diff 视图 |
| `:DiffviewClose` | 关闭 Git Diff 视图 |
| `:DiffviewFileHistory` | 文件提交历史 |
| `:AerialOpen` | 打开符号大纲 |
| `:AerialClose` | 关闭符号大纲 |
| `:CodeCompanionChat` | 打开/切换 AI 聊天 |
| `:CodeCompanionActions` | 打开 AI 操作菜单 |
| `:Telescope` | 打开 Telescope 主界面 |

---

## 常见问题

### 图标显示为乱码

请确认终端和编辑器字体已设置为 Nerd Font（如 JetBrainsMono Nerd Font）。

### clangd 无法启动

1. 确保 `clangd` 在 PATH 中可执行：`clangd --version`
2. 或使用 `:Comps` 命令选择编译器工具链
3. 项目根目录需要有 `compile_commands.json`（可通过 `cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON` 生成）

### telescope-fzf-native 编译失败

需要安装 `make` 和 C 编译器。Windows 上建议使用 MinGW：
```powershell
scoop install mingw
```

### Python LSP 没有找到虚拟环境

在项目根目录创建以下任一虚拟环境：
```bash
python -m venv .venv        # Linux/macOS
python -m venv .venv_win    # Windows 专用
python -m venv .venv_wsl    # WSL 专用
```

### 调试器无法启动（Windows）

1. 确认 `DEVELOP_BASE` 环境变量已设置
2. 确认 codelldb 路径正确：`%DEVELOP_BASE%codelldb\extension\adapter\codelldb.exe`
3. 或设置 `gdb_path` 环境变量指向 GDB 的 bin 目录

### 大文件打开很慢

已配置 `bigfile.nvim`，超过 1MB 的 `.txt`、`.log`、`.csv`、`.cpp`、`.py` 文件会自动禁用 LSP、Treesitter、indent-blankline 等影响性能的功能。

### 工作区目录不对

执行命令重置：
```vim
:Rw
```
或在命令行输入 `Rw<CR>`。

---

> 配置持续更新中，如有问题欢迎反馈。
