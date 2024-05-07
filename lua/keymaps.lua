
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
  map('c', shortcut, command)
end

function imap(shortcut, command)
  map('i', shortcut, command)
end


------------------------------------------------------------------------------------------
-- 取消无用 按键映射
------------------------------------------------------------------------------------------
--nmap('<leader>r', '<nop>')
--nmap('<leader>f', '<nop>')
nmap('<Space>', '<nop>')
vmap('<Space>', '<nop>')
xmap('<Space>', '<nop>')

cmap('CC', 'CocCommand')
cmap('lf', 'Leaderf')
cmap('SS', 'Leaderf! rg -g *.{}')

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
nmap('<leader>sh',':set hlsearch<CR>')
nmap('<leader>sc',':set nohlsearch<CR>')

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
nmap('<leader>po', ':set paste<CR>')
nmap('<leader>pc', ':set nopaste<CR>')

-- 复制内容到粘贴板
vmap('<leader>C', '"+y')

-- 终端映射
--nmap('<leader>\'', ':vsplit<CR>:terminal<CR>i')

-- 弹出式终端
nmap('<leader>t', '<CMD>lua require("FTerm").toggle()<CR>')
--vim.keymap.set('t', '<A-i>', '<C-\\><C-n><CMD>lua require("FTerm").toggle()<CR>')

-- GIT 命令
nmap('<leader>gi', ':CocCommand git.chunkInfo<CR>')
nmap('<leader>gr', ':CocCommand git.refresh<CR>')
nmap('<leader>gp', ':CocCommand git.push')
nmap('<leader>gs', ':CocCommand git.showCommit<CR>')
nmap('<leader>gu', ':CocCommand git.chunkUndo<CR>')
nmap('<leader>gd', ':CocCommand git.diffCached<CR>')
-- navigate conflicts of current buffer
nmap('gcp', '<Plug>(coc-git-prevconflict)')
nmap('gcn', '<Plug>(coc-git-nextconflict)')

-- COC 快捷呼出
nmap('<leader>cx', ':CocList commands<CR>')
--" create text object for git chunks 
--TODO: Update
--omap ig <Plug>(coc-git-chunk-inner)
--xmap ig <Plug>(coc-git-chunk-inner)
--omap ag <Plug>(coc-git-chunk-outer)
--xmap ag <Plug>(coc-git-chunk-outer)



------------------------------------------------------------------------------------------
-- 文件窗口 coc-explorer
------------------------------------------------------------------------------------------
--
nmap('<F3>', '<Cmd>CocCommand explorer --position right<CR>')

------------------------------------------------------------------------------------------
-- LeaderF 配置
------------------------------------------------------------------------------------------
--
-- 取消此按键的映射
nmap('<leader>b', '<nop>')
nmap('<leader>f', '<nop>')

nmap('<leader>sb', ':<C-U><C-R>=printf("Leaderf buffer %s", "")<CR><CR>')
nmap('<leader>sm', ':<C-U><C-R>=printf("Leaderf mru %s", "")<CR><CR>')
nmap('<leader>st', ':<C-U><C-R>=printf("Leaderf bufTag %s", "")<CR><CR>')
nmap('<leader>sl', ':<C-U><C-R>=printf("Leaderf line %s", "")<CR><CR>')
nmap('<leader>sW', ':<C-U><C-R>=printf("Leaderf gtags %s", "")<CR><CR>')
nmap('<leader>sw', ':<C-U><C-R>=printf("Leaderf gtags --current-buffer %s", "")<CR><CR>')
nmap('<leader>sf', ':<C-U><C-R>=printf("Leaderf file --nameOnly %s", "")<CR><CR>')
--nmap('<leader>sS', ':Leaderf rg -g *.{} ') 搜索指定的文件类型，待完善
--示例 Leaderf! rg -g *.{h,cpp} 
-- search visually selected text literally
xmap('<leader>sw', ':<C-U><C-R>=printf("Leaderf! rg --current-buffer -F -e %s ", leaderf#Rg#visual())<CR><CR>')
xmap('<leader>sW', ':<C-U><C-R>=printf("Leaderf! rg -F -e %s ", leaderf#Rg#visual())<CR><CR>')

--noremap <C-B> :<C-U><C-R>=printf("Leaderf! rg --current-buffer -e %s ", expand("<cword>"))<CR>
--noremap <C-F> :<C-U><C-R>=printf("Leaderf! rg -e %s ", expand("<cword>"))<CR>


