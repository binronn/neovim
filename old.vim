" let $TMPDIR = '/mnt/d/TMP'
" let $WINGCCPATH = 'C:\Qt\Qt5.13.2\Tools\mingw730_32\bin\'
call plug#begin('~/.vim/plugged')
Plug 'vim-airline/vim-airline'
"Plug 'octol/vim-cpp-enhanced-highlight' " cpp 语法高亮插件
Plug 'sheerun/vim-polyglot' " 高亮配置
Plug 'vim-airline/vim-airline-themes'
Plug 'mhinz/vim-startify'
Plug 'Yggdroot/indentLine'
Plug 'liuchengxu/vista.vim' " 类窗口
Plug 'inkarkat/vim-mark'
Plug 'inkarkat/vim-ingo-library'
Plug 'morhetz/gruvbox'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'scrooloose/nerdcommenter' " 注释插件
"Plug 'sbdchd/neoformat'
Plug 'MattesGroeger/vim-bookmarks'
Plug 'skywind3000/asyncrun.vim' " 异步执行命令插件
Plug 'Yggdroot/LeaderF', { 'do': ':LeaderfInstallCExtension'}
Plug 'rhysd/vim-clang-format',{ 'for': ['cpp','c','h']  }
Plug 'Raimondi/delimitMate' " 自动补全插件 () {} ......
Plug 'liuchengxu/space-vim-theme'
Plug 'puremourning/vimspector' " 多语言调试工具
Plug 'tmhedberg/SimpylFold' " 代码折叠
Plug 'itchyny/vim-cursorword' " 高亮光标下单词
Plug 'honza/vim-snippets'
Plug 'bfrg/vim-cpp-modern'
call plug#end()

" leader 映射
let g:mapleader = " "
let mapleader = " "

" 关闭空格键移动
nnoremap <Space> <nop>
" \r\n 替换 \n
" 迁移执行命令
" sudo apt install ctags cscope gcc clangd clang clang-format cmake make global   //如果clang的命令不是clang 需要自己创建链接 ,clang-format 通clang
" sudo apt install python3-pip
" sudo pip3 install yapf 
" sudo apt install ccls 弃用
" ln -s /home/<user>/.vim/.vimrc /home/<user>/.vimrc
"----------------------------------------------------------------------------------------
" COC 插件配置
 "\ 'coc-ccls',
let g:coc_global_extensions = [
 \ 'coc-json', 
 \ 'coc-vimlsp', 
 \ 'coc-git',
 \ 'coc-explorer',
 \ 'coc-jedi',
 \ 'coc-format-json',
 \ 'coc-snippets',
 \ 'coc-syntax',
 \ 'coc-marketplace',
 \ 'coc-clangd'
 \]

"autocmd FileType json syntax match Comment +\/\/.\+$+

" Command 快捷键
function! SetupCommandAbbrs(from, to)
  exec 'cnoreabbrev <expr> '.a:from
        \ .' ((getcmdtype() ==# ":" && getcmdline() ==# "'.a:from.'")'
        \ .'? ("'.a:to.'") : ("'.a:from.'"))'
endfunction
" Use CC to open CocCommand config
call SetupCommandAbbrs('CC', 'CocCommand<CR>')

" Use CM to open CocList marketplace
call SetupCommandAbbrs('CM', 'CocList marketplace<CR>')

" Use CL to open CocList 
call SetupCommandAbbrs('CL', 'CocList')

" Use CLC to open CocList commands
call SetupCommandAbbrs('CS', 'CocList commands<CR>')

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" ctrl + o 调出补全
inoremap <silent><expr> <c-o> coc#refresh()

" 查找代码报错
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gt <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
	call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
"autocmd CursorHold * silent call CocActionAsync('highlight')

" Formatting selected code.
xmap <leader>ff  <Plug>(coc-format-selected)
nmap <leader>ff  <Plug>(coc-format-selected)
augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end


" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
"xmap <leader>a  <Plug>(coc-codeaction-selected)
"nmap <leader>a  <Plug>(coc-codeaction-selected)

nmap <leader>rn <Plug>(coc-rename)
" Remap keys for applying codeAction to the current buffer.
"nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
"nmap <leader>qf  <Plug>(coc-fix-current)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
" 快速选中类 函数 内容 vif vic
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

"COC 配置结束

