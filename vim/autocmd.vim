

autocmd FileType c,cpp,h,hpp nmap <leader>ff :ClangFormat<CR>
autocmd FileType c,cpp,h,hpp vmap <leader>ff :ClangFormat<CR>

"autocmd FileType cpp nmap <leader>dmm :wa<CR>:!make && read<CR> 
"autocmd FileType cpp nmap <leader>dmg :wa<CR>:!g++ "%" -g -o main && read<CR> 

autocmd FileType c,cpp nmap <leader>dmc :wa<CR>:AsyncRun cmake . & make & read<CR> 
autocmd FileType c,cpp nmap <leader>dmm :wa<CR>:AsyncRun make & read<CR> 
autocmd FileType c,cpp nmap <leader>dmg :wa<CR>:AsyncRun gcc "%" -g -o main<CR> 

"autocmd FileType c,cpp nmap <leader>L :w <CR> :AsyncRun  ./main<CR>
autocmd FileType c,cpp nmap <leader>L :cclose <CR> :w <CR> :lua require('FTerm').run('./main')<CR>

autocmd FileType python nmap <leader>l2 :w <CR> :lua require('FTerm').run('python2 ' .. vim.fn.expand('%'))<CR>
autocmd FileType python nmap <leader>l3 :w <CR> :lua require('FTerm').run('python3 ' .. vim.fn.expand('%'))<CR>
autocmd FileType python nmap <leader>lf3 :w <CR> :rightbelow vert term python3 
autocmd FileType python nmap <leader>lf2 :w <CR> :rightbelow vert term python2 
autocmd FileType bash nmap <leader>L :w <CR> :lua require('FTerm').run('bash ' .. vim.fn.expand('%'))<CR>

