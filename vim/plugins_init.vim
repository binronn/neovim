
"----------------------------------------------------------------------------------------
" 代码片段设置
"----------------------------------------------------------------------------------------
" 选中代码后创建代码片段
"
" xmap <leader>x  <Plug>(coc-convert-snippet)

" inoremap <silent><expr> <c-j>
" 	  \ pumvisible() ? coc#_select_confirm() :
" 	  \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
" 	  \ <SID>check_back_space() ? "\<c-j>" :
" 	  \ coc#refresh()

" function! s:check_back_space() abort
"   let col = col('.') - 1
"   return !col || getline('.')[col - 1]  =~# '\s'
" endfunction

"let g:coc_snippet_next = '<c-j>'
"----------------------------------------------------------------------------------------

"----------------------------------------------------------------------------------------
" 类窗口配置
"----------------------------------------------------------------------------------------
"
" nmap <F2> :Vista!!<CR>
" "
" function! NearestMethodOrFunction() abort
"   return get(b:, 'vista_nearest_method_or_function', '')
" endfunction

" set statusline+=%{NearestMethodOrFunction()}

" " By default vista.vim never run if you don't call it explicitly.
" "
" " If you want to show the nearest function in your statusline automatically,
" " you can add the following line to your vimrc
" autocmd VimEnter * call vista#RunForNearestMethodOrFunction()

" let g:lightline = {
"       \ 'colorscheme': 'wombat',
"       \ 'active': {
"       \   'left': [ [ 'mode', 'paste' ],
"       \             [ 'readonly', 'filename', 'modified', 'method' ] ]
"       \ },
"       \ 'component_function': {
"       \   'method': 'NearestMethodOrFunction'
"       \ },
"       \ }

" let g:vista_sidebar_position="vertical topleft"
" let g:vista_sidebar_width=40
"----------------------------------------------------------------------------------------
"----------------------------------------------------------------------------------------

"noremap <C-B> :<C-U><C-R>=printf("Leaderf! rg --current-buffer -e %s ", expand("<cword>"))<CR>
"noremap <C-F> :<C-U><C-R>=printf("Leaderf! rg -e %s ", expand("<cword>"))<CR>
" search visually selected text literally
"xnoremap sf :<C-U><C-R>=printf("Leaderf! rg -F -e %s ", leaderf#Rg#visual())<CR>
"noremap so :<C-U>Leaderf! rg --recall<CR>

" should use `Leaderf gtags --update` first
" Leaderf ignore current buffer name


"call SetupCommandAbbrs('LF', 'Leaderf')
"----------------------------------------------------------------------------------------
"
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