"----------------------------------------------------------------------------------------
" MarkDown图片问题, 执行脚本并插入命令
" 图片将保存到，当前文件同级目录下的 img 文件夹
" 文件夹 不错在 则报错
"
" 迁移需修改 ~/.vim/BlogImg/save_screen_img.py 的变量
" 修改 python 路径等
" 并在 Windows 中的 python 中 安装 Pillow 库
autocmd FileType md,markdown nnoremap <leader>ip :let @a = system('~/.vim/BlogImg/save_screen_img.py %')<CR>"ap
autocmd FileType md,markdown nnoremap <leader>ir :%s/\/img\//https:\/\/gitee.com\/imgset\/img\/raw\/master\//g<CR>
autocmd FileType md,markdown nnoremap <leader>is :AsyncRun cd img&&git add .&&git commit -m "img"&&git push origin master<CR>
"----------------------------------------------------------------------------------------
"
"----------------------------------------------------------------------------------------
" 代码片段设置
"
" 选中代码后创建代码片段
xmap <leader>x  <Plug>(coc-convert-snippet)

inoremap <silent><expr> <c-j>
	  \ pumvisible() ? coc#_select_confirm() :
	  \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
	  \ <SID>check_back_space() ? "\<c-j>" :
	  \ coc#refresh()

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

"let g:coc_snippet_next = '<c-j>'
"----------------------------------------------------------------------------------------
" 类窗口配置
function! NearestMethodOrFunction() abort
  return get(b:, 'vista_nearest_method_or_function', '')
endfunction

set statusline+=%{NearestMethodOrFunction()}

" By default vista.vim never run if you don't call it explicitly.
"
" If you want to show the nearest function in your statusline automatically,
" you can add the following line to your vimrc
autocmd VimEnter * call vista#RunForNearestMethodOrFunction()

let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'readonly', 'filename', 'modified', 'method' ] ]
      \ },
      \ 'component_function': {
      \   'method': 'NearestMethodOrFunction'
      \ },
      \ }

let g:vista_sidebar_position="vertical topleft"
let g:vista_sidebar_width=40
"----------------------------------------------------------------------------------------
"语法插件高亮配置
let c_no_curly_error = 1

" 高亮插件
let g:mwDefaultHighlightingPalette = 'extended'
let g:mwDefaultHighlightingPalette = 'maximum'

" c/cpp 高亮 vim-cpp-modern
" Disable function highlighting (affects both C and C++ files)
let g:cpp_function_highlight = 1

" Enable highlighting of C++11 attributes
let g:cpp_attributes_highlight = 1

" Highlight struct/class member variables (affects both C and C++ files)
let g:cpp_member_highlight = 1

" Put all standard C and C++ keywords under Vim's highlight group 'Statement'
" (affects both C and C++ files)
let g:cpp_simple_highlight = 1

"----------------------------------------------------------------------------------------
" airline配置
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline#extensions#tagbar#enabled = 0
"let g:airline#extensions#tabline#left_sep = '+'
"let g:airline#extensions#tabline#left_alt_sep = '|'
"let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline_theme="angr"      " 设置主题

" 取消隐藏字符
" set conceallevel=0
" 设置为双字宽显示，否则无法完整显示如:☆
set ambiwidth=double
" 总是显示状态栏
let laststatus = 2
let g:airline_powerline_fonts = 1   " 使用powerline打过补丁的字体
 " 关闭状态显示空白符号计数
let g:airline#extensions#whitespace#enabled = 0
let g:airline#extensions#whitespace#symbol = '!'
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline#extensions#tabline#formatter = 'unique_tail'
"let g:airline_left_sep = '<'
"let g:airline_left_alt_sep = '<'
"let g:airline_right_sep = '⮂'
"let g:airline_right_alt_sep = '⮃'
"let g:airline_symbols.branch = '⭠'
"let g:airline_symbols.readonly = '⭤'

 "let g:airline_solarized_bg='dark'

 " coc git
function! s:update_git_status()
  let g:airline_section_b = "%{get(g:,'coc_git_status','')}%{get(b:,'coc_git_status','')}%{get(b:,'coc_git_blame','')}"
endfunction

let g:airline_section_b = "%{get(g:,'coc_git_status','')}%{get(b:,'coc_git_status','')}%{get(b:,'coc_git_blame','')}"
autocmd User CocGitStatusChange call s:update_git_status()

