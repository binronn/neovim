" 获取当前文件路径，包含文件名
" vim.fn.expand("%:p")
" 获取当前文件路径，不包含文件名
" vim.fn.expand("%:p:h")

autocmd FileType c,cpp,h,hpp nmap <leader>ff :ClangFormat<CR>
autocmd FileType c,cpp,h,hpp vmap <leader>ff :ClangFormat<CR>

"autocmd FileType cpp nmap <leader>dmm :wa<CR>:!make && read<CR> 
"autocmd FileType cpp nmap <leader>dmg :wa<CR>:!g++ "%" -g -o main && read<CR> 

autocmd FileType c,cpp nmap <leader>dmc :wa<CR>:AsyncRun cmake . & make & read<CR> 
" autocmd FileType c,cpp nmap <leader>dmc :wa<CR>:lua require('FTerm').run({'cmake . & make & read'})<CR> 
autocmd FileType c,cpp nmap <leader>dmm :wa<CR>:AsyncRun make & read<CR> 
autocmd FileType c,cpp nmap <leader>dmg :wa<CR>:AsyncRun gcc "%" -g -o main<CR> 

autocmd FileType c,cpp nmap <leader>L :w <CR> :cclose <CR> :lua require('FTerm').run({'./main'})<CR>

autocmd FileType python nmap <leader>l2 :lua require('FTerm').run({'python2', vim.fn.expand('%:p')})<CR>
autocmd FileType python nmap <leader>l3 :lua require('FTerm').run({'python3', vim.fn.expand('%:p')})<CR>
autocmd FileType python nmap <leader>lp :lua require('FTerm').run({'python', vim.fn.expand('%:p')})<CR>
"autocmd FileType python nmap <leader>lf3 :w <CR> :rightbelow vert term python3 
"autocmd FileType python nmap <leader>lf2 :w <CR> :rightbelow vert term python2 
autocmd FileType bash nmap <leader>L :w <CR> :lua require('FTerm').run({'bash', vim.fn.expand('%:p')})<CR>


"----------------------------------------------------------------------------------------
" 头文件切换
"----------------------------------------------------------------------------------------
"
autocmd FileType c,cpp,h,hpp nmap <leader>fh :CocCommand clangd.switchSourceHeader<CR>
"----------------------------------------------------------------------------------------


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
autocmd FileType md,markdown nnoremap <leader>is :AsyncRun cd img&&git add .&&git commit -m 'img'&&git push origin master<CR>
"----------------------------------------------------------------------------------------

"----------------------------------------------------------------------------------------
" VIM SPECTOR 配置文件生成
"----------------------------------------------------------------------------------------
" Functions defined in plugins_init.vim file

autocmd FileType c nmap <leader>fu :call UpdateCStags()<cr>:call UpdateCtags()<cr>:cclose<cr>lh
autocmd FileType py nmap <leader>fu :call UpdateCStags()<cr>:call UpdateCtags()<cr>:cclose<cr>
autocmd FileType cpp nmap <leader>fu :call UpdateCStags()<cr>:call UpdateCtags()<cr>:cclose<cr>lh

autocmd FileType cpp,c nmap <leader>dg :call GenerateSepctorForCpp()<cr>
autocmd FileType python nmap <leader>dg :call GenerateSepctorForPython()<cr>

