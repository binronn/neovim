" Enable Mouse
set mouse=a
" set guifont=Source\ Code\ Pro:h10
set guifont=Hack\ Nerd\ Font:h10
let g:neovide_title_background_color = "#161616"

" Right Click Context Menu (Copy-Cut-Paste)
nnoremap <silent><RightMouse> :call GuiShowContextMenu()<CR>
inoremap <silent><RightMouse> <Esc>:call GuiShowContextMenu()<CR>
xnoremap <silent><RightMouse> :call GuiShowContextMenu()<CR>gv
snoremap <silent><RightMouse> <C-G>:call GuiShowContextMenu()<CR>gv
