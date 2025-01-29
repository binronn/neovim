-- 这部分帮助你在自动下载所需的packers.nvim文件
-- local fn = vim.fn
-- local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
-- if fn.empty(fn.glob(install_path)) > 0 then
--   packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
-- end

local programming_filetypes = {
	"c",
	"cpp",
	"java",
	"python",
	"javascript",
	"typescript",
	"lua",
	"rust",
	"go",
	"ruby",
	"php",
	"html",
	"css",
	"scss",
	"json",
	"yaml",
	"toml",
	"bash",
	"sh",
	"zsh",
	"fish",
	"vim",
	"markdown",
	"tex",
	"sql",
	"dockerfile",
	"make",
	"cmake",
	"perl",
	"r",
	"swift",
	"kotlin",
	"scala",
	"haskell",
	"ocaml",
	"elixir",
	"erlang",
	"clojure",
	"fsharp",
	"dart",
	"groovy",
	"puppet",
	"terraform",
	"proto",
	"thrift",
	"graphql",
	"vue",
	"svelte"
}

local pcfg = require("plugins_cfg")

return {
	{
		"andymass/vim-matchup" -- 高亮匹配
	},
	{
		"itchyny/vim-cursorword" -- 高亮光标下内容
	},
	-- {
	-- 	"yamatsum/nvim-cursorline", -- 高亮光标下内容和行
	-- 	config = function()
	-- 		require("nvim-cursorline").setup(
	-- 			{
	-- 				cursorline = {
	-- 					enable = false,
	-- 					timeout = 240,
	-- 					number = false
	-- 				},
	-- 				cursorword = {
	-- 					enable = true,
	-- 					min_length = 3,
	-- 					hl = {underline = true}
	-- 				}
	-- 			}
	-- 		)
	-- 	end
	-- },
	{
		"jiangmiao/auto-pairs" -- 自动括号
	},
	{},
	{
		"nvim-lualine/lualine.nvim", -- 状态栏
		dependencies = {"kyazdani42/nvim-web-devicons", opt = true},
		config = function()
			pcfg.lualine_init()
		end
	},
	{
		"kyazdani42/nvim-web-devicons" -- 图标支持
	},
	{
		"tpope/vim-sensible" -- 提供一些合理的默认设置
	},
	{
		"nvimdev/dashboard-nvim", -- 启动面板
		event = "VimEnter",
		config = function()
			pcfg.dashboard_init()
		end,
		dependencies = {"nvim-tree/nvim-web-devicons"}
	},
	{
		"stevearc/aerial.nvim", -- 类窗口
		config = function()
			pcfg.aerial_init()
		end
	},
	{
		"inkarkat/vim-mark", -- 高亮
		init = function()
			vim.g.mw_no_mappings = 1
			vim.g.mwDefaultHighlightingPalette = "maximum"
		end,
		config = function()
			vim.api.nvim_set_keymap("n", "<leader>mh", "<Plug>MarkSet", {noremap = true, silent = true})
			vim.api.nvim_set_keymap("n", "<leader>mH", "<Plug>MarkToggle", {noremap = true, silent = true})
			vim.api.nvim_set_keymap("n", "<leader>mr", "<Plug>MarkRegex", {noremap = true, silent = true})
			vim.api.nvim_set_keymap("x", "<leader>mr", "<Plug>MarkRegex", {noremap = true, silent = true})
			vim.api.nvim_set_keymap("n", "<leader>mn", "<Plug>MarkClear", {noremap = true, silent = true})
			vim.api.nvim_set_keymap("n", "<leader>mN", "<Plug>MarkAllClear", {noremap = true, silent = true})
		end
	},
	{
		"inkarkat/vim-ingo-library" -- 通用函数库
	},
	{
		"numToStr/Comment.nvim", -- 注释插件
		config = function()
			pcfg.Comment_init()
		end
	},
	{
		"MattesGroeger/vim-bookmarks", -- 书签
		init = function()
			vim.g.bookmark_no_default_key_mappings = 1 -- 关闭默认快捷键映射
			vim.g.bookmark_save_per_working_dir = 1 -- 书签保存到工作目录
			vim.g.bookmark_auto_save = 1 -- 自动保存书签
		end,
		config = function()
			vim.api.nvim_set_keymap("n", "mi", "<Plug>BookmarkAnnotate", {noremap = true, silent = true})
			vim.api.nvim_set_keymap("n", "mm", "<Plug>BookmarkToggle", {noremap = true, silent = true})
			vim.api.nvim_set_keymap("n", "ma", "<Plug>BookmarkShowAll", {noremap = true, silent = true})
			vim.api.nvim_set_keymap("n", "mp", "<Plug>BookmarkPrev", {noremap = true, silent = true})
			vim.api.nvim_set_keymap("n", "mn", "<Plug>BookmarkNext", {noremap = true, silent = true})
			vim.api.nvim_set_keymap("n", "mc", "<Plug>BookmarkClear", {noremap = true, silent = true})
			vim.api.nvim_set_keymap("n", "<leader>mx", "<Plug>BookmarkClearAll", {noremap = true, silent = true})
		end
	},
	{
		"skywind3000/asyncrun.vim", -- 异步执行命令插件
		config = function()
			vim.api.nvim_set_keymap("c", "Ar", "AsyncRun ", {noremap = true, silent = false})
			vim.api.nvim_set_keymap("c", "As", "AsyncStop", {noremap = true, silent = false})
		end
	},
	{
		'sainnhe/gruvbox-material',
		lazy = false,
		config = function()
			vim.schedule(function()vim.cmd("colorscheme gruvbox-material")end)
		end
	},
	{
		"lewis6991/gitsigns.nvim", -- 侧边栏显示 Git 状态
		after = 'gruvbox-material',
		config = function()
			pcfg.gitsigns_init()
		end
	},
	{
		"akinsho/bufferline.nvim", -- 缓冲区标签栏
		config = function()
			pcfg.bufferline_init()
		end
	},
	{
		"nvim-treesitter/nvim-treesitter", -- 语法高亮
		build = function()
			require("nvim-treesitter.install").update({with_sync = true})
		end,
		config = function()
			pcfg.nvim_treesitter_configs_init()
		end
	},
	{
		"numToStr/FTerm.nvim", -- 弹出式终端
		event = {'VeryLazy'},
		config = function()
			pcfg.FTerm_init()
		end
	},
	{
		"sindrets/diffview.nvim", -- GIT DIFF MERGE WINDOW
		event = {"BufRead"},
		config = function()
			pcfg.diffview_init()
		end
	},
	{
		"tpope/vim-fugitive", -- Git 插件 :G status<CR> :G ..<CR>
		event = {"BufRead"},
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		event = "BufRead",
		whitespace = { highlight = { "Whitespace", "NonText" } },
		config = function()
			require('ibl').setup({
				indent = {
					char = '╎',
					smart_indent_cap = true,
					priority = 1,
				},
				scope = {
					enabled = false,
				},
				exclude = {
					filetypes = {'dashboard', 'terminal', 'nofile', 'quickfix', 'prompt'},
				}

			})
		end
	},
	{
		"nvim-tree/nvim-tree.lua", -- 文件浏览器
		-- cmd = { "NvimTreeToggle", "NvimTreeFocus", "NvimTreeOpen" },
		config = function()
			pcfg.nvim_tree_init()
		end
	},
	-- LSP 和补全
	{
		"neovim/nvim-lspconfig", -- LSP 配置
		event = 'VeryLazy',
		dependencies = {
			"hrsh7th/nvim-cmp", -- LSP 补全引擎
			"hrsh7th/cmp-nvim-lsp", -- LSP 补全源
			"hrsh7th/cmp-buffer", -- 缓冲区补全源
			"hrsh7th/cmp-path", -- 文件路径补全
			"saadparwaiz1/cmp_luasnip",
			{
				"L3MON4D3/LuaSnip",
				config = function()
					vim.g.luasnip = require('luasnip')
					require('luasnip_cfg')
				end
			}, -- 代码片段引擎
            "jose-elias-alvarez/null-ls.nvim", -- 代码格式化插件
		},
		config = function()
			require("lsp_config")
            pcfg.null_ls_init()
		end,
		ft = programming_filetypes
	},
	-- 安装 Telescope 插件
	{
		"nvim-telescope/telescope.nvim",
		event = {'VeryLazy'},
		dependencies = {
			"nvim-lua/plenary.nvim",
            "nvim-telescope/telescope-file-browser.nvim", -- 文件浏览器
            "nvim-telescope/telescope-live-grep-args.nvim", -- 增强 live_grep
            "nvim-telescope/telescope-ui-select.nvim", -- 增强 UI 选择
			{
				"nvim-telescope/telescope-fzf-native.nvim", -- 提供更快的模糊查找
				build = "make" -- 需要编译
			},
		},
		config = function()
			pcfg.telescope_init()
		end
	},
	-- 调试插件
	{
		"mfussenegger/nvim-dap",
		event = {"VeryLazy"},
		ft = {"h", "hpp", "cpp", "cxx"},
		dependencies = {
			"nvim-neotest/nvim-nio",
			"rcarriga/nvim-dap-ui",
			"theHamsta/nvim-dap-virtual-text",
			"mfussenegger/nvim-dap-python",
			"nvim-telescope/telescope-dap.nvim"
		},
		config = function()
			require("dap_config")
		end
	},
	-- CMAKE 插件
	{
		"Civitasv/cmake-tools.nvim",
		ft = { "cmake", "cpp", "c" }, -- 指定需要延迟加载的文件类型
		dependencies = {
			"nvim-lua/plenary.nvim", -- 依赖插件
			"mfussenegger/nvim-dap" -- 调试支持
		},
		config = function()
			pcfg.cmake_tools_init()
		end
	},
	-- 会话保存与恢复
	{
		event = 'VeryLazy',
		"Shatur/neovim-session-manager",
		event = 'VeryLazy',
		dependencies = {"nvim-lua/plenary.nvim"},
		config = function()
			pcfg.session_manager_init()
		end
	},
	------------------------------------------
	----     avante AI                    ----
	------------------------------------------
	{
		"yetone/avante.nvim",
		-- event = {"BufRead", "BufNewFile"},
		event = {"VeryLazy"},
		ft = programming_filetypes,
		config = function()
			require("avante_cfg")
			vim.api.nvim_set_keymap("n", "<leader>aa", ':AvanteToggle<CR>', {noremap = true, silent = true})
		end,
		build = vim.g.is_unix == 1 and "make" or nil, -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
		-- run = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
		dependencies = {
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
				"MeanderingProgrammer/render-markdown.nvim",
				config = function()
					require("render-markdown").setup(
						{
							file_types = {"markdown", "Avante"}
						}
					)
				end,
				ft = {"markdown", "Avante"}
			}
		}
	}
	------------------------------------------
	----     avante AI END                ----
	------------------------------------------
	-- install = { colorscheme = { "default" } },
}