"----------------------------------------------------------------------------------------
" 异步shell插件 窗口设置
let g:asyncrun_open = 12
"----------------------------------------------------------------------------------------
" indentLine配置
let g:indentLine_enabled = 1
let g:indentLine_concealcursor = 'inc'
let g:indentLine_conceallevel = 2
" indentLine
let g:indentLine_char='|'
let g:indentLine_enabled = 1
set list lcs=tab:\|\ 
" clang-foarmat路径配置
let g:clang_library_path = '/usr/bin/'
let g:clang_format#command = 'clang-format'

" indentLine markdown 符号不显示问题
autocmd FileType json,markdown,csv let g:indentLine_conceallevel = 0
" vim-json json 符号 " 不显示问题
autocmd FileType json,markdown,csv let g:vim_json_syntax_conceal = 0

"----------------------------------------------------------------------------------------
" 书签保存设置
let g:bookmark_save_per_working_dir = 0 " 书签保存到工作目录
let g:bookmark_auto_save = 1  " 自动保存书签
"----------------------------------------------------------------------------------------
syntax enable
set background=dark
let g:hybrid_custom_term_colors = 1
let g:hybrid_reduced_contrast = 1 " Remove this line if using the default palette."
colorscheme gruvbox

" 设置中文提示
"language messages zh_CN.utf-8
" 设置中文帮助
set helplang=cn

" 关闭leaderF <leader>f 快捷键
let g:Lf_ShortcutF = ''
" 将tagbar的空格修改为右方向按键 避免<leader>冲突
"let g:tagbar_map_showproto = "<right>"
"----------------------------------------------------------------------------------------
set scrolloff=3
 set cursorline   "当前行高亮
set shiftwidth=4  " 自动对齐的空格数量
set autoindent  
set relativenumber " 相对行
set cindent
set smartindent
set number
"set t_Co=256 " required
set ts=4
" 禁止将tab替换为空格
set noexpandtab  
set encoding=utf-8
set hidden
" set editing-mode vi
set nocompatible " 关闭vi兼容
set backspace=indent,eol,start " 退格键修复
set mouse=c  " xshell复制开启

set foldmethod=indent
set foldlevel=99

set fileformat=unix
" vim环境保存与恢复
set sessionoptions="blank,buffers,globals,localoptions,tabpages,sesdir,folds,help,options,resize,winpos,winsize"
" 保存 undo 历史
set undodir=~/.undo_history/
set undofile
"----------------------------------------------------------------------------------------
" 卡顿解决  有效
set re=1
set ttyfast
set lazyredraw
" syntax sync minlines=128
set nocursorcolumn
"----------------------------------------------------------------------------------------
set hidden
set updatetime=200
set shortmess+=c
"set signcolumn=number
set noerrorbells
" 禁止自动换行
set nowrap

" 文件备份问题
set noswapfile
set nobackup
set undodir=~/.vim/undodir
set undofile

" 实时显示搜索内容
set incsearch
" 向下滚动h时预留行数
set scrolloff=5
" 强制显示侧边栏，防止时有时无
set signcolumn=yes
" 显示最长的列长度为90
"set colorcolumn=90
" vim 命令补全
set wildmenu
set wildmode=longest:full
"----------------------------------------------------------------------------------------
" 批量缩进
xnoremap < <gv
xnoremap > >gv

filetype plugin indent on 
autocmd FileType asm set ft=masm
"----------------------------------------------------------------------------------------
" 高亮设置
let hs_highlight_delimiters=1            " 高亮定界符
let hs_highlight_boolean=1               " 把True和False识别为关键字
let hs_highlight_types=1                 " 把基本类型的名字识别为关键字
let hs_highlight_more_types=1            " 把更多常用类型识别为关键字
let hs_highlight_debug=1                 " 高亮调试函数的名字
let hs_allow_hash_operator=1             " 阻止把#高亮为错

