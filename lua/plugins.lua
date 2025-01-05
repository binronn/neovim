-- 这部分帮助你在自动下载所需的packers.nvim文件
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

local programming_filetypes = {
  "c",          -- C
  "cpp",        -- C++
  "java",       -- Java
  "python",     -- Python
  "javascript", -- JavaScript
  "typescript", -- TypeScript
  "lua",        -- Lua
  "rust",       -- Rust
  "go",         -- Go
  "ruby",       -- Ruby
  "php",        -- PHP
  "html",       -- HTML
  "css",        -- CSS
  "scss",       -- SCSS
  "json",       -- JSON
  "yaml",       -- YAML
  "toml",       -- TOML
  "bash",       -- Bash
  "sh",         -- Shell Script
  "zsh",        -- Zsh
  "fish",       -- Fish Shell
  "vim",        -- Vim Script
  "markdown",   -- Markdown
  "tex",        -- LaTeX
  "sql",        -- SQL
  "dockerfile", -- Dockerfile
  "make",       -- Makefile
  "cmake",      -- CMake
  "perl",       -- Perl
  "r",          -- R
  "swift",      -- Swift
  "kotlin",     -- Kotlin
  "scala",      -- Scala
  "haskell",    -- Haskell
  "ocaml",      -- OCaml
  "elixir",     -- Elixir
  "erlang",     -- Erlang
  "clojure",    -- Clojure
  "fsharp",     -- F#
  "dart",       -- Dart
  "groovy",     -- Groovy
  "puppet",     -- Puppet
  "terraform",  -- Terraform
  "proto",      -- Protocol Buffers
  "thrift",     -- Thrift
  "graphql",    -- GraphQL
  "vue",        -- Vue.js
  "svelte",     -- Svelte
  "elixir",     -- Elixir
  "erlang",     -- Erlang
  "clojure",    -- Clojure
  "fsharp",     -- F#
  "dart",       -- Dart
  "groovy",     -- Groovy
  "puppet",     -- Puppet
  "terraform",  -- Terraform
  "proto",      -- Protocol Buffers
  "thrift",     -- Thrift
  "graphql",    -- GraphQL
  "vue",        -- Vue.js
  "svelte",     -- Svelte
},

