-- 全局配置
-- 
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.background=dark
vim.g.encoding = "utf-8"
vim.g.ambiwidth=double

-- 设置中文提示
--language messages zh_CN.utf-8
-- 设置中文帮助
vim.g.helplang=cn
------------------------------------------------------------------------------------------
-- jkhl 移动时光标周围保留4行
vim.o.scrolloff=4
vim.o.cursorline=true   --当前行高亮
vim.o.shiftwidth = 4  -- 自动对齐的空格数量
vim.bo.shiftwidth = 4  -- 自动对齐的空格数量

vim.o.autoindent=true
vim.bo.autoindent=true

vim.wo.number=true
vim.wo.relativenumber=true -- 相对行

vim.o.cindent=true
vim.o.smartindent=true
--vim.g.t_Co=256 -- required

-- 缩进4个空格等于一个Tab
vim.o.tabstop=4
vim.bo.tabstop=4
vim.o.softtabstop=4

-- 禁止将tab替换为空格
--vim.o.noexpandtab=true

-- 允许隐藏被修改过的buffer
vim.o.hidden=true

-- vim.g.editing-mode vi
vim.g.nocompatible=true -- 关闭vi兼容
vim.g.backspace=indent,eol,start -- 退格键修复
vim.g.mouse=false  -- xshell复制开启


vim.g.fileformat='unix'
-- vim环境保存与恢复
vim.g.sessionoptions='blank,buffers,globals,localoptions,tabpages,sesdir,folds,help,options,resize,winpos,winsize'
-- 保存 undo 历史
vim.g.undodir='~/.undo_history/'
vim.g.undofile=true
------------------------------------------------------------------------------------------
-- 卡顿解决  有效
vim.o.re=1
vim.o.ttyfast=true
vim.g.lazyredraw=true
-- syntax sync minlines=128
vim.g.nocursorcolumn=true
------------------------------------------------------------------------------------------
vim.g.hidden=true
vim.g.updatetime=200
--vim.g.shortmess+=c
vim.g.noerrorbells=true
-- 禁止自动换行
vim.g.nowrap=true

-- 文件备份问题
vim.g.noswapfile=true
vim.g.nobackup=true
vim.g.undodir='~/.config/undodir'
vim.g.undofile=true

-- 实时显示搜索内容
vim.g.incsearch=true
-- 向下滚动h时预留行数
vim.g.scrolloff=5
-- 强制显示侧边栏，防止时有时无
vim.g.signcolumn=yes
-- 显示最长的列长度为90
--vim.g.colorcolumn=90
-- vim 命令补全
vim.g.wildmenu=true
vim.g.wildmode='longest:full'

-- 补全最多显示10行
vim.o.pumheight = 10
-- 永远显示 tabline
vim.o.showtabline = 2
-- 使用增强状态栏插件后不再需要 vim 的模式提示
vim.o.showmode = false
-- 配置剪切板
vim.opt.clipboard = "unnamedplus"
-- 是否显示不可见字符
vim.o.list = false
-- 不可见字符的显示，这里只把空格显示为一个点
vim.o.listchars = "space:·,tab:··"
-- smaller updatetime
vim.o.updatetime = 300
-- 设置 timeoutlen 为等待键盘快捷键连击时间500毫秒，可根据需要设置
-- 遇到问题详见：https://github.com/nshen/learn-neovim-lua/issues/1
vim.o.timeoutlen = 500
-- 语法开启
vim.g.syntax=true
-- 主题设置
--vim.g.material_style = "deep ocean"
vim.cmd 'colorscheme gruvbox'

-- 强制显示侧边栏，防止时有时无
vim.cmd 'set signcolumn=yes'

-- 代码折叠问题
vim.cmd "set foldmethod=indent"
vim.cmd 'set foldlevel=99'
vim.cmd 'set mouse='