" 清除所有高亮
nmap <Leader>N :MarkClear<CR> 
"----------------------------------------------------------------------------------------
" 保存快捷键
nmap <leader>ss :mksession! lastsession.vim<cr> :wviminfo! lastsession.viminfo<cr>
" 恢复快捷键
nmap <leader>rs :source lastsession.vim<cr> :rviminfo lastsession.viminfo<cr>
"----------------------------------------------------------------------------------------
" 书签
nmap ml :BookmarkShowAll<cr>
" 关闭quickfix
nmap <leader>wc :cclose<cr>
" 异步执行命令
nmap <leader>sa :AsyncRun 
" 16进制打开文件
nmap <leader>hx :%!xxd<cr>
" 16进制打开文件恢复到正常模式打开文件
nmap <leader>hr :%!xxd -r<cr>
" 显示开始界面
" nmap <leader>ho :Startify<CR>
" 上一个文件分屏横向分屏
nmap <leader>ls :vsplit #<CR> 
" 上一个文件垂直分屏
nmap <leader>lv :split #<CR> 
nmap <leader>lo :e #<CR>
" 窗口切换
nmap <leader>wk <C-w>k
nmap <leader>wl <C-w>l
nmap <leader>wh <C-w>h
nmap <leader>wj <C-w>j
"nmap <tab> <C-w>w
" 窗口移动
nmap <leader>wk <C-w>k
nmap <leader>wK <C-w>K
nmap <leader>wL <C-w>L
nmap <leader>wH <C-w>H
nmap <leader>wJ <C-w>J
" 窗口删除
nmap <leader>wo :only<CR>
" 窗口尺寸调整
nmap<leader>w= <C-w>=
nmap<leader>w- <C-w>+
nmap<leader>w< <C-w><
nmap<leader>w> <C-w>>
nmap <leader>ws :vertical resize 
nmap <leader>wv :resize 

" 文件操作
" " 保存文件
nmap <leader>fs :w<CR> 
 " 保存所有文件
nmap <leader>fS :wa<CR>
" 关闭当前文件
nmap <leader>fd :bd<CR> 
nmap <leader>fo :e 

" 文件保存与退出
nmap <leader>wq :wq<CR>
nmap <leader>wQ :wqa<CR>
" 文件不保存退出
nmap <leader>q :q<CR>
nmap <leader>Q :q!<CR>

nmap <leader>fn :bn<CR>
nmap <leader>fp :bp<CR>

" 格式化代码
"nmap <leader>ff :call CocAction('format')<CR>
" 终端映射
nmap <leader>' :rightbelow vert term<CR>
nmap <leader>" :term<CR>

" 搜索映射
"nmap <leader>sw :lw<CR>
"nmap <leader>sn :lne<CR>
"nmap <leader>sp :lpr<CR>
"nmap <leader>sq :lcl<CR>
nmap <leader>sh :set hlsearch<CR>
nmap <leader>sc :set nohlsearch<CR>

"----------------------------------------------------------------------------------------
" LeaderF 配置
" 取消此按键的映射
nmap <leader>b <nop>

call SetupCommandAbbrs('LF', 'Leaderf')
"nmap <leader>sb :LeaderfBuffer<CR>
"nmap <leader>sl :LeaderfLine<CR>
"nmap <leader>sf :LeaderfFunction<CR>

" don't show the help in normal mode
let g:Lf_HideHelp = 1
let g:Lf_UseCache = 0
let g:Lf_UseVersionControlTool = 0
let g:Lf_IgnoreCurrentBufferName = 1
" popup mode
let g:Lf_WindowPosition = 'popup'
let g:Lf_PreviewInPopup = 1
let g:Lf_StlSeparator = { 'left': "\ue0b0", 'right': "\ue0b2", 'font': "DejaVu Sans Mono for Powerline" }
let g:Lf_PreviewResult = {'Function': 0, 'BufTag': 0 }

let g:Lf_ShortcutF = "<leader>ff"
"noremap <leader>sf :LeaderfFile<CR> 
noremap <leader>sb :<C-U><C-R>=printf("Leaderf buffer %s", "")<CR><CR>
noremap <leader>sm :<C-U><C-R>=printf("Leaderf mru %s", "")<CR><CR>
noremap <leader>st :<C-U><C-R>=printf("Leaderf bufTag %s", "")<CR><CR>
noremap <leader>sl :<C-U><C-R>=printf("Leaderf line %s", "")<CR><CR>

"noremap <C-B> :<C-U><C-R>=printf("Leaderf! rg --current-buffer -e %s ", expand("<cword>"))<CR>
"noremap <C-F> :<C-U><C-R>=printf("Leaderf! rg -e %s ", expand("<cword>"))<CR>
" search visually selected text literally
"xnoremap sf :<C-U><C-R>=printf("Leaderf! rg -F -e %s ", leaderf#Rg#visual())<CR>
"noremap so :<C-U>Leaderf! rg --recall<CR>

