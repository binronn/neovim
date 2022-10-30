-- 这部分帮助你在自动下载所需的packers.nvim文件
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

require('packer').startup(function(use)
  -- 有意思的是，packer可以用自己管理自己。
	use 'wbthomason/packer.nvim'
  -- your plugins here
    use {
        "ellisonleao/gruvbox.nvim",
        requires = {"rktjmp/lush.nvim"}
    }
    use { 
        'nvim-lualine/lualine.nvim',
		requires = { 'kyazdani42/nvim-web-devicons', opt = true }
      }
	use { 'kyazdani42/nvim-web-devicons' }
	--use 'lewis6991/impatient.nvim'
	--use 'AGou-ops/dashboard-nvim'
	use 'tpope/vim-sensible'
	-- use 'octol/vim-cpp-enhanced-highlight' -- cpp 语法高亮插件
	use 'sheerun/vim-polyglot' -- 高亮配置
     use 'mhinz/vim-startify'
	use 'Yggdroot/indentLine' -- tab 竖线
	use 'liuchengxu/vista.vim' -- 类窗口
	use 'inkarkat/vim-mark' -- 高亮
	use 'inkarkat/vim-ingo-library'
	use 'morhetz/gruvbox' -- 主题
    use {
      'neoclide/coc.nvim',
      branch = "release"
    }
	use 'scrooloose/nerdcommenter' -- 注释插件
	-- use 'sbdchd/neoformat'
	use 'MattesGroeger/vim-bookmarks' -- 书签
	use 'skywind3000/asyncrun.vim' -- 异步执行命令插件
	use 'Yggdroot/LeaderF' -- , { 'do': ':LeaderfInstallCExtension'}
	use 'rhysd/vim-clang-format' -- ,{ 'for': ['cpp','c','h']  }
	use 'Raimondi/delimitMate' -- 自动补全插件 () {} ......
	use 'liuchengxu/space-vim-theme'
	use 'puremourning/vimspector' -- 多语言调试工具
	use 'tmhedberg/SimpylFold' -- 代码折叠
	use 'itchyny/vim-cursorword' -- 高亮光标下单词
	use 'honza/vim-snippets'  -- 代码片段
	-- use 'bfrg/vim-cpp-modern' -- cpp 高亮？
	use 'jakelinnzy/autocmd-lua' -- vim cmd 提示
    use {'akinsho/bufferline.nvim', tag = "v2.*", requires = 'kyazdani42/nvim-web-devicons'}
    use {
        'nvim-treesitter/nvim-treesitter',      -- 语法高亮
        run = function() require('nvim-treesitter.install').update({ with_sync = true }) end,
    }
    --use { 'alvarosevilla95/luatab.nvim', requires='kyazdani42/nvim-web-devicons' }
    --use 'marko-cerovac/material.nvim' -- 主题？
    --use { 'crusoexia/vim-monokai' }

  if packer_bootstrap then
    require('packer').sync()
  end

end)

require('lualine').setup {
  options = {
    icons_enabled = false,
    theme = 'auto',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {},
    always_divide_middle = true,
    globalstatus = false,
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  extensions = {}
}

require("bufferline").setup{
  options ={
    show_buffer_icons = false,
    show_buffer_default_icon = false,
    show_close_icon = false,
    show_buffer_close_icons = false,
    indicator_icon = '>>',
    buffer_close_icon = 'B',
    modified_icon = '*',
    close_icon = ' ',
    left_trunc_marker = '',
    right_trunc_marker = '',
    diagnostics = 'coc',
    -- show_tab_indicators = false
  }
}

--require('luatab').setup{}

------------------------------------------
---- for nvim-treesitter 语法高亮配置 ----
------------------------------------------
--
vim.api.nvim_create_autocmd({'BufEnter','BufAdd','BufNew','BufNewFile','BufWinEnter'}, {
  group = vim.api.nvim_create_augroup('TS_FOLD_WORKAROUND', {}),
  callback = function()
    vim.opt.foldmethod     = 'expr'
    vim.opt.foldexpr       = 'nvim_treesitter#foldexpr()'
  end
})

require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all"
  ensure_installed = { "c", "lua", "python", "cpp" , "markdown", "vim", "sql", "yaml", 
  "bash", "cmake", "json", "javascript", "java", "kotlin", "llvm", "make", "qmljs"},

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  auto_install = true,

  -- List of parsers to ignore installing (for "all")
  ignore_install = { "javascript" },

  highlight = {
    -- `false` will disable the whole extension
    enable = true,

    -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
    -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
    -- the name of the parser)
    -- list of language that will be disabled
    disable = { "" },

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}

-----------------------------------
---- VIM MARK 高亮数量限制解除 ----
-----------------------------------
--
vim.g.mwDefaultHighlightingPalette='maximum'

