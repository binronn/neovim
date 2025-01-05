
------------------
---- 通用函数 ----
------------------
--
-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",
--
function map(mode, shortcut, command)
  vim.api.nvim_set_keymap(mode, shortcut, command, { noremap = true, silent = true })
end

function nmap(shortcut, command)
  map('n', shortcut, command)
end

function vmap(shortcut, command)
  map('v', shortcut, command)
end

function xmap(shortcut, command)
  map('x', shortcut, command)
end

function cmap(shortcut, command)
  vim.api.nvim_set_keymap('c', shortcut, command, { noremap = true, silent = false })
end

function imap(shortcut, command)
  map('i', shortcut, command)
end

-- 定义 nmap 函数
local function nmap2(key, cmd, opts)
  opts = opts or {}
  opts.desc = opts.desc or ""
  vim.keymap.set('n', key, cmd, opts)
end

-- 定义 vmap 函数
local function vmap2(key, cmd, opts)
  opts = opts or {}
  opts.desc = opts.desc or ""
  vim.keymap.set('v', key, cmd, opts)
end

-- 定义 vmap2 函数
local function vmap2x(keys, command, opts)
  opts = opts or {}
  opts.noremap = opts.noremap == nil and true or opts.noremap
  opts.silent = opts.silent == nil and true or opts.silent
  vim.api.nvim_set_keymap('v', keys, command, opts)
end

------------------------------------------------------------------------------------------
-- 取消无用 按键映射
------------------------------------------------------------------------------------------
--nmap('<leader>r', '<nop>')
--nmap('<leader>f', '<nop>')
nmap('<Space>', '<nop>')
vmap('<Space>', '<nop>')
xmap('<Space>', '<nop>')

------------------------------------------------------------------------------------------
-- Telescope 映射
------------------------------------------------------------------------------------------
-- cmap('te', 'Telescope')
nmap2('<leader>te', ':Telescope ')

------------------------------------------------------------------------------------------
-- CMake-tools 映射
------------------------------------------------------------------------------------------
cmap('Cst', 'CMakeSelectBuildType')
cmap('Cb', 'CMakeBuild')
cmap('Cg', 'CMakeGenerate')
-- cmap('SS', 'Leaderf! rg -g *.{}')

------------------
---- VIM 相关 ----
------------------
--
-- 保存文件
nmap('<leader>fs',':w<CR>')

-- 保存所有文件
nmap('<leader>fS',':wa<CR>')

-- 关闭当前文件
nmap('<leader>fd',': bp | bd #<CR>')
--nmap('<leader>fo',':e ') -- 异常
vim.cmd 'nmap <leader>fo :e '

-- 文件保存与退出
nmap('<leader>wq',':wq<CR>')
nmap('<leader>wQ',':wqa<CR>')

-- 文件不保存退出
nmap('<leader>q',':q<CR>')
nmap('<leader>Q',':q!<CR>')

-- 上/下一个 buffer
nmap('<leader>fn',':bn<CR>')
nmap('<leader>fp',':bp<CR>')

-- 开启与关闭高亮
nmap('<leader>hl',':set hlsearch<CR>')
nmap('<leader>hc',':set nohlsearch<CR>')

-- 快速切换到行首行尾
nmap('H', '^')
xmap('H', '^')
vmap('H', '^')
--imap('H', '^')
--xmap('H', '^')
nmap('L', '$')
xmap('L', '$')
vmap('L', '$')
--imap('L', '$')
--xmap('L', '$')

-- 批量缩进
xmap('<', '<gv')
xmap('>', '>gv')

-- VIM 环境保存
nmap('<leader>ss', ':mksession! lastsession.vim<cr> :wviminfo! lastsession.viminfo<cr>')
-- VIM 环境恢复
nmap('<leader>rs', ':source lastsession.vim<cr> :rviminfo lastsession.viminfo<cr>')

-- 关闭quickfix
nmap('<leader>wc', ':cclose<cr>')

-- 16进制打开文件
nmap('<leader>hx', ':%!xxd<cr>')

-- 16进制打开文件恢复到正常模式打开文件
nmap('<leader>hr', ':%!xxd -r<cr>')