" should use `Leaderf gtags --update` first
let g:Lf_GtagsAutoGenerate = 1
let g:Lf_Gtagslabel = 'native-pygments'
noremap <leader>sr :<C-U><C-R>=printf("Leaderf! gtags -r %s --auto-jump", expand("<cword>"))<CR><CR>
noremap <leader>sd :<C-U><C-R>=printf("Leaderf! gtags -d %s --auto-jump", expand("<cword>"))<CR><CR>
noremap <leader>so :<C-U><C-R>=printf("Leaderf! gtags --recall %s", "")<CR><CR>
noremap <leader>sn :<C-U><C-R>=printf("Leaderf gtags --next %s", "")<CR><CR>
noremap <leader>sp :<C-U><C-R>=printf("Leaderf gtags --previous %s", "")<CR><CR>
" Leaderf ignore current buffer name
let g:Lf_IgnoreCurrentBufferName = 1

" 弹出式窗口
let g:Lf_WindowPosition = 'popup'
"----------------------------------------------------------------------------------------
" 快速切换到行首行尾
noremap H ^
noremap L $
"----------------------------------------------------------------------------------------
" 粘贴模式开启与关闭
nmap <leader>pp :set paste<CR>
nmap <leader>p  :set nopaste<CR>
"----------------------------------------------------------------------------------------
"复制内容到粘贴板
vmap <leader>C "+y
"----------------------------------------------------------------------------------------
" 类窗口
map <F2> <Cmd>Vista!!<CR>
"----------------------------------------------------------------------------------------
" 文件窗口
nmap <F3> <Cmd>CocCommand explorer --position right<CR>
"nmap <Leader>er <Cmd>call CocAction('runCommand', 'explorer.doAction', 'closest', ['reveal:0'], [['relative', 0, 'file']])<CR>
let g:coc_explorer_global_presets = {
\   '.vim': {
\     'root-uri': '~/.vim',
\   },
\   'cocConfig': {
\      'root-uri': '~/.config/coc',
\   },
\   'tab': {
\     'position': 'tab',
\     'quit-on-open': v:false,
\   },
\   'tab:$': {
\     'position': 'tab:$',
\     'quit-on-open': v:false,
\   },
\   'floating': {
\     'position': 'floating',
\     'open-action-strategy': 'sourceWindow',
\   },
\   'floatingTop': {
\     'position': 'floating',
\     'floating-position': 'center-top',
\     'open-action-strategy': 'sourceWindow',
\   },
\   'floatingLeftside': {
\     'position': 'floating',
\     'floating-position': 'left-center',
\     'floating-width': 50,
\     'open-action-strategy': 'sourceWindow',
\   },
\   'floatingRightside': {
\     'position': 'floating',
\     'floating-position': 'right-center',
\     'floating-width': 50,
\     'open-action-strategy': 'sourceWindow',
\   },
\   'simplify': {
\     'file-child-template': '[selection | clip | 1] [indent][icon | 1] [filename omitCenter 1]'
\   },
\   'buffer': {
\     'sources': [{'name': 'buffer', 'expand': v:true}]
\   },
\ }

" Use preset argument to open it
"nmap <space>ed <Cmd>CocCommand explorer --preset .vim<CR>
"nmap <space>ef <Cmd>CocCommand explorer --preset floating<CR>
"nmap <space>ec <Cmd>CocCommand explorer --preset cocConfig<CR>
"nmap <space>eb <Cmd>CocCommand explorer --preset buffer<CR>

" List all presets
nmap <space>el <Cmd>CocList explPresets<CR>
"----------------------------------------------------------------------------------------
autocmd FileType nnoremap <Space> <nop>
"----------------------------------------------------------------------------------------

" 查看变量内容
"for normal mode - the word under the cursor
nmap <Leader>di <Plug>VimspectorBalloonEval
" for visual mode, the visually selected text
xmap <Leader>di <Plug>VimspectorBalloonEval

" 退出调试器
nmap <leader>dq :VimspectorReset<CR>
 " 启动或者继续