require('packer').startup(function(use)
  -- 有意思的是，packer可以用自己管理自己。
	use 'wbthomason/packer.nvim'

    use {
        "ellisonleao/gruvbox.nvim",
        requires = {"rktjmp/lush.nvim"}
    }

    use { 
        'nvim-lualine/lualine.nvim',
		requires = { 'kyazdani42/nvim-web-devicons', opt = true }
    }

	use { 'kyazdani42/nvim-web-devicons' }
	use 'tpope/vim-sensible'
	use 'sheerun/vim-polyglot' -- 高亮配置
    -- use 'mhinz/vim-startify' -- 启动窗口
    use {
      'nvimdev/dashboard-nvim',
      event = 'VimEnter',
      config = function()
        require('dashboard').setup {
        }
      end,
      requires = {'nvim-tree/nvim-web-devicons'}
    }

    --
    use 'majutsushi/tagbar' -- 类窗口
	use 'inkarkat/vim-mark' -- 高亮
	use 'inkarkat/vim-ingo-library'
	use 'morhetz/gruvbox' -- 主题
    use 'numToStr/Comment.nvim' -- 注释插件
	use 'MattesGroeger/vim-bookmarks' -- 书签
	use 'skywind3000/asyncrun.vim' -- 异步执行命令插件
	use 'rhysd/vim-clang-format' -- ,{ 'for': ['cpp','c','h']  }
	use 'Raimondi/delimitMate' -- 自动补全插件 () {} ......
	use 'liuchengxu/space-vim-theme'
	use 'tmhedberg/SimpylFold' -- 代码折叠
	use 'itchyny/vim-cursorword' -- 高亮光标下单词
	use 'jakelinnzy/autocmd-lua' -- vim cmd 提示
    use {'akinsho/bufferline.nvim', tag = "v4.*", requires = 'kyazdani42/nvim-web-devicons'}
    use {
        'nvim-treesitter/nvim-treesitter',      -- 语法高亮
        run = function() require('nvim-treesitter.install').update({ with_sync = true }) end,
    }
    use "numToStr/FTerm.nvim"
    use "sindrets/diffview.nvim" -- GIT DIFF MERGE WINDOW
    use 'tpope/vim-fugitive' --  Git 插件 :G status<CR> :G ..<CR>
    use {
          'lewis6991/gitsigns.nvim', -- 侧边栏显示 Git 状态
            config = function()
            require('gitsigns').setup()
          end
    }

    use {
      "lukas-reineke/indent-blankline.nvim",
      event = "BufRead",
      config = function()
        local highlight = {
            "RainbowRed",
            "RainbowYellow",
            "RainbowBlue",
            "RainbowOrange",
            "RainbowGreen",
            "RainbowViolet",
            "RainbowCyan",
        }

        local hooks = require "ibl.hooks"
        -- create the highlight groups in the highlight setup hook, so they are reset
        -- every time the colorscheme changes
        hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
            vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
            vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
            vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
            vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
            vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
            vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
            vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
        end)

        require("ibl").setup { indent = { highlight = highlight } }
      end
    }

    use 'nvim-tree/nvim-tree.lua'     -- 文件浏览器

    -- LSP 和补全
    use 'neovim/nvim-lspconfig'       -- LSP 配置
    use 'hrsh7th/nvim-cmp'            -- 补全引擎
    use 'hrsh7th/cmp-nvim-lsp'        -- LSP 补全源
    use 'hrsh7th/cmp-buffer'          -- 缓冲区补全源
    use 'hrsh7th/cmp-path'            -- 文件路径补全
    use 'L3MON4D3/LuaSnip'            -- 代码片段引擎
    use 'saadparwaiz1/cmp_luasnip'    -- 代码片段补全源
    use 'jose-elias-alvarez/null-ls.nvim' -- 代码格式化插件

    use {
      'nvim-telescope/telescope.nvim',
      requires = { 'nvim-lua/plenary.nvim' },
    }
    -- 安装 Telescope 插件
    use {
     'nvim-telescope/telescope-fzf-native.nvim',  -- 提供更快的模糊查找
      run = 'make',  -- 需要编译
      requires = {
        'nvim-telescope/telescope-file-browser.nvim',  -- 文件浏览器
        'nvim-telescope/telescope-live-grep-args.nvim',  -- 增强 live_grep
        'nvim-telescope/telescope-ui-select.nvim',  -- 增强 UI 选择
      },
    }

    -- 调试插件
    use {
      'mfussenegger/nvim-dap',
      event = {"BufRead", "BufNewFile"},
      ft = programming_filetypes,
      requires = {
        'nvim-neotest/nvim-nio',
        'rcarriga/nvim-dap-ui',
        'theHamsta/nvim-dap-virtual-text',
        'mfussenegger/nvim-dap-python',
      }
    }

    -- CMAKE 插件
    use {
      'Civitasv/cmake-tools.nvim',
      requires = {
        'nvim-lua/plenary.nvim', -- 依赖插件
        'mfussenegger/nvim-dap',  -- 调试支持
      },
    }

    ------------------------------------------
    ----     avante AI                    ----
    ------------------------------------------
    ---
    use {
      "yetone/avante.nvim",
      event = {"BufRead", "BufNewFile"},
      ft = programming_filetypes,
      config = function()
        require('avante_cfg')
      end,
      run = "make", -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
      -- run = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
      requires = {
        "nvim-treesitter/nvim-treesitter",
        "stevearc/dressing.nvim",
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        --- The below dependencies are optional,
        "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
        -- "zbirenbaum/copilot.lua", -- for providers='copilot'
        -- {
        --   -- support for image pasting
        --   "HakonHarnes/img-clip.nvim",
        --   event = "BufRead",
        --   config = function()
        --     require("img-clip").setup({
        --       -- recommended settings
        --       default = {
        --         embed_image_as_base64 = false,
        --         prompt_for_file_name = false,
        --         drag_and_drop = {
        --           insert_mode = true,
        --         },
        --         -- required for Windows users
        --         use_absolute_path = true,
        --       },
        --     })
        --   end,
        -- },
        -- {
        --   -- Make sure to set this up properly if you have lazy=true
        {
        'MeanderingProgrammer/render-markdown.nvim',
          config = function()
            require("render-markdown").setup({
              file_types = { "markdown", "Avante" },
            })
          end,
          ft = { "markdown", "Avante" },
        },
      },
    }

    ------------------------------------------
    ----     avante AI END                ----
    ------------------------------------------
    ---

 
end)

require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'auto',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    }
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {
      { 'filename', path = 1 },  -- 显示文件名
      { 'gitsigns', blame = true },  -- 显示 Git Blame 信息
    },
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
  winbar = {},
  inactive_winbar = {},
  extensions = {}
}

