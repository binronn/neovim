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
	use 'lewis6991/impatient.nvim'
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
	use 'bfrg/vim-cpp-modern' -- cpp 高亮？
	use 'jakelinnzy/autocmd-lua' -- vim cmd 提示
    use 'marko-cerovac/material.nvim' -- 主题？

  if packer_bootstrap then
    require('packer').sync()
  end

end)

require('lualine').setup {
  options = {
    icons_enabled = true,
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

--require('material').set()
