
"----------------------------------------------------------------------------------------
" MarkDown图片问题, 执行脚本并插入命令
" 图片将保存到，当前文件同级目录下的 img 文件夹
" 文件夹 不错在 则报错
"----------------------------------------------------------------------------------------
"
" 迁移需修改 ~/.vim/BlogImg/save_screen_img.py 的变量
" 修改 python 路径等
" 并在 Windows 中的 python 中 安装 Pillow 库
autocmd FileType md,markdown nnoremap <leader>ip :let @a = system('~/.vim/BlogImg/save_screen_img.py %')<CR>"ap
autocmd FileType md,markdown nnoremap <leader>ir :%s/\/img\//https:\/\/gitee.com\/imgset\/img\/raw\/master\//g<CR>
autocmd FileType md,markdown nnoremap <leader>is :AsyncRun cd img&&git add .&&git commit -m "img"&&git push origin master<CR>
"----------------------------------------------------------------------------------------


"----------------------------------------------------------------------------------------
" 代码片段设置
"----------------------------------------------------------------------------------------
" 选中代码后创建代码片段
"
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

"----------------------------------------------------------------------------------------
" 头文件切换
"----------------------------------------------------------------------------------------
"
autocmd FileType c,cpp,h,hpp nmap <leader>fh :CocCommand clangd.switchSourceHeader<CR>
"----------------------------------------------------------------------------------------


"----------------------------------------------------------------------------------------
" 类窗口配置
"----------------------------------------------------------------------------------------
"
nmap <F2> :Vista!!<CR>
"
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


"----------------------------------------------------------------------------------------
"语法插件高亮配置
"----------------------------------------------------------------------------------------
"
"let c_no_curly_error = 1

" 高亮插件
"let g:mwDefaultHighlightingPalette = 'extended'
"let g:mwDefaultHighlightingPalette = 'maximum'
"----------------------------------------------------------------------------------------

"----------------------------------------------------------------------------------------
" 异步shell插件 窗口设置
"----------------------------------------------------------------------------------------
"
let g:asyncrun_open = 12
"----------------------------------------------------------------------------------------


"----------------------------------------------------------------------------------------
" indentLine配置
"----------------------------------------------------------------------------------------
"
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


"----------------------------------------------------------------------------------------
" 书签保存设置
"----------------------------------------------------------------------------------------
"
let g:bookmark_save_per_working_dir = 0 " 书签保存到工作目录
let g:bookmark_auto_save = 1  " 自动保存书签
"----------------------------------------------------------------------------------------


"----------------------------------------------------------------------------------------
" LeaderF 配置
"----------------------------------------------------------------------------------------
"
" 取消此按键的映射
nmap <leader>b <nop>
nmap <leader>f <nop>

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


"call SetupCommandAbbrs('LF', 'Leaderf')

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

let g:Lf_ShortcutF = ""
"noremap <leader>sf :LeaderfFile<CR> 

"noremap <C-B> :<C-U><C-R>=printf("Leaderf! rg --current-buffer -e %s ", expand("<cword>"))<CR>
"noremap <C-F> :<C-U><C-R>=printf("Leaderf! rg -e %s ", expand("<cword>"))<CR>
" search visually selected text literally
"xnoremap sf :<C-U><C-R>=printf("Leaderf! rg -F -e %s ", leaderf#Rg#visual())<CR>
"noremap so :<C-U>Leaderf! rg --recall<CR>

" should use `Leaderf gtags --update` first
let g:Lf_GtagsAutoGenerate = 1
let g:Lf_Gtagslabel = 'native-pygments'
" Leaderf ignore current buffer name
let g:Lf_IgnoreCurrentBufferName = 1

" 弹出式窗口
let g:Lf_WindowPosition = 'popup'
"----------------------------------------------------------------------------------------
"
"----------------------------------------------------------------------------------------
" GIT coc-git
"----------------------------------------------------------------------------------------
" navigate chunks of current buffer
nmap gp <Plug>(coc-git-prevchunk)
nmap gn <Plug>(coc-git-nextchunk)
" navigate conflicts of current buffer
nmap gcp <Plug>(coc-git-prevconflict)
nmap gcn <Plug>(coc-git-nextconflict)
" show chunk diff at current position
nmap gs <Plug>(coc-git-chunkinfo)
" show commit contains current position
nmap gc <Plug>(coc-git-commit)
" create text object for git chunks
omap ig <Plug>(coc-git-chunk-inner)
xmap ig <Plug>(coc-git-chunk-inner)
omap ag <Plug>(coc-git-chunk-outer)
xmap ag <Plug>(coc-git-chunk-outer)
"----------------------------------------------------------------------------------------


