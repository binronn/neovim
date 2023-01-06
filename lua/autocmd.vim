

autocmd FileType c,cpp,h,hpp nmap <leader>ff :ClangFormat<CR>
autocmd FileType c,cpp,h,hpp vmap <leader>ff :ClangFormat<CR>

"autocmd FileType cpp nmap <leader>dmm :wa<CR>:!make && read<CR> 
"autocmd FileType cpp nmap <leader>dmg :wa<CR>:!g++ "%" -g -o main && read<CR> 

autocmd FileType c,cpp nmap <leader>dmc :wa<CR>:AsyncRun cmake . & make & read<CR> 
autocmd FileType c,cpp nmap <leader>dmm :wa<CR>:AsyncRun make & read<CR> 
autocmd FileType c,cpp nmap <leader>dmg :wa<CR>:AsyncRun gcc "%" -g -o main<CR> 

autocmd FileType c,cpp nmap <leader>L :w <CR> :AsyncRun  ./main<CR>

"autocmd FileType python nmap <leader>l2 :w <CR> :rightbelow vert term python2 %<CR>
"autocmd FileType python nmap <leader>l3 :w <CR> :rightbelow vert term python3 %<CR>
autocmd FileType python nmap <leader>lf3 :w <CR> :rightbelow vert term python3 
autocmd FileType python nmap <leader>lf2 :w <CR> :rightbelow vert term python2 
autocmd FileType python nmap <leader>L2 :w <CR> :AsyncRun python2 %<CR>
autocmd FileType python nmap <leader>L3 :w <CR> :AsyncRun python3 %<CR>
autocmd FileType bash nmap <leader>L :w <CR> :term bash %<CR>