nmap <F5> <Plug>VimspectorContinue
" 停止调试
nmap <leader>ds <Plug>VimspectorStop
" 重启调试
nmap <leader>dr <Plug>VimpectorRestart
" 查看光标下的变量的内容
nmap <leader>de <Plug>VimspectorBalloonEval
" 向上移动栈帧
nmap <leader>dku <Plug>VimspectorUpFrame
" 向下移动栈帧
nmap <leader>dkd <Plug>VimspectorDownFrame
" 条件断点
nmap <leader>dpi <Plug>VimspectorToggleConditionalBreakpoint
" 添加函数断点
nmap <leader>dpf <Plug>VimspectorAddFunctionBreakpoint
" 添加监视变量
nmap <leader>dw :VimspectorWatch 
" 运行到光标处
nmap <F4> <Plug>VimspectorRunToCursor
" 步过
nmap <F8> <Plug>VimspectorStepOver
" 步入
nmap <F7> <Plug>VimspectorStepInto
" 切换断点
nmap <F9> <Plug>VimspectorToggleBreakpoint
" 中断调试器
nmap <F12> <Plug>VimspectorPause

autocmd FileType c,cpp,h,hpp nmap <leader>fh :CocCommand clangd.switchSourceHeader<CR>

autocmd FileType c,cpp,h,hpp nmap <leader>ff :ClangFormat<CR>
autocmd FileType c,cpp,h,hpp vmap <leader>ff :ClangFormat<CR>

autocmd FileType cpp,c nmap <leader>dg :call GenerateSepctorForCpp()<cr>
autocmd FileType python nmap <leader>dg :call GenerateSepctorForPython()<cr>

"autocmd FileType cpp nmap <leader>dmm :wa<CR>:!make && read<CR> 
"autocmd FileType cpp nmap <leader>dmg :wa<CR>:!g++ "%" -g -o main && read<CR> 

autocmd FileType c,cpp nmap <leader>dmc :wa<CR>:AsyncRun cmake . & make & read<CR> 
autocmd FileType c,cpp nmap <leader>dmm :wa<CR>:AsyncRun make & read<CR> 
autocmd FileType c,cpp nmap <leader>dmg :wa<CR>:AsyncRun gcc "%" -g -o main<CR> 

autocmd FileType c,cpp nmap <leader>L :w <CR> :AsyncRun  ./main<CR>

autocmd FileType python nmap <leader>l2 :w <CR> :rightbelow vert term python2 %<CR>
autocmd FileType python nmap <leader>l3 :w <CR> :rightbelow vert term python3 %<CR>
autocmd FileType python nmap <leader>lf3 :w <CR> :rightbelow vert term python3 
autocmd FileType python nmap <leader>lf2 :w <CR> :rightbelow vert term python2 
autocmd FileType python nmap <leader>L2 :w <CR> :AsyncRun python2 %<CR>
autocmd FileType python nmap <leader>L3 :w <CR> :AsyncRun python3 %<CR>
autocmd FileType bash nmap <leader>L :w <CR> :term bash %<CR>
"----------------------------------------------------------------------------------------
" autocmd VimEnter,WinEnter,BufNewFile,BufRead,BufEnter,TabEnter * IndentLinesReset

let g:clang_format#detect_style_file = 0
let g:clang_format#style_options = {
		\ "Language" : "Cpp",
        \ "BasedOnStyle" : "Google",
        \ "AccessModifierOffset" : -1,
        \ "AlignAfterOpenBracket" : "true",
        \ "AlignEscapedNewlinesLeft" : "true",
        \ "AlignOperands" : "true",
        \ "AllowAllParametersOfDeclarationOnNextLine" : "true",
        \ "AllowShortBlocksOnASingleLine" : "false",
        \ "AllowShortCaseLabelsOnASingleLine" : "false",
        \ "AllowShortIfStatementsOnASingleLine" : "true",
		\ "AlignConsecutiveAssignments" : "true",
		\ "AlignTrailingComments" : "true",
        \ "AllowShortLoopsOnASingleLine" : "true",
        \ "AllowShortFunctionsOnASingleLine" : "All",
        \ "AlwaysBreakAfterDefinitionReturnType" : "false",
        \ "AlwaysBreakTemplateDeclarations" : "true",
        \ "AlwaysBreakBeforeMultilineStrings" : "true",
        \ "BreakBeforeBinaryOperators" : "None",
        \ "BreakBeforeTernaryOperators" : "true",
        \ "BreakConstructorInitializersBeforeComma" : "false",
        \ "BinPackParameters" : "true",
        \ "BinPackArguments" : "true",
        \ "ColumnLimit" : 0,
        \ "ConstructorInitializerAllOnOneLineOrOnePerLine" : "true",
        \ "ConstructorInitializerIndentWidth" : 5,
        \ "DerivePointerAlignment" : "true",
        \ "ExperimentalAutoDetectBinPacking" : "false",
        \ "IndentCaseLabels" : "true",
        \ "IndentWrappedFunctionNames" : "false",
        \ "IndentFunctionDeclarationAfterType" : "false",
        \ "MaxEmptyLinesToKeep" : 1,
        \ "KeepEmptyLinesAtTheStartOfBlocks" : "false",
        \ "NamespaceIndentation" : "None",
        \ "ObjCBlockIndentWidth" : 2,
        \ "ObjCSpaceAfterProperty" : "false",
        \ "ObjCSpaceBeforeProtocolList" : "false",
        \ "PenaltyBreakBeforeFirstCallParameter" : 1,
        \ "PenaltyBreakComment" : 300,
        \ "PenaltyBreakString" : 1000,
        \ "PenaltyBreakFirstLessLess" : 120,
        \ "PenaltyExcessCharacter" : 1000000,
        \ "PenaltyReturnTypeOnItsOwnLine" : 200,
        \ "PointerAlignment" : "Left",
        \ "SpacesBeforeTrailingComments" : 2,
        \ "Cpp11BracedListStyle" : "true",
        \ "Standard" : "Auto",
        \ "IndentWidth" : 4,
        \ "TabWidth" : 4,
        \ "UseTab" : "true",
        \ "BreakBeforeBraces" : "Allman",
        \ "SpacesInParentheses" : "false",
        \ "SpacesInSquareBrackets" : "false",
        \ "SpacesInAngles" : "false",
        \ "SpaceInEmptyParentheses" : "false",
        \ "SpacesInCStyleCastParentheses" : "false",
        \ "SpaceAfterCStyleCast" : "false",
        \ "SpacesInContainerLiterals" : "true",
        \ "SpaceBeforeAssignmentOperators" : "true",
        \ "ContinuationIndentWidth" : 3 }