-- 显示开始界面
--nmap('<leader>ho :Startify<CR>

-- 上一个文件分屏横向分屏
nmap('<leader>ls', ':vsplit #<CR> ')

-- 上一个文件垂直分屏
nmap('<leader>lv', ':split #<CR> ')
nmap('<leader>lo', ':e #<CR>')

-- 窗口切换
nmap('<leader>wk', '<C-w>k')
nmap('<leader>wl', '<C-w>l')
nmap('<leader>wh', '<C-w>h')
nmap('<leader>wj', '<C-w>j')
-- nmap('<tab>', '<C-w>w')

-- 窗口移动
nmap('<leader>wk', '<C-w>k')
nmap('<leader>wK', '<C-w>K')
nmap('<leader>wL', '<C-w>L')
nmap('<leader>wH', '<C-w>H')
nmap('<leader>wJ', '<C-w>J')

-- 窗口删除
nmap('<leader>wo', ':only<CR>')

-- 窗口尺寸调整
nmap('<leader>w=', '<C-w>=')
nmap('<leader>w-', '<C-w>+')
nmap('<leader>w<', '<C-w><')
nmap('<leader>w>', '<C-w>>')
nmap('<leader>ws', ':vertical resize ')
nmap('<leader>wv', ':resize ')

-- 粘贴模式开启与关闭
-- nmap('<leader>po', ':set paste<CR>')
-- nmap('<leader>pc', ':set nopaste<CR>')

-- 复制内容到粘贴板
-- vmap('<leader>C', '"+y')

-- 弹出式终端
nmap('<leader>t', '<CMD>lua require("FTerm").toggle()<CR>')

-- GIT 命令
nmap('<leader>gr', ':Gitsigns refresh<CR>')
nmap('<leader>gb', ':Gitsigns blame_line<CR>')
nmap('<leader>gi', ':Gitsigns preview_hunk<CR>')
nmap('<leader>gd', ':Gvdiffsplit<CR>')
-- navigate conflicts of current buffer
nmap('gkn', ':Gitsigns next_hunk<CR>')
nmap('gkp', ':Gitsigns prev_hunk<CR>')
nmap('gku', ':Gitsigns reset_hunk<CR>')
nmap('gks', ':Gitsigns stage_hunk<CR>')

------------------------------------------------------------------------------------------
-- 文件窗口 nvim-tree
------------------------------------------------------------------------------------------
--
nmap('<F3>', ':NvimTreeToggle<CR>')
-- nmap('<leader>fl', ':NvimTreeFocus<CR>')

------------------------------------------------------------------------------------------
-- tagbar 类窗口
------------------------------------------------------------------------------------------
--
nmap('<F2>', ':TagbarToggle<CR>')

------------------------------------------------------------------------------------------
-- LeaderF 配置
------------------------------------------------------------------------------------------
--
-- 取消此按键的映射
-- nmap('<leader>b', '<nop>')
-- nmap('<leader>f', '<nop>')

-- nmap('<leader>sb', ':<C-U><C-R>=printf("Leaderf buffer %s", "")<CR><CR>')
-- nmap('<leader>sm', ':<C-U><C-R>=printf("Leaderf mru %s", "")<CR><CR>')
-- nmap('<leader>st', ':<C-U><C-R>=printf("Leaderf bufTag %s", "")<CR><CR>')
-- nmap('<leader>sl', ':<C-U><C-R>=printf("Leaderf line %s", "")<CR><CR>')
-- nmap('<leader>sw', ':<C-U><C-R>=printf("Leaderf gtags %s", "")<CR><CR>')
-- nmap('<leader>sW', ':<C-U><C-R>=printf("Leaderf gtags --current-buffer %s", "")<CR><CR>')
-- nmap('<leader>sf', ':<C-U><C-R>=printf("Leaderf file --nameOnly %s", "")<CR><CR>')
--nmap('<leader>sS', ':Leaderf rg -g *.{} ') 搜索指定的文件类型，待完善
--示例 Leaderf! rg -g *.{h,cpp} 
-- search visually selected text literally
-- xmap('<leader>sw', ':<C-U><C-R>=printf("Leaderf gtags %s ", visual())<CR><CR>')
-- vmap('<leader>sw', ':<C-U><C-R>=printf("Leaderf gtags --input %s ", leaderf#Rg#visual())<CR><CR>')
-- vmap('<leader>sW', ':<C-U><C-R>=printf("Leaderf gtags --current-buffer --input %s ", leaderf#Rg#visual())<CR><CR>')

--noremap <C-B> :<C-U><C-R>=printf("Leaderf! rg --current-buffer -e %s ", expand("<cword>"))<CR>
--noremap <C-F> :<C-U><C-R>=printf("Leaderf! rg -e %s ", expand("<cword>"))<CR>

-- nmap('<leader>ss', ':<C-U><C-R>=printf("Leaderf! gtags -s %s --auto-jump", expand("<cword>"))<CR><CR>')
-- nmap('<leader>sr', ':<C-U><C-R>=printf("Leaderf! gtags -r %s --auto-jump", expand("<cword>"))<CR><CR>')
-- nmap('<leader>sd', ':<C-U><C-R>=printf("Leaderf! gtags -d %s --auto-jump", expand("<cword>"))<CR><CR>')
-- nmap('<leader>so', ':<C-U><C-R>=printf("Leaderf! gtags --recall %s", "")<CR><CR>')
-- nmap('<leader>sn', ':<C-U><C-R>=printf("Leaderf gtags --next %s", "")<CR><CR>')
-- nmap('<leader>sp', ':<C-U><C-R>=printf("Leaderf gtags --previous %s", "")<CR><CR>')
-- nmap('<leader>sg', ':<C-U><C-R>=printf("Leaderf gtags --update %s", "")<CR><CR>')

------------------------------------------------------------------------------------------
-- MARK 高亮
------------------------------------------------------------------------------------------
--
vmap('<leader>n', '<Plug>MarkClear')
nmap('<leader>m', '<Plug>MarkSet')
nmap('<leader>N', ':MarkClear<CR>')
------------------------------------------------------------------------------------------


------------------------------------------------------------------------------------------
-- ASYNC RUN
------------------------------------------------------------------------------------------
--
-- nmap('<leader>ar', ':AsyncRun ')
cmap('ar', 'AsyncRun')
cmap('as', 'AsyncStop')
------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------
-- 格式化代码 null-ls
------------------------------------------------------------------------------------------
nmap('<leader>ff', ':lua vim.lsp.buf.format()<CR>')

------------------------------------------------------------------------------------------
-- VIM SPECTOR 按键映射
------------------------------------------------------------------------------------------
--
-- 启用或关闭 vimspector
-- vim.cmd 'packadd! vimspector'
-- -- 查看变量内容
-- --for normal mode - the word under the cursor
-- nmap('<Leader>di', '<Plug>VimspectorBalloonEval')
-- -- for visual mode, the visually selected text
-- xmap('<Leader>di', '<Plug>VimspectorBalloonEval')
-- -- 退出调试器
-- nmap('<leader>dq', ':VimspectorReset<CR>')
-- -- 启动或者继续
-- nmap('<F5>', '<Plug>VimspectorContinue')
-- -- 停止调试
-- nmap('<leader>ds', '<Plug>VimspectorStop')
-- -- 重启调试
-- nmap('<leader>dr', '<Plug>VimpectorRestart')
-- -- 查看光标下的变量的内容
-- nmap('<leader>de', '<Plug>VimspectorBalloonEval')
-- -- 向上移动栈帧
-- nmap('<leader>dku', '<Plug>VimspectorUpFrame')
-- -- 向下移动栈帧
-- nmap('<leader>dkd', '<Plug>VimspectorDownFrame')
-- -- 条件断点
-- nmap('<leader>dpi', '<Plug>VimspectorToggleConditionalBreakpoint')
-- -- 添加函数断点
-- nmap('<leader>dpf', '<Plug>VimspectorAddFunctionBreakpoint')
-- -- 添加监视变量
-- nmap('<leader>dw', ':VimspectorWatch ')
-- -- 运行到光标处
-- nmap('<F4>', '<Plug>VimspectorRunToCursor')
-- -- 步过
-- nmap('<F8>', '<Plug>VimspectorStepOver')
-- -- 步入
-- nmap('<F7>', '<Plug>VimspectorStepInto')
-- -- 切换断点
-- nmap('<F9>', '<Plug>VimspectorToggleBreakpoint')
-- -- 中断调试器
-- nmap('<F12>', '<Plug>VimspectorPause')

------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------
-- lazygit 配置
------------------------------------------------------------------------------------------
-- nmap('<leader>gg', ':LazyGit<CR>')
-- nmap('<leader>gc', ':LazyGitCurrentFile<CR>')
-- nmap('<leader>gf', ':LazyGitFilter<CR>')
-- nmap('<leader>gfc', ':LazyGitFilterCurrentFile<CR>')

------------------------------------------------------------------------------------------
-- coc-git 配置
------------------------------------------------------------------------------------------
-- nmap('<leader>gn', '<Plug>(coc-git-nextchunk)')
-- nmap('<leader>gp', '<Plug>(coc-git-prevchunk)')
-- nmap('<leader>gkc', '<Plug>(coc-git-keepcurrent)')
-- nmap('<leader>gki', '<Plug>(coc-git-keepincoming)')
-- nmap('<leader>gkb', '<Plug>(coc-git-keepboth)')


---------------------
---- VIM SPECTOR ----
---------------------
--
--查看变量内容
-- for normal mode - the word under the cursor
-- nmap('<Leader>di', '<Plug>VimspectorBalloonEval')
-- for visual mode, the visually selected text
-- xmap('<Leader>di', '<Plug>VimspectorBalloonEval')
--退出调试器
-- nmap('<leader>dq', ':VimspectorReset<CR>')
 --启动或者继续
-- nmap('<F5>', '<Plug>VimspectorContinue')
--停止调试
-- nmap('<leader>ds', '<Plug>VimspectorStop')
--重启调试
-- nmap('<leader>dr', '<Plug>VimpectorRestart')
--查看光标下的变量的内容
-- nmap('<leader>de', '<Plug>VimspectorBalloonEval')
--向上移动栈帧
-- nmap('<leader>dku', '<Plug>VimspectorUpFrame')
--向下移动栈帧
-- nmap('<leader>dkd', '<Plug>VimspectorDownFrame')
--条件断点
-- nmap('<leader>dpi', '<Plug>VimspectorToggleConditionalBreakpoint')
--添加函数断点
-- nmap('<leader>dpf', '<Plug>VimspectorAddFunctionBreakpoint')
--添加监视变量
-- nmap('<leader>dw', ':VimspectorWatch ')
--运行到光标处
-- nmap('<F4>', '<Plug>VimspectorRunToCursor')
--步过
-- nmap('<F8>', '<Plug>VimspectorStepOver')
--步入
-- nmap('<F7>', '<Plug>VimspectorStepInto')
--切换断点
-- nmap('<F9>', '<Plug>VimspectorToggleBreakpoint')
--中断调试器
-- nmap('<F12>', '<Plug>VimspectorPause')

------------------------------------------------------------------------------------------
-- Telescope 配置
------------------------------------------------------------------------------------------
nmap('<leader>sb', ':lua require("telescope.builtin").buffers()<CR>')
nmap('<leader>sm', ':lua require("telescope.builtin").oldfiles()<CR>')
nmap('<leader>st', ':lua require("telescope.builtin").tags({ env = { TAGS = vim.o.tags}})<CR>')
nmap('<leader>sl', ':lua require("telescope.builtin").current_buffer_fuzzy_find()<CR>')
nmap('<leader>sw', ':lua require("telescope").extensions.live_grep_args.live_grep_args({ cwd = vim.g.workspace_dir.get() , auto_quoting=true})<CR>')
nmap('<leader>sc', ':lua require("telescope").extensions.live_grep_args.live_grep_args({ cwd = vim.g.workspace_dir.get(), search_dirs = { vim.fn.expand("%:p:h") } })<CR>')
nmap('<leader>sf', ':lua require("telescope.builtin").find_files({ cwd = vim.g.workspace_dir.get() })<CR>')
nmap('<leader>sd', ':lua require("telescope-live-grep-args.shortcuts").grep_word_under_cursor({cwd = vim.g.workspace_dir.get()})<CR>')
nmap('<leader>ss', ':lua require("telescope.builtin").tags({ env = { TAGS = vim.o.tags}, default_text= vim.fn.expand("<cword>") } )<CR>')
nmap('<leader>sg', ':lua vim.g.generate_ctags.get()<CR>')

-- 配置可视模式下的快捷键
vmap('<leader>sw', ':lua require("telescope").extensions.live_grep_args.live_grep_args({ cwd = vim.g.workspace_dir.get() , default_text= vim.g.get_visual_selection.get()})<CR>')
