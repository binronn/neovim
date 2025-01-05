
--------------------
---- 顺序不可变 ----
--------------------
vim.g.mapleader = " "
require 'plugins'
require 'common_func'
require 'basic'
require 'autocmd'
require 'keymaps'

vim.cmd('source ~/.config/nvim/vim/plugins_init.vim')
vim.cmd('source ~/.config/nvim/vim/autocmd.vim')


local fn = vim.fn