------------------------------------------
----     bufferline 语法高亮配置      ----
------------------------------------------
require("bufferline").setup{
  options ={
    mode = "buffers",
    numbers = "ordinal",
    separator_style = 'slant',
    show_close_icon = false,
    show_buffer_close_icons = false,
    show_buffer_icons = false,
    -- indicator_icon = '➡️',
    indicator = { icon = ' ●'},
    buffer_close_icon = '',
    modified_icon = '[+]',
    close_icon = '',
    left_trunc_marker = '',
    right_trunc_marker = '',
    diagnostics = "nvim_lsp",  -- 使用 nvim-lsp 提供的诊断信息
    diagnostics_indicator = function(count, level, diagnostics_dict, context)
      local icon = level:match("error") and " " or " "  -- 设置错误和警告的图标
      return icon .. count  -- 显示图标和数量
    end,
    custom_filter = function(bufnr)
      local buftype = vim.api.nvim_buf_get_option(bufnr, 'buftype')
      -- local ret = true
      -- if buftype == 'quickfix' then
      --   ret = false
      -- elseif buftype == '' then
      --   vim.cmd(':Startify')
      --   ret = false
      -- end
      -- return ret
      return buftype ~= 'quickfix'  -- 过滤掉 Quickfix 窗口
    end,
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
  ensure_installed = { "c", "lua", "python", "cpp" , "markdown", "vim", "sql", 'json', 'xml'} ,
  --ensure_installed = { "c", "lua", "python", "cpp" , "markdown", "vim", "sql", "yaml", 
  --"bash", "cmake", "json", "javascript", "java", "kotlin", "llvm", "make", "qmljs"},

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = true,

  -- Automatically install missing parsers when entering buffer
  auto_install = true,

  -- List of parsers to ignore installing (for "all")
  ignore_install = { "vimdoc" },

  highlight = {
    -- `false` will disable the whole extension
    enable = true,

    -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
    -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
    -- the name of the parser)
    -- list of language that will be disabled
    disable = { "vimdoc" },

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
-- 书签保存设置
------------------------------------------------------------------------------------------
--
vim.g.bookmark_save_per_working_dir = 1 -- 书签保存到工作目录
vim.g.bookmark_auto_save = 1  -- 自动保存书签


------------------------------------------------------------------------------------------
-- diffview 配置
------------------------------------------------------------------------------------------
-- Lua
local actions = require("diffview.actions")
require("diffview").setup({
  diff_binaries = false,    -- Show diffs for binaries
  enhanced_diff_hl = false, -- See ':h diffview-config-enhanced_diff_hl'
  git_cmd = { "git" },      -- The git executable followed by default args.
  hg_cmd = { "hg" },        -- The hg executable followed by default args.
  use_icons = true,         -- Requires nvim-web-devicons
  show_help_hints = true,   -- Show hints for how to open the help panel
  watch_index = true,       -- Update views and index buffers when the git index changes.
  icons = {                 -- Only applies when use_icons is true.
    folder_closed = "",
    folder_open = "",
  },
  signs = {
    fold_closed = "",
    fold_open = "",
    done = "✓",
  },
  view = {
    -- Configure the layout and behavior of different types of views.
    -- Available layouts:
    --  'diff1_plain'
    --    |'diff2_horizontal'
    --    |'diff2_vertical'
    --    |'diff3_horizontal'
    --    |'diff3_vertical'
    --    |'diff3_mixed'
    --    |'diff4_mixed'
    -- For more info, see ':h diffview-config-view.x.layout'.
    default = {
      -- Config for changed files, and staged files in diff views.
      layout = "diff2_horizontal",
      winbar_info = false,          -- See ':h diffview-config-view.x.winbar_info'
    },
    merge_tool = {
      -- Config for conflicted files in diff views during a merge or rebase.
      layout = "diff3_horizontal",
      disable_diagnostics = true,   -- Temporarily disable diagnostics for conflict buffers while in the view.
      winbar_info = true,           -- See ':h diffview-config-view.x.winbar_info'
    },
    file_history = {
      -- Config for changed files in file history views.
      layout = "diff2_horizontal",
      winbar_info = false,          -- See ':h diffview-config-view.x.winbar_info'
    },
  },
  file_panel = {
    listing_style = "tree",             -- One of 'list' or 'tree'
    tree_options = {                    -- Only applies when listing_style is 'tree'
      flatten_dirs = true,              -- Flatten dirs that only contain one single dir
      folder_statuses = "only_folded",  -- One of 'never', 'only_folded' or 'always'.
    },
    win_config = {                      -- See ':h diffview-config-win_config'
      position = "left",
      width = 35,
      win_opts = {}
    },
  },
  file_history_panel = {
    log_options = {   -- See ':h diffview-config-log_options'
      git = {
        single_file = {
          diff_merges = "combined",
        },
        multi_file = {
          diff_merges = "first-parent",
        },
      },
      hg = {
        single_file = {},
        multi_file = {},
      },
    },
    win_config = {    -- See ':h diffview-config-win_config'
      position = "bottom",
      height = 16,
      win_opts = {}
    },
  },
  commit_log_panel = {
    win_config = {   -- See ':h diffview-config-win_config'
      win_opts = {},
    }
  },
  default_args = {    -- Default args prepended to the arg-list for the listed commands
    DiffviewOpen = {},
    DiffviewFileHistory = {},
  },
  hooks = {},         -- See ':h diffview-config-hooks'
  keymaps = {
    disable_defaults = false, -- Disable the default keymaps
    view = {
      -- The `view` bindings are active in the diff buffers, only when the current
      -- tabpage is a Diffview.
      { "n", "<tab>",       actions.select_next_entry,              { desc = "Open the diff for the next file" } },
      { "n", "<s-tab>",     actions.select_prev_entry,              { desc = "Open the diff for the previous file" } },
      { "n", "gf",          actions.goto_file_edit,                 { desc = "Open the file in the previous tabpage" } },
      { "n", "<C-w><C-f>",  actions.goto_file_split,                { desc = "Open the file in a new split" } },
      { "n", "<C-w>gf",     actions.goto_file_tab,                  { desc = "Open the file in a new tabpage" } },
      { "n", "<leader>e",   actions.focus_files,                    { desc = "Bring focus to the file panel" } },
      { "n", "<leader>b",   actions.toggle_files,                   { desc = "Toggle the file panel." } },
      { "n", "g<C-x>",      actions.cycle_layout,                   { desc = "Cycle through available layouts." } },
      { "n", "[x",          actions.prev_conflict,                  { desc = "In the merge-tool: jump to the previous conflict" } },
      { "n", "]x",          actions.next_conflict,                  { desc = "In the merge-tool: jump to the next conflict" } },
      { "n", "<leader>co",  actions.conflict_choose("ours"),        { desc = "Choose the OURS version of a conflict" } },
      { "n", "<leader>ct",  actions.conflict_choose("theirs"),      { desc = "Choose the THEIRS version of a conflict" } },
      { "n", "<leader>cb",  actions.conflict_choose("base"),        { desc = "Choose the BASE version of a conflict" } },
      { "n", "<leader>ca",  actions.conflict_choose("all"),         { desc = "Choose all the versions of a conflict" } },
      { "n", "dx",          actions.conflict_choose("none"),        { desc = "Delete the conflict region" } },
      { "n", "<leader>cO",  actions.conflict_choose_all("ours"),    { desc = "Choose the OURS version of a conflict for the whole file" } },
      { "n", "<leader>cT",  actions.conflict_choose_all("theirs"),  { desc = "Choose the THEIRS version of a conflict for the whole file" } },
      { "n", "<leader>cB",  actions.conflict_choose_all("base"),    { desc = "Choose the BASE version of a conflict for the whole file" } },
      { "n", "<leader>cA",  actions.conflict_choose_all("all"),     { desc = "Choose all the versions of a conflict for the whole file" } },
      { "n", "dX",          actions.conflict_choose_all("none"),    { desc = "Delete the conflict region for the whole file" } },
    },
    diff1 = {
      -- Mappings in single window diff layouts
      { "n", "g?", actions.help({ "view", "diff1" }), { desc = "Open the help panel" } },
    },
    diff2 = {
      -- Mappings in 2-way diff layouts
      { "n", "g?", actions.help({ "view", "diff2" }), { desc = "Open the help panel" } },
    },
    diff3 = {
      -- Mappings in 3-way diff layouts
      { { "n", "x" }, "2do",  actions.diffget("ours"),            { desc = "Obtain the diff hunk from the OURS version of the file" } },
      { { "n", "x" }, "3do",  actions.diffget("theirs"),          { desc = "Obtain the diff hunk from the THEIRS version of the file" } },
      { "n",          "g?",   actions.help({ "view", "diff3" }),  { desc = "Open the help panel" } },
    },
    diff4 = {
      -- Mappings in 4-way diff layouts
      { { "n", "x" }, "1do",  actions.diffget("base"),            { desc = "Obtain the diff hunk from the BASE version of the file" } },
      { { "n", "x" }, "2do",  actions.diffget("ours"),            { desc = "Obtain the diff hunk from the OURS version of the file" } },
      { { "n", "x" }, "3do",  actions.diffget("theirs"),          { desc = "Obtain the diff hunk from the THEIRS version of the file" } },
      { "n",          "g?",   actions.help({ "view", "diff4" }),  { desc = "Open the help panel" } },
    },
    file_panel = {
      { "n", "j",              actions.next_entry,                     { desc = "Bring the cursor to the next file entry" } },
      { "n", "<down>",         actions.next_entry,                     { desc = "Bring the cursor to the next file entry" } },
      { "n", "k",              actions.prev_entry,                     { desc = "Bring the cursor to the previous file entry" } },
      { "n", "<up>",           actions.prev_entry,                     { desc = "Bring the cursor to the previous file entry" } },
      { "n", "<cr>",           actions.select_entry,                   { desc = "Open the diff for the selected entry" } },
      { "n", "o",              actions.select_entry,                   { desc = "Open the diff for the selected entry" } },
      { "n", "l",              actions.select_entry,                   { desc = "Open the diff for the selected entry" } },
      { "n", "<2-LeftMouse>",  actions.select_entry,                   { desc = "Open the diff for the selected entry" } },
      { "n", "-",              actions.toggle_stage_entry,             { desc = "Stage / unstage the selected entry" } },
      { "n", "s",              actions.toggle_stage_entry,             { desc = "Stage / unstage the selected entry" } },
      { "n", "S",              actions.stage_all,                      { desc = "Stage all entries" } },
      { "n", "U",              actions.unstage_all,                    { desc = "Unstage all entries" } },
      { "n", "X",              actions.restore_entry,                  { desc = "Restore entry to the state on the left side" } },
      { "n", "L",              actions.open_commit_log,                { desc = "Open the commit log panel" } },
      { "n", "zo",             actions.open_fold,                      { desc = "Expand fold" } },
      { "n", "h",              actions.close_fold,                     { desc = "Collapse fold" } },
      { "n", "zc",             actions.close_fold,                     { desc = "Collapse fold" } },
      { "n", "za",             actions.toggle_fold,                    { desc = "Toggle fold" } },
      { "n", "zR",             actions.open_all_folds,                 { desc = "Expand all folds" } },
      { "n", "zM",             actions.close_all_folds,                { desc = "Collapse all folds" } },
      { "n", "<c-b>",          actions.scroll_view(-0.25),             { desc = "Scroll the view up" } },
      { "n", "<c-f>",          actions.scroll_view(0.25),              { desc = "Scroll the view down" } },
      { "n", "<tab>",          actions.select_next_entry,              { desc = "Open the diff for the next file" } },
      { "n", "<s-tab>",        actions.select_prev_entry,              { desc = "Open the diff for the previous file" } },
      { "n", "gf",             actions.goto_file_edit,                 { desc = "Open the file in the previous tabpage" } },
      { "n", "<C-w><C-f>",     actions.goto_file_split,                { desc = "Open the file in a new split" } },
      { "n", "<C-w>gf",        actions.goto_file_tab,                  { desc = "Open the file in a new tabpage" } },
      { "n", "i",              actions.listing_style,                  { desc = "Toggle between 'list' and 'tree' views" } },
      { "n", "f",              actions.toggle_flatten_dirs,            { desc = "Flatten empty subdirectories in tree listing style" } },
      { "n", "R",              actions.refresh_files,                  { desc = "Update stats and entries in the file list" } },
      { "n", "<leader>e",      actions.focus_files,                    { desc = "Bring focus to the file panel" } },
      { "n", "<leader>b",      actions.toggle_files,                   { desc = "Toggle the file panel" } },
      { "n", "g<C-x>",         actions.cycle_layout,                   { desc = "Cycle available layouts" } },
      { "n", "[x",             actions.prev_conflict,                  { desc = "Go to the previous conflict" } },
      { "n", "]x",             actions.next_conflict,                  { desc = "Go to the next conflict" } },
      { "n", "g?",             actions.help("file_panel"),             { desc = "Open the help panel" } },
      { "n", "<leader>cO",     actions.conflict_choose_all("ours"),    { desc = "Choose the OURS version of a conflict for the whole file" } },
      { "n", "<leader>cT",     actions.conflict_choose_all("theirs"),  { desc = "Choose the THEIRS version of a conflict for the whole file" } },
      { "n", "<leader>cB",     actions.conflict_choose_all("base"),    { desc = "Choose the BASE version of a conflict for the whole file" } },
      { "n", "<leader>cA",     actions.conflict_choose_all("all"),     { desc = "Choose all the versions of a conflict for the whole file" } },
      { "n", "dX",             actions.conflict_choose_all("none"),    { desc = "Delete the conflict region for the whole file" } },
    },
    file_history_panel = {
      { "n", "g!",            actions.options,                     { desc = "Open the option panel" } },
      { "n", "<C-A-d>",       actions.open_in_diffview,            { desc = "Open the entry under the cursor in a diffview" } },
      { "n", "y",             actions.copy_hash,                   { desc = "Copy the commit hash of the entry under the cursor" } },
      { "n", "L",             actions.open_commit_log,             { desc = "Show commit details" } },
      { "n", "zR",            actions.open_all_folds,              { desc = "Expand all folds" } },
      { "n", "zM",            actions.close_all_folds,             { desc = "Collapse all folds" } },
      { "n", "j",             actions.next_entry,                  { desc = "Bring the cursor to the next file entry" } },
      { "n", "<down>",        actions.next_entry,                  { desc = "Bring the cursor to the next file entry" } },
      { "n", "k",             actions.prev_entry,                  { desc = "Bring the cursor to the previous file entry." } },
      { "n", "<up>",          actions.prev_entry,                  { desc = "Bring the cursor to the previous file entry." } },
      { "n", "<cr>",          actions.select_entry,                { desc = "Open the diff for the selected entry." } },
      { "n", "o",             actions.select_entry,                { desc = "Open the diff for the selected entry." } },
      { "n", "<2-LeftMouse>", actions.select_entry,                { desc = "Open the diff for the selected entry." } },
      { "n", "<c-b>",         actions.scroll_view(-0.25),          { desc = "Scroll the view up" } },
      { "n", "<c-f>",         actions.scroll_view(0.25),           { desc = "Scroll the view down" } },
      { "n", "<tab>",         actions.select_next_entry,           { desc = "Open the diff for the next file" } },
      { "n", "<s-tab>",       actions.select_prev_entry,           { desc = "Open the diff for the previous file" } },
      { "n", "gf",            actions.goto_file_edit,              { desc = "Open the file in the previous tabpage" } },
      { "n", "<C-w><C-f>",    actions.goto_file_split,             { desc = "Open the file in a new split" } },
      { "n", "<C-w>gf",       actions.goto_file_tab,               { desc = "Open the file in a new tabpage" } },
      { "n", "<leader>e",     actions.focus_files,                 { desc = "Bring focus to the file panel" } },
      { "n", "<leader>b",     actions.toggle_files,                { desc = "Toggle the file panel" } },
      { "n", "g<C-x>",        actions.cycle_layout,                { desc = "Cycle available layouts" } },
      { "n", "g?",            actions.help("file_history_panel"),  { desc = "Open the help panel" } },
    },
    option_panel = {
      { "n", "<tab>", actions.select_entry,          { desc = "Change the current option" } },
      { "n", "q",     actions.close,                 { desc = "Close the panel" } },
      { "n", "g?",    actions.help("option_panel"),  { desc = "Open the help panel" } },
    },
    help_panel = {
      { "n", "q",     actions.close,  { desc = "Close help menu" } },
      { "n", "<esc>", actions.close,  { desc = "Close help menu" } },
    },
  },
})

------------------------------------------------------------------------------------------
-- indent-blankline 配置
------------------------------------------------------------------------------------------
-- require("ibl").setup({
--     debounce = 10,
--     indent = { char = "¦" },
--     whitespace = { highlight = { "Whitespace", "NonText" }, remove_blankline_trail=false },
--     scope = { exclude = { language = { "dashboard" } }, show_start=false, show_end=false, show_exact_scope=true },
-- })


------------------------------------------------------------------------------------------
-- 注释插件 Comment 配置
------------------------------------------------------------------------------------------
require('Comment').setup({
        ---Add a space b/w comment and the line
    padding = true,
    ---Whether the cursor should stay at its position
    sticky = true,
    ---Lines to be ignored while (un)comment
    ignore = '^$',
    ---LHS of toggle mappings in NORMAL mode
    toggler = {
        ---Line-comment toggle keymap
        line = '<leader>cc',
        ---Block-comment toggle keymap
        block = '<leader>cb',
    },
    ---LHS of operator-pending mappings in NORMAL and VISUAL mode
    opleader = {
        ---Line-comment keymap
        line = '<leader>cc',
        ---Block-comment keymap
        block = '<leadercb>',
    },
    ---LHS of extra mappings
    extra = {
        ---Add comment on the line above
        above = '<leader>cO',
        ---Add comment on the line below
        below = '<leader>gco',
        ---Add comment at the end of line
        eol = '<Nop>',
    },
    ---Enable keybindings
    ---NOTE: If given `false` then the plugin won't create any mappings
    mappings = {
        ---Operator-pending mapping; `gcc` `gbc` `gc[count]{motion}` `gb[count]{motion}`
        basic = true,
        ---Extra mapping; `gco`, `gcO`, `gcA`
        extra = true,
    },
    ---Function to call before (un)comment
    pre_hook = nil,
    ---Function to call after (un)comment
    post_hook = nil,

  })

-----------------------------------------------------------------------------------------
-- LSP 配置
------------------------------------------------------------------------------------------
local lspconfig = require('lspconfig')

function switch_file_and_search()
  -- 获取当前文件名
  local current_file = vim.fn.expand('%:t:r')  -- 获取文件名（不带路径和扩展名）
  local file_extension = vim.fn.expand('%:e')  -- 获取文件扩展名
  local filename

  -- 根据扩展名修改文件名
  if file_extension == 'c' or file_extension == 'cpp' or file_extension == 'cxx' then
    filename = current_file .. '.h'  -- 修改为头文件
  elseif file_extension == 'h' or file_extension == 'hpp' then
    filename = current_file .. '.c'  -- 修改为源文件
  else
    print('Not a C/C++ file')
    return
  end

  -- 拼接 LeaderfFilePattern 命令
  -- local command = ':LeaderfFilePattern ' .. filename
  local command = string.format('lua require("telescope.builtin").find_files({ cwd = vim.g.workspace_dir.get(), default_text="%s" })', filename)
  vim.cmd(command)
end

-- C++ 配置 (clangd)
lspconfig.clangd.setup({
  cmd = { "clangd", "--background-index", "--clang-tidy" },
  cmd = { "clangd", "--compile-commands-dir=build" }, -- 指定 compile_commands.json 所在目录
  filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto", "hpp", "cxx" },
  on_attach = function(client, bufnr)
    local opts = { noremap=true, silent=true }
    local keymap = vim.api.nvim_buf_set_keymap
    -- keymap(bufnr, 'n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
    vim.keymap.set('n', 'gd', '<cmd>Telescope lsp_definitions<cr>', { desc = 'Find definitions' })
    -- keymap(bufnr, 'n', 'gi', '<Cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    vim.keymap.set('n', 'gi', '<cmd>Telescope lsp_implementations<cr>', { desc = 'Find implementations' })
    -- keymap(bufnr, 'n', 'gr', '<Cmd>lua vim.lsp.buf.references()<CR>', opts)
    vim.keymap.set('n', 'gr', '<cmd>Telescope lsp_references<cr>', { desc = 'Find references' })
    vim.keymap.set('n', 'gl', '<cmd>Telescope lsp_document_symbols<cr>', { desc = 'Find references' })
    vim.keymap.set('n', 'ga', '<cmd>Telescope lsp_dynamic_workspace_symbols<cr>', { desc = 'Find references' })
    vim.keymap.set('n', '<C-t>', '<cmd>Telescope lsp_workspace_symbols<cr>', { desc = 'Find workspace symbols' })
    keymap(bufnr, 'n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
    keymap(bufnr, 'n', '<leader>rn', '<Cmd>lua vim.lsp.buf.rename()<CR>', opts)
    keymap(bufnr, 'n', '<leader>ff', '<Cmd>lua vim.lsp.buf.format()<CR>', opts)
    keymap(bufnr, 'n', '<leader>fx', '<Cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    keymap(bufnr, 'n', '<leader>wf', '<cmd>lua for _, folder in ipairs(vim.lsp.buf.list_workspace_folders()) do print(folder) end<CR>', opts)
    keymap(bufnr, 'n', '<leader>hs', '<cmd>lua switch_file_and_search()<CR>', opts)
  end,
})


------------------------------------------------------------------------------------------
-- Python 配置 (pyright) 
------------------------------------------------------------------------------------------
lspconfig.pyright.setup({
  on_attach = function(client, bufnr)
    local opts = { noremap=true, silent=true }
    local keymap = vim.api.nvim_buf_set_keymap
    keymap(bufnr, 'n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
    keymap(bufnr, 'n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
    keymap(bufnr, 'n', '<leader>rn', '<Cmd>lua vim.lsp.buf.rename()<CR>', opts)
    keymap(bufnr, 'n', '<leader>ff', '<Cmd>lua vim.lsp.buf.formatting()<CR>', opts)
    keymap(bufnr, 'n', '<leader>fx', '<Cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  end,
  settings = {
    python = {
      analysis = {
        typeCheckingMode = "default",
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
      },
    },
  },
})

-- 自定义诊断符号
vim.diagnostic.config({
  signs = true,
  virtual_text = {
    prefix = "■",
    source = "always",
    format = function(diagnostic)
      local icons = {
        -- [vim.diagnostic.severity.ERROR] = "❌",
        -- [vim.diagnostic.severity.WARN]  = "⚠️",
        -- [vim.diagnostic.severity.INFO]  = "ℹ️",
        -- [vim.diagnostic.severity.HINT]  = "💡",

        [vim.diagnostic.severity.ERROR] = "E",
        [vim.diagnostic.severity.WARN]  = "W",
        [vim.diagnostic.severity.INFO]  = "S",
        [vim.diagnostic.severity.HINT]  = "F",
      }
      return icons[diagnostic.severity] .. " " .. diagnostic.message
    end,
  },
  update_in_insert = false,
  severity_sort = true,
  float = {
    source = "always",
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "E",
      [vim.diagnostic.severity.WARN]  = "W",
      [vim.diagnostic.severity.INFO]  = "S",
      [vim.diagnostic.severity.HINT]  = "F",
      -- [vim.diagnostic.severity.ERROR] = "❌",
      -- [vim.diagnostic.severity.WARN]  = "⚠️",
      -- [vim.diagnostic.severity.INFO]  = "ℹ️",
      -- [vim.diagnostic.severity.HINT]  = "💡",
    },
  },
})
------------------------------------------------------------------------------------------
-- 补全配置 
------------------------------------------------------------------------------------------
local cmp = require'cmp'
cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body) -- 使用 LuaSnip 作为代码片段引擎
    end,
  },
  mapping = {
    ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }), -- 向下选择
    ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }), -- 向上选择
    ['<Tab>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }), -- 向上选择
    ['<C-e>'] = cmp.mapping.confirm({ select = true }), -- 使用 Tab 键确认补全
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' }, -- 从 LSP 获取补全项
    { name = 'luasnip' },  -- 支持代码片段
  }, {
    { name = 'buffer' }, -- 从当前缓冲区获取补全项
  }),
  -- 模仿 VS2022，自动弹出补全列表
  completion = {
    -- autocomplete = { require('cmp.types').cmp.TriggerEvent.InsertEnter, require('cmp.types').cmp.TriggerEvent.TextChanged },
  },
  experimental = {
    -- ghost_text = true, -- 开启 "智能感知" 模式，模仿 VS2022 的即时提示
  },
})

