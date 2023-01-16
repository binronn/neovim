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
    use "numToStr/FTerm.nvim"
    --use { 'alvarosevilla95/luatab.nvim', requires='kyazdani42/nvim-web-devicons' }
    --use 'marko-cerovac/material.nvim' -- 主题？
    --use { 'crusoexia/vim-monokai' }

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

require("bufferline").setup{
  options ={
    show_close_icon = false,
    show_buffer_close_icons = false,
    show_buffer_icons = false,
    -- indicator_icon = '➡️',
    indicator = { icon = '➡️'},
    buffer_close_icon = '',
    modified_icon = '●',
    close_icon = '',
    left_trunc_marker = '',
    right_trunc_marker = '',
    diagnostics = 'coc'
    --show_tab_indicators = false]]
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


-----------------------------------
---- 弹出式终端，GIT对比窗口   ----
-----------------------------------
--
require'FTerm'.setup({
    border = 'double',
    dimensions  = {
        height = 0.9,
        width = 0.9,
    },
        ---Filetype of the terminal buffer
    ---@type string
    ft = 'FTerm',

    ---Command to run inside the terminal
    ---NOTE: if given string[], it will skip the shell and directly executes the command
    ---@type fun():(string|string[])|string|string[]
    cmd = os.getenv('SHELL'),

    ---Neovim's native window border. See `:h nvim_open_win` for more configuration options.
    border = 'single',

    ---Close the terminal as soon as shell/command exits.
    ---Disabling this will mimic the native terminal behaviour.
    ---@type boolean
    auto_close = true,

    ---Highlight group for the terminal. See `:h winhl`
    ---@type string
    hl = 'Normal',

    ---Transparency of the floating window. See `:h winblend`
    ---@type integer
    blend = 0,

    ---Object containing the terminal window dimensions.
    ---The value for each field should be between `0` and `1`
    ---@type table<string,number>
    dimensions = {
        height = 0.8, -- Height of the terminal window
        width = 0.8, -- Width of the terminal window
        x = 0.5, -- X axis of the terminal window
        y = 0.5, -- Y axis of the terminal window
    },

    ---Replace instead of extend the current environment with `env`.
    ---See `:h jobstart-options`
    ---@type boolean
    clear_env = false,

    ---Map of environment variables extending the current environment.
    ---See `:h jobstart-options`
    ---@type table<string,string>|nil
    env = nil,

    ---Callback invoked when the terminal exits.
    ---See `:h jobstart-options`
    ---@type fun()|nil
    on_exit = nil,

    ---Callback invoked when the terminal emits stdout data.
    ---See `:h jobstart-options`
    ---@type fun()|nil
    on_stdout = nil,

    ---Callback invoked when the terminal emits stderr data.
    ---See `:h jobstart-options`
    ---@type fun()|nil
    on_stderr = nil,
})


------------------------------------------------------------------------------------------
-- 异步shell插件 窗口设置
------------------------------------------------------------------------------------------
--
vim.g.asyncrun_open = 12
------------------------------------------------------------------------------------------


------------------------------------------------------------------------------------------
-- indentLine配置
------------------------------------------------------------------------------------------
--
vim.g.indentLine_enabled = 1
vim.g.indentLine_concealcursor = 'inc'
vim.g.indentLine_conceallevel = 2
-- indentLine
vim.g.indentLine_char='|'
vim.g.indentLine_enabled = 1
vim.cmd 'set list lcs=tab:\\|\\'
-- clang-foarmat路径配置
vim.g.clang_library_path = '/usr/bin/'
vim.cmd "let g:clang_format#command = 'clang-format'"

-- indentLine markdown 符号不显示问题
--autocmd FileType json,markdown,csv let g:indentLine_conceallevel = 0
-- vim-json json 符号 -- 不显示问题
--autocmd FileType json,markdown,csv let g:vim_json_syntax_conceal = 0
------------------------------------------------------------------------------------------


------------------------------------------------------------------------------------------
-- 书签保存设置
------------------------------------------------------------------------------------------
--
vim.g.bookmark_save_per_working_dir = 0 -- 书签保存到工作目录
vim.g.bookmark_auto_save = 1  -- 自动保存书签


------------------------------------------------------------------------------------------
-- LeaderF 配置
------------------------------------------------------------------------------------------
--
vim.g.Lf_GtagsAutoGenerate = 1
vim.g.Lf_Gtagslabel = 'native-pygments'


-- don't show the help in normal mode
vim.g.Lf_HideHelp = 1
vim.g.Lf_UseCache = 0
vim.g.Lf_UseVersionControlTool = 0
vim.g.Lf_IgnoreCurrentBufferName = 1
-- popup mode
vim.g.Lf_WindowPosition = 'popup'
vim.g.Lf_PreviewInPopup = 1
vim.cmd 'let g:Lf_StlSeparator = { "left": "\\ue0b0", "right": "\\ue0b2", "font": "DejaVu Sans Mono for Powerline" }'
vim.cmd 'let g:Lf_PreviewResult = {"Function": 0, "BufTag": 0 }'


vim.g.Lf_ShortcutF = ""
--noremap <leader>sf :LeaderfFile<CR> 

--noremap <C-B> :<C-U><C-R>=printf("Leaderf! rg --current-buffer -e %s ", expand("<cword>"))<CR>
--noremap <C-F> :<C-U><C-R>=printf("Leaderf! rg -e %s ", expand("<cword>"))<CR>
-- search visually selected text literally
--xnoremap sf :<C-U><C-R>=printf("Leaderf! rg -F -e %s ", leaderf#Rg#visual())<CR>
--noremap so :<C-U>Leaderf! rg --recall<CR>

-- should use `Leaderf gtags --update` first
-- Leaderf ignore current buffer name

