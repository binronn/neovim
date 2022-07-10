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
augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

inoremap <silent><expr> <c-o> coc#refresh()