------------------------------------------------------------------------------------------
-- nvim-tree 配置 
------------------------------------------------------------------------------------------
require("nvim-tree").setup({
  -- 禁用 netrw（Neovim 的默认文件浏览器）
  disable_netrw = true,
  hijack_netrw = true,
  sort = {
    sorter = "case_sensitive",
  },
  filters = {
    dotfiles = true,
  },
    -- 文件图标
  renderer = {
    icons = {
      glyphs = {
        default = '',  -- 默认文件图标
        symlink = '',  -- 符号链接图标
        git = {
          unstaged = '',  -- 未暂存的更改
          staged = '✓',    -- 已暂存的更改
          unmerged = '',  -- 未合并的更改
          renamed = '➜',   -- 重命名的文件
          untracked = '', -- 未跟踪的文件
          deleted = '',   -- 已删除的文件
          ignored = '◌',   -- 忽略的文件
        },
      },
    },
  },
    -- 文件操作
  actions = {
    open_file = {
      quit_on_open = false,  -- 打开文件后不退出文件树
    },
  },

  -- Git 状态
  git = {
    enable = true,  -- 启用 Git 状态显示
    ignore = false, -- 不忽略 Git 未跟踪的文件
    timeout = 400,  -- Git 状态更新的延迟时间（毫秒）
  },
    -- 视图设置
  view = {
    width = 36,
    side = 'right',
  --   mappings = {
  --     custom_only = false,  -- 是否只使用自定义映射
  --     list = {
  --       -- 自定义键位映射
  --       { key = '<CR>', action = 'edit' },
  --       { key = 'o', action = 'edit' },
  --       { key = 'a', action = 'create' },
  --       { key = 'd', action = 'remove' },
  --       { key = 'r', action = 'rename' },
  --       { key = 'x', action = 'cut' },
  --       { key = 'c', action = 'copy' },
  --       { key = 'p', action = 'paste' },
  --       { key = 'y', action = 'copy_name' },
  --       { key = 'gy', action = 'copy_path' },
  --       { key = 'I', action = 'toggle_ignored' },
  --       { key = 'H', action = 'toggle_dotfiles' },
  --       { key = 'R', action = 'refresh' },
  --       { key = 'q', action = 'close' },
  --     },
  --   },
  },
})


