
let g:maplocalleader = ' '
let g:mapleader = ' '
if exists('g:vscode')
    lua require('vscode_init')
else
    lua require('init')
endif