nmap('<leader>sr', ':<C-U><C-R>=printf("Leaderf! gtags -r %s --auto-jump", expand("<cword>"))<CR><CR>')
nmap('<leader>sd', ':<C-U><C-R>=printf("Leaderf! gtags -d %s --auto-jump", expand("<cword>"))<CR><CR>')
nmap('<leader>so', ':<C-U><C-R>=printf("Leaderf! gtags --recall %s", "")<CR><CR>')
nmap('<leader>sn', ':<C-U><C-R>=printf("Leaderf gtags --next %s", "")<CR><CR>')
nmap('<leader>sp', ':<C-U><C-R>=printf("Leaderf gtags --previous %s", "")<CR><CR>')
nmap('<leader>sg', ':<C-U><C-R>=printf("Leaderf gtags --update %s", "")<CR><CR>')

------------------------------------------------------------------------------------------
-- MARK 高亮
------------------------------------------------------------------------------------------
--
nmap('<leader>N', ':MarkClear<CR>')
nmap('<leader>m', '<Plug>MarkSet')
xmap('<leader>m', '<Plug>MarkSet')
vmap('<leader>m', '<Plug>MarkSet')
nmap('<leader>n', '<Plug>MarkClear')
xmap('<leader>n', '<Plug>MarkClear')
vmap('<leader>n', '<Plug>MarkClear')
------------------------------------------------------------------------------------------


------------------------------------------------------------------------------------------
-- ASYNC RUN
------------------------------------------------------------------------------------------
--
nmap('<leader>ar', ':AsyncRun ')
nmap('<leader>as', ':AsyncStop<CR>')
------------------------------------------------------------------------------------------


------------------------------------------------------------------------------------------
-- VIM SPECTOR 按键映射
------------------------------------------------------------------------------------------
--
-- 启用或关闭 vimspector
vim.cmd 'packadd! vimspector'
-- 查看变量内容
--for normal mode - the word under the cursor
nmap('<Leader>di', '<Plug>VimspectorBalloonEval')
-- for visual mode, the visually selected text
xmap('<Leader>di', '<Plug>VimspectorBalloonEval')
-- 退出调试器
nmap('<leader>dq', ':VimspectorReset<CR>')
-- 启动或者继续
nmap('<F5>', '<Plug>VimspectorContinue')
-- 停止调试
nmap('<leader>ds', '<Plug>VimspectorStop')
-- 重启调试
nmap('<leader>dr', '<Plug>VimpectorRestart')
-- 查看光标下的变量的内容
nmap('<leader>de', '<Plug>VimspectorBalloonEval')
-- 向上移动栈帧
nmap('<leader>dku', '<Plug>VimspectorUpFrame')
-- 向下移动栈帧
nmap('<leader>dkd', '<Plug>VimspectorDownFrame')
-- 条件断点
nmap('<leader>dpi', '<Plug>VimspectorToggleConditionalBreakpoint')
-- 添加函数断点
nmap('<leader>dpf', '<Plug>VimspectorAddFunctionBreakpoint')
-- 添加监视变量
nmap('<leader>dw', ':VimspectorWatch ')
-- 运行到光标处
nmap('<F4>', '<Plug>VimspectorRunToCursor')
-- 步过
nmap('<F8>', '<Plug>VimspectorStepOver')
-- 步入
nmap('<F7>', '<Plug>VimspectorStepInto')
-- 切换断点
nmap('<F9>', '<Plug>VimspectorToggleBreakpoint')
-- 中断调试器
nmap('<F12>', '<Plug>VimspectorPause')

------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------
-- lazygit 配置
------------------------------------------------------------------------------------------
nmap('<leader>gg', ':LazyGit<CR>')
nmap('<leader>gc', ':LazyGitCurrentFile<CR>')
nmap('<leader>gf', ':LazyGitFilter<CR>')
nmap('<leader>gfc', ':LazyGitFilterCurrentFile<CR>')

------------------------------------------------------------------------------------------
-- coc-git 配置
------------------------------------------------------------------------------------------
nmap('<leader>gn', '<Plug>(coc-git-nextchunk)')
nmap('<leader>gp', '<Plug>(coc-git-prevchunk)')
nmap('<leader>gkc', '<Plug>(coc-git-keepcurrent)')
nmap('<leader>gki', '<Plug>(coc-git-keepincoming)')
nmap('<leader>gkb', '<Plug>(coc-git-keepboth)')


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