------------------------------------------------------------------------------------------
-- gitsigns 配置 
------------------------------------------------------------------------------------------
require('gitsigns').setup({
  signs = {
    add          = { text = '+' }, -- 新增
    change       = { text = '~' }, -- 修改
    delete       = { text = 'x' }, -- 删除
    topdelete    = { text = '^' }, -- 顶部删除
    changedelete = { text = '!' }, -- 修改并删除
    untracked    = { text = '?' }, -- 未跟踪

    -- add          = { text = '🆕' }, -- 新增
    -- change       = { text = '📝' }, -- 修改
    -- delete       = { text = '🗑️' }, -- 删除
    -- topdelete    = { text = '🔥' }, -- 顶部删除
    -- changedelete = { text = '💥' }, -- 修改并删除
    -- untracked    = { text = '❓' }, -- 未跟踪
  },
  signcolumn = true, -- 始终显示 Git 状态列
  numhl      = false, -- 不启用行号高亮
  linehl     = false, -- 不启用行高亮
  word_diff  = false, -- 不启用单词差异高亮
  watch_gitdir = {
    interval = 1000, -- 检查 Git 状态的时间间隔（毫秒）
    follow_files = true,
  },
  attach_to_untracked = true, -- 显示未跟踪文件的状态
  current_line_blame = false, -- 不启用当前行的 Git  blame
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = 'eol', -- blame 信息显示在行尾
    delay = 1000, -- blame 信息显示的延迟时间（毫秒）
    ignore_whitespace = false,
  },
  -- sign_priority = 6, -- Git 状态符号的优先级
  update_debounce = 100, -- 更新防抖时间（毫秒）
  status_formatter = nil, -- 使用默认的状态格式化函数
  max_file_length = 40000, -- 最大文件长度（行数）
  preview_config = {
    border = 'single', -- 预览窗口的边框样式
    style = 'minimal', -- 预览窗口的样式
    relative = 'cursor', -- 预览窗口相对于光标的位置
    row = 0, -- 预览窗口的行偏移
    col = 1, -- 预览窗口的列偏移
  },
})