function! s:vimfiler_settings()
		  " Monkey-patch of Issue 290
			nmap <buffer> E <Plug>(vimfiler_split_edit_file):set nowinfixwidth<CR>
endfunction


" Vimspector 配置文件生成
" 
" packadd! vimspector
function GenerateSepctorForCpp()
	if findfile(".vimspector.json", ".") 
		echo 'finded'
		return
	endif

	" execute 'silent !drush cc all &' | redraw!
	"
	execute ":call system(\' echo { > .vimspector.json&sleep 0.001\')"
	execute ":call system(\' echo       \\\"configurations\\\": { >> .vimspector.json&sleep 0.001\')"
	execute ":call system(\' echo         \\\"Launch\\\": { >> .vimspector.json&sleep 0.001\')"
	execute ":call system(\' echo           \\\"adapter\\\": \\\"vscode-cpptools\\\", >> .vimspector.json&sleep 0.001\')"
	execute ":call system(\' echo           \\\"configuration\\\": { >> .vimspector.json&sleep 0.001\')"
	execute ":call system(\' echo             \\\"request\\\": \\\"launch\\\", >> .vimspector.json&sleep 0.001\')"
	execute ":call system(\' echo             \\\"program\\\": \\\"./main\\\", >> .vimspector.json&sleep 0.001\')"
	execute ":call system(\' echo              \\\"stopAtEntry\\\": false >> .vimspector.json&sleep 0.001\')"
	execute ":call system(\' echo \"}\" >> .vimspector.json&sleep 0.001\')"
	execute ":call system(\' echo \"}\" >> .vimspector.json&sleep 0.001\')"
	execute ":call system(\' echo \"}\" >> .vimspector.json&sleep 0.001\')"
	execute ":call system(\' echo \"}\" >> .vimspector.json&sleep 0.001\')"

	echo ".vimspector.json for cpp generated."
endfunction