"----------------------------------------------------------------------------------------
" 文件窗口 coc-explorer
"----------------------------------------------------------------------------------------
"
nmap <F3> <Cmd>CocCommand explorer --position right<CR>
"nmap <Leader>er <Cmd>call CocAction('runCommand', 'explorer.doAction', 'closest', ['reveal:0'], [['relative', 0, 'file']])<CR>
"let g:coc_explorer_global_presets = {
"\   '.vim': {
"\     'root-uri': '~/.config',
"\   },
"\   'tab': {
"\     'position': 'tab',
"\     'quit-on-open': v:false,
"\   },
"\   'tab:$': {
"\     'position': 'tab:$',
"\     'quit-on-open': v:false,
"\   },
"\   'floating': {
"\     'position': 'floating',
"\     'open-action-strategy': 'sourceWindow',
"\   },
"\   'floatingTop': {
"\     'position': 'floating',
"\     'floating-position': 'center-top',
"\     'open-action-strategy': 'sourceWindow',
"\   },
"\   'floatingLeftside': {
"\     'position': 'floating',
"\     'floating-position': 'left-center',
"\     'floating-width': 50,
"\     'open-action-strategy': 'sourceWindow',
"\   },
"\   'floatingRightside': {
"\     'position': 'floating',
"\     'floating-position': 'right-center',
"\     'floating-width': 50,
"\     'open-action-strategy': 'sourceWindow',
"\   },
"\   'simplify': {
"\     'file-child-template': '[selection | clip | 1] [indent][icon | 1] [filename omitCenter 1]'
"\   },
"\   'buffer': {
"\     'sources': [{'name': 'buffer', 'expand': v:true}]
"\   },
"\ }

" Use preset argument to open it
"nmap <space>ed <Cmd>CocCommand explorer --preset .vim<CR>
"nmap <space>ef <Cmd>CocCommand explorer --preset floating<CR>
"nmap <space>ec <Cmd>CocCommand explorer --preset cocConfig<CR>
"nmap <space>eb <Cmd>CocCommand explorer --preset buffer<CR>


"----------------------------------------------------------------------------------------
" vim-mark
"----------------------------------------------------------------------------------------
"
nmap <leader>N :MarkClear<CR>
"----------------------------------------------------------------------------------------


"----------------------------------------------------------------------------------------
" ASYNC RUN
"----------------------------------------------------------------------------------------
"
nmap <leader>ar :AsyncRun 
nmap <leader>as :AsyncStop<CR>
"----------------------------------------------------------------------------------------


"----------------------------------------------------------------------------------------
" 格式化代码
"----------------------------------------------------------------------------------------
"
nmap <leader>ff <Plug>(coc-format-selected) 
xmap <leader>ff <Plug>(coc-format-selected) 
"----------------------------------------------------------------------------------------


"----------------------------------------------------------------------------------------
" 重命名
"----------------------------------------------------------------------------------------
"
map <leader>rn <Plug>(coc-rename)
"----------------------------------------------------------------------------------------

"----------------------------------------------------------------------------------------
" 快速选中类 函数 内容 vif vic
"----------------------------------------------------------------------------------------
"
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)
"----------------------------------------------------------------------------------------


"----------------------------------------------------------------------------------------
" 查找代码报错
"----------------------------------------------------------------------------------------
"
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)


"----------------------------------------------------------------------------------------
" 代码导航
"----------------------------------------------------------------------------------------
"
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gt <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
"----------------------------------------------------------------------------------------

"----------------------------------------------------------------------------------------
" VIM SPECTOR 按键映射
"----------------------------------------------------------------------------------------
"
" 启用或关闭 vimspector
 packadd! vimspector
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

"----------------------------------------------------------------------------------------


"----------------------------------------------------------------------------------------
" cscope 索引更新函数
"----------------------------------------------------------------------------------------
"
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
"----------------------------------------------------------------------------------------


"----------------------------------------------------------------------------------------
" VIM SPECTOR 配置文件生成
"----------------------------------------------------------------------------------------
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

autocmd FileType c nmap <leader>fu :call UpdateCStags()<cr>:call UpdateCtags()<cr>:cclose<cr>lh
autocmd FileType py nmap <leader>fu :call UpdateCStags()<cr>:call UpdateCtags()<cr>:cclose<cr>
autocmd FileType cpp nmap <leader>fu :call UpdateCStags()<cr>:call UpdateCtags()<cr>:cclose<cr>lh

autocmd FileType cpp,c nmap <leader>dg :call GenerateSepctorForCpp()<cr>
autocmd FileType python nmap <leader>dg :call GenerateSepctorForPython()<cr>

"----------------------------------------------------------------------------------------


"----------------------------------------------------------------------------------------
" CLANG FORMAT 
"----------------------------------------------------------------------------------------
"
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
"----------------------------------------------------------------------------------------