------------------------------------------------------------------------------------------
-- tagbar 配置 
------------------------------------------------------------------------------------------
vim.g.tagbar_width = 40          -- 设置 Tagbar 宽度
vim.g.tagbar_position = 'left'   -- 将 Tagbar 放置在左侧
vim.g.tagbar_autofocus = 1       -- 打开 Tagbar 时自动聚焦
vim.g.tagbar_autoclose = 0       -- 跳转到标签后自动关闭 Tagbar
vim.g.tagbar_sort = 1            -- 按代码中的位置排序（0 表示禁用按名称排序）

-- 针对 C++ 的配置
vim.g.tagbar_type_cpp = {
  ctagstype = 'c++',
  kinds = {
    'd:macros:1:0',
    'p:prototypes:1:0',
    'g:enums',
    'e:enumerators:0:0',
    't:typedefs:0:0',
    'n:namespaces',
    'c:classes',
    's:structs',
    'u:unions',
    'f:functions',
    'm:members:0:0',
    'v:variables:0:0'
  },
  sro = '::',
  kind2scope = {
    g = 'enum',
    n = 'namespace',
    c = 'class',
    s = 'struct',
    u = 'union'
  },
  scope2kind = {
    enum = 'g',
    namespace = 'n',
    class = 'c',
    struct = 's',
    union = 'u'
  }
}