function GenerateSepctorForPython()
	if findfile(".vimspector.json", ".") 
		execute ":asyncrun rm .vimspector.json"
		"echo 'finded'
		"return
	endif

	" execute 'silent !drush cc all &' | redraw!
	"
	execute ":call system(\' echo { > .vimspector.json&sleep 0.001\')"
	execute ":call system(\' echo       \\\"configurations\\\": { >> .vimspector.json&sleep 0.001\')"
	execute ":call system(\' echo         \\\"Launch\\\": { >> .vimspector.json&sleep 0.001\')"
	execute ":call system(\' echo           \\\"adapter\\\": \\\"debugpy\\\", >> .vimspector.json&sleep 0.001\')"
	execute ":call system(\' echo           \\\"configuration\\\": { >> .vimspector.json&sleep 0.001\')"
	execute ":call system(\' echo             \\\"request\\\": \\\"launch\\\", >> .vimspector.json&sleep 0.001\')"
	execute ":call system(\' echo             \\\"program\\\": \\\"./main.py\\\", >> .vimspector.json&sleep 0.001\')"
	execute ":call system(\' echo              \\\"stopAtEntry\\\": false >> .vimspector.json&sleep 0.001\')"
	execute ":call system(\' echo \"}\" >> .vimspector.json&sleep 0.001\')"
	execute ":call system(\' echo \"}\" >> .vimspector.json&sleep 0.001\')"
	execute ":call system(\' echo \"}\" >> .vimspector.json&sleep 0.001\')"
	execute ":call system(\' echo \"}\" >> .vimspector.json&sleep 0.001\')"

	echo ".vimspector.json for python generated."
endfunction


" cscope 索引更新函数
function UpdateCtags()
	set autochdir
    let curdir=getcwd()
    while !filereadable("./tags")
        cd ..
        if getcwd() == "/"
            break
        endif
    endwhile
    if filewritable("./tags")
        :AsyncRun ctags -R
    endif
    execute ":cd " . curdir
endfunction

function UpdateCStags()
	set autochdir " 将工作目录设置为当前目录
    let curdir=getcwd()
    while !filereadable("./cscope.out")
        cd ..
        if getcwd() == "/"
            break
        endif
    endwhile
    if filewritable("./cscope.out")
		" :!touch 1
        :AsyncRun  cscope -Rbq 
		execute ":cclose"
        execute ":cscope kill 0"
        execute ":cscope add cscope.out"
	else
		" :!touch 2
		set autochdir
		:! cscope -Rbq
        execute ":cscope add cscope.out"
    endif
    execute ":cd " . curdir
endfunction

"" markdown 导航窗格
"let g:tagbar_type_markdown = {
        "\ 'ctagstype' : 'markdown',
        "\ 'kinds' : [
                "\ 'h:headings',
        "\ ],
    "\ 'sort' : 0
"\ }

"autocmd FileType cpp nmap <leader>dl :AsyncRun -raw g++ "%" -g -o main<CR> :AsyncRun make<CR>:packadd termdebug<CR>:Termdebug main<CR> <C-w>N:vertical resize 40<CR>:Source<CR>
"autocmd FileType cpp nmap <leader>dl :packadd termdebug<CR>:Termdebug main<CR> <C-w>N:vertical resize 40<CR>:Source<CR>
"autocmd FileType c nmap <leader>dl :packadd termdebug<CR>:Termdebug main<CR> <C-w>N:vertical resize 40<CR>:Source<CR>
"autocmd FileType c nmap <leader>dl :AsyncRun -raw gcc "%" -g -o main<CR> :AsyncRun make<CR> :packadd termdebug<CR> :Termdebug main<CR> <C-w>N:vertical resize 40<CR>:Source<CR>
"
" 更新cscope cstag索引
" autocmd FileType c nmap <leader>F  :AsyncRun cscope -Rbq <cr>:cclose<cr>:cscope add cscope.out<cr>  "  弃用
" autocmd FileType py nmap <leader>F  :AsyncRun cscope -Rb <cr>:cclose<cr>
" autocmd FileType cpp nmap <leader>F  :AsyncRun cscope -Rbq <cr>:cclose<cr>:cscope add cscope.out<cr>"  弃用

autocmd FileType c nmap <leader>fu :call UpdateCStags()<cr>:call UpdateCtags()<cr>:cclose<cr>lh
autocmd FileType py nmap <leader>fu :call UpdateCStags()<cr>:call UpdateCtags()<cr>:cclose<cr>
autocmd FileType cpp nmap <leader>fu :call UpdateCStags()<cr>:call UpdateCtags()<cr>:cclose<cr>lh
 "autocmd FileType c nmap <leader>ff :AsyncRun cscope -Rb & cscope kill -1 & cscope add cscope.out <CR>

"autocmd FileType cpp nmap <leader>fl <C-\>s
"autocmd FileType c nmap <leader>fl <C-\>s

" python 代码提示(flake8) 忽略指定警告
"let g:ale_python_flake8_args = '--ignore=E501,E262,E302,E116,F841,E722'
"let g:ale_python_flake8_executable = 'flake8'
"let g:ale_python_flake8_options = '--ignore=E501,E262,E302,E116,F841,E722'
