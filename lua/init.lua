
--------------------
---- 顺序不可变 ----
--------------------
vim.g.mapleader = " "
require 'plugins'
require 'basic'
require 'keymaps'
require 'coc_init'
require 'autocmd'

--vim.cmd('source ~/.config/nvim/coc_init.vim')
vim.cmd('source ~/.config/nvim/vim/plugins_init.vim')
vim.cmd('source ~/.config/nvim/vim/autocmd.vim')


local fn = vim.fn

--vim.cmd([[
--autocmd FileType json syntax match Comment +\/\/.\+$+
--]])

--[[function SetupCommandAbbrs(from, to)]]
  --[[fn.system('cnoreabbrev <expr> ' + a + ]]
         --[[' ((getcmdtype() ==# ":" && getcmdline() ==# "'from'")' +]]
         --[['? ("'to'") : ("'from'"))')]]
--[[end]]

--[[SetupCommandAbbrs('CC', 'CocCommand<CR>')]]