------------------------------------------------------------------------------------------
-- null-ls 配置 
------------------------------------------------------------------------------------------
local null_ls = require('null-ls')

null_ls.setup({
  sources = {
    -- 添加你需要的格式化工具
    -- null_ls.builtins.formatting.prettier, -- JavaScript/TypeScript/CSS/HTML 格式化
    -- null_ls.builtins.formatting.black,    -- Python 格式化
    -- null_ls.builtins.formatting.stylua,   -- Lua 格式化
    -- null_ls.builtins.formatting.clang_format, -- C/C++ 格式化
    -- null_ls.builtins.formatting.gofmt,    -- Go 格式化
    null_ls.builtins.formatting.clang_format.with({
      -- 可选：指定 clang-format 的路径
      -- command = "clang-format",
      -- 可选：自定义 clang-format 的样式文件
      extra_args = { "-style", "file:" .. vim.fn.expand("~") .."/.config/nvim/.clang-format" }, -- 使用项目根目录下的 .clang-format 文件
      -- 可选：指定文件类型
      -- filetypes = { "cpp", "c" },
    }),
  },
})

------------------------------------------------------------------------------------------
-- cmake-tools.nvim 配置 
------------------------------------------------------------------------------------------
require('cmake-tools').setup({
  cmake_command = 'cmake', -- CMake 可执行文件路径
  ctest_command = 'ctest', -- CTest 可执行文件路径
  cmake_build_directory = 'build', -- 构建目录
  cmake_build_options = {}, -- 额外的构建选项
  cmake_soft_link_compile_commands = true, -- 软链接 compile_commands.json
  cmake_kits_global = {}, -- 全局编译器工具链配置
})

------------------------------------------------------------------------------------------
-- telescope 配置 
------------------------------------------------------------------------------------------
require('telescope').setup({
  defaults = {
    -- vimgrep_arguments = {
    --   "rg",  -- 使用 ripgrep
    --   "--color=never",
    --   "--no-heading",
    --   "--with-filename",
    --   "--line-number",
    --   "--column",
    --   "--smart-case",
    -- },
    layout_strategy = "horizontal",  -- 使用垂直布局
    sorting_strategy = "ascending",
    layout_config = {
      horizontal = {
        prompt_position = "top",     -- 搜索框在顶部
        height = 0.9,                -- 窗口高度
        width = 0.9,                 -- 窗口宽度
        preview_width = 0.6,         -- 预览窗口占整个窗口宽度的60%
        preview_cutoff = 120,        -- 预览窗口的截断宽度
        preview_height = 0.6,      -- 预览窗口占整个窗口高度的60%
      },
    },
    border = true,                 -- 启用边框
    borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },  -- 自定义边框字符
  },
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = "smart_case",
    },
    file_browser = {
      theme = "ivy",
      hijack_netrw = true,
    },
    live_grep_args = {
      auto_quoting = true,
      mappings = { -- extend mappings
        i = {
          ["<CR>"] = require("telescope.actions").select_default,
          ["<C-k>"] = require("telescope-live-grep-args.actions").quote_prompt(),
          ["<C-i>"] = require("telescope-live-grep-args.actions").quote_prompt({postfix = " -F -g *"}),
          ["<C-space>"] = require("telescope-live-grep-args.actions").to_fuzzy_refine,
          ["<Tab>"] = require("telescope.actions").move_selection_next,
          ["<S-Tab>"] = require("telescope.actions").move_selection_previous,
        },
      },
    },
  },
})

-- 加载插件
require('telescope').load_extension('fzf')
require('telescope').load_extension('file_browser')
require('telescope').load_extension('live_grep_args')
-- require('telescope').load_extension('gtags')
