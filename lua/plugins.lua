-- 这部分帮助你在自动下载所需的packers.nvim文件
-- local fn = vim.fn
-- local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
-- if fn.empty(fn.glob(install_path)) > 0 then
--   packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
-- end

local keymap = require("keymap_help")
local map = keymap.map
local nmap = keymap.nmap
local vmap = keymap.vmap
local xmap = keymap.xmap
local cmap = keymap.cmap
local imap = keymap.imap
local imap2 = keymap.imap2
local nmap2 = keymap.nmap2
local vmap2 = keymap.vmap2

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

local pcfg = require("config/plugins_cfg")
local ai_provider = "codecomp" -- "avante"

return {
	-- {
	-- 	"andymass/vim-matchup", -- 高亮匹配
	-- 	lazy = true,
	-- },
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
	-- {
	-- 	"navarasu/onedark.nvim",
	-- 	config = function()
	-- 		-- 在这里添加任何你需要的初始化代码，例如设置主题：
	-- 		-- vim.cmd.colorscheme("onedark")
	-- 	end,
	-- },
	-- {
	-- 	"dracula/vim",
	-- 	name = "dracula", -- 如果你想明确指定插件名称，可以保留这一行；如果不需要改变名称，则可以省略。
	-- 	config = function()
	-- 		-- 在这里添加任何你需要的初始化代码，例如设置主题：
	-- 		-- vim.cmd.colorscheme("dracula")
	-- 		-- vim.g.colorscheme_bg = "dark"
	-- 		-- vim.cmd('highlight Normal ctermfg=DarkGray guifg=#BEBEBE')
	-- 	end,
	-- },
	{
		"LunarVim/bigfile.nvim",
		config = pcfg.bigfile_init
	},
	{
		"jiangmiao/auto-pairs", -- 自动括号
		event = {"BufRead"}
	},
	{
		"nvimdev/dashboard-nvim", -- 启动面板
		event = "VimEnter",
		config = pcfg.dashboard_init,
		dependencies = {"nvim-tree/nvim-web-devicons"}
	},
	{
		"nvim-lualine/lualine.nvim", -- 状态栏
		event = {"BufEnter", "BufRead"},
		dependencies = {
			{"kyazdani42/nvim-web-devicons", opt = true}
			-- {'AlexvZyl/nordic.nvim'}
		},
		config = pcfg.lualine_init
	},
	-- {
	-- 	"tpope/vim-sensible" -- 提供一些合理的默认设置
	-- },
	{
		"stevearc/aerial.nvim", -- 类窗口
		config = pcfg.aerial_init
	},
	{
		"inkarkat/vim-mark", -- 高亮
		event = {"VeryLazy"},
		dependencies = {
			"inkarkat/vim-ingo-library" -- 通用函数库
		},
		init = function()
			vim.g.marks_save_file = "~/.vim_marks"
			vim.g.mw_no_mappings = 1
			vim.g.mwDefaultHighlightingPalette = "maximum"
		end,
		config = function()
			nmap("<leader>mh", "<Plug>MarkSet", {noremap = true, silent = true})
			nmap("<leader>mH", "<Plug>MarkToggle", {noremap = true, silent = true})
			nmap("<leader>mr", "<Plug>MarkRegex", {noremap = true, silent = true})
			xmap("<leader>mr", "<Plug>MarkRegex", {noremap = true, silent = true})
			nmap("<leader>mn", "<Plug>MarkClear", {noremap = true, silent = true})
			nmap("<leader>mN", "<Plug>MarkAllClear", {noremap = true, silent = true})
		end
	},
	{
		"numToStr/Comment.nvim", -- 注释插件
		config = pcfg.Comment_init
	},
	{
		"MattesGroeger/vim-bookmarks", -- 书签
		init = function()
			vim.g.bookmark_no_default_key_mappings = 1 -- 关闭默认快捷键映射
			vim.g.bookmark_save_per_working_dir = 1 -- 书签保存到工作目录
			vim.g.bookmark_auto_save = 1 -- 自动保存书签
		end,
		config = function()
			nmap("mi", "<Plug>BookmarkAnnotate", {noremap = true, silent = true})
			nmap("mm", "<Plug>BookmarkToggle", {noremap = true, silent = true})
			nmap("ma", "<Plug>BookmarkShowAll", {noremap = true, silent = true})
			nmap("mp", "<Plug>BookmarkPrev", {noremap = true, silent = true})
			nmap("mn", "<Plug>BookmarkNext", {noremap = true, silent = true})
			nmap("mc", "<Plug>BookmarkClear", {noremap = true, silent = true})
			nmap("<leader>mx", "<Plug>BookmarkClearAll", {noremap = true, silent = true})
		end
	},
	{
		"skywind3000/asyncrun.vim", -- 异步执行命令插件
		lazy = true,
		event = {"VeryLazy"},
		config = function()
			vim.api.nvim_set_keymap("c", "Ar", "AsyncRun ", {noremap = true, silent = false})
			vim.api.nvim_set_keymap("c", "As", "AsyncStop", {noremap = true, silent = false})
		end
	},
	{
		"sainnhe/gruvbox-material",
		config = function()
			vim.cmd.colorscheme("gruvbox-material")

			-- 定义一个函数，用于设置自定义高亮
			local function set_custom_highlights()
				vim.cmd("highlight NvimTreeEndOfBuffer guibg=#282828") -- nvimtree 背景色
				vim.cmd("highlight NvimTreeNormal guibg=#282828") -- nvimtree 背景色
				vim.cmd("highlight NvimTreeCursorLine guibg=#32302f") -- nvimtree 高亮当前行

				vim.api.nvim_set_hl(0, "FloatBorder", {bg = "NONE"}) -- 浮动窗口边框透明
				vim.api.nvim_set_hl(0, "NormalFloat", {bg = "NONE"}) -- 浮动窗口背景透明

				vim.api.nvim_set_hl(0, "TelescopePreviewBorder", {fg = "#777777", bg = "NONE"})
				vim.api.nvim_set_hl(0, "TelescopeResultsBorder", {fg = "#777777", bg = "NONE"})
				vim.api.nvim_set_hl(0, "TelescopePromptTitle", {bg = "NONE", fg = "#e29c45", bold = true})
				vim.api.nvim_set_hl(0, "TelescopeResultsTitle", {bg = "NONE", fg = "#a88462", bold = true})
				vim.api.nvim_set_hl(0, "TelescopePreviewTitle", {bg = "NONE", fg = "#a88462", bold = true})
			end

			-- 初次加载时，应用自定义高亮设置
			set_custom_highlights()

			-- 创建自动命令，在切换到 gruvbox-material 主题时重新应用高亮
			vim.api.nvim_create_autocmd(
				"ColorScheme",
				{
					pattern = "gruvbox-material",
					callback = function()
						set_custom_highlights()
					end
				}
			)
		end
	},
	{
		"rcarriga/nvim-notify", -- 通知窗口
		lazy = false,
		config = pcfg.notify_init
	},
	{
		"AlexvZyl/nordic.nvim", -- 主题
		-- priority = 1000, -- 确保最先加载
		lazy = true,
		config = function()
			pcfg.nordic_init()
		end
	},
	{
		"lewis6991/gitsigns.nvim", -- 侧边栏显示 Git 状态
		event = {"BufRead"},
		config = pcfg.gitsigns_init
	},
	{
		"akinsho/bufferline.nvim", -- 缓冲区标签栏
		-- dependencies = {'AlexvZyl/nordic.nvim'}, -- 必须优先加载主题
		config = pcfg.bufferline_init
	},
	{
		"nvim-treesitter/nvim-treesitter", -- 语法高亮
		build = function()
			require("nvim-treesitter.install").update({with_sync = true})
		end,
		config = pcfg.nvim_treesitter_configs_init
	},
	{
		"numToStr/FTerm.nvim", -- 弹出式终端
		lazy = true,
		event = {"VeryLazy"},
		config = pcfg.FTerm_init
	},
	{
		"sindrets/diffview.nvim", -- GIT DIFF MERGE WINDOW
		lazy = true,
		event = {"VeryLazy"},
		config = pcfg.diffview_init
	},
	{
		"tpope/vim-fugitive", -- Git 插件 :G status<CR> :G ..<CR>
		lazy = true,
		event = {"BufRead"}
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		event = "BufRead",
		whitespace = {highlight = {"Whitespace", "NonText"}},
		config = function()
			local highlight = {
				"iblhl_default"
			}

			local hooks = require "ibl.hooks"
			-- create the highlight groups in the highlight setup hook, so they are reset
			-- every time the colorscheme changes
			hooks.register(
				hooks.type.HIGHLIGHT_SETUP,
				function()
					-- vim.api.nvim_set_hl(0, "iblhl_default", {fg = "#4f5756"})
					vim.api.nvim_set_hl(0, "iblhl_default", {fg = "#404040"})
				end
			)

			require("ibl").setup(
				{
					indent = {
						highlight = highlight,
						char = "╎",
						smart_indent_cap = true,
						priority = 1
					},
					scope = {
						enabled = false
					},
					exclude = {
						filetypes = {"dashboard", "terminal", "nofile", "quickfix", "prompt"}
					}
				}
			)
			vim.api.nvim_set_hl(0, "IblIndent", {fg = "white"})
		end
	},
	{
		"nvim-tree/nvim-tree.lua", -- 文件浏览器
		-- cmd = { "NvimTreeToggle", "NvimTreeFocus", "NvimTreeOpen" },
		config = pcfg.nvim_tree_init
	},
	-- LSP 和补全
	{
		"neovim/nvim-lspconfig", -- LSP 配置
		event = {"VeryLazy"},
		dependencies = {
			"hrsh7th/nvim-cmp", -- LSP 补全引擎
			"hrsh7th/cmp-nvim-lsp", -- LSP 补全源
			"hrsh7th/cmp-buffer", -- 缓冲区补全源
			"hrsh7th/cmp-path", -- 文件路径补全
			"saadparwaiz1/cmp_luasnip",
			{
				"L3MON4D3/LuaSnip",
				config = function()
					vim.g.luasnip = require("config/luasnip_cfg")
					require("config/luasnip_cfg")
				end
			}, -- 代码片段引擎
			"jose-elias-alvarez/null-ls.nvim" -- 代码格式化插件
		},
		config = function()
			require("config/lsp_cfg")
			pcfg.null_ls_init()
		end,
		ft = programming_filetypes
	},
	-- 安装 Telescope 插件
	{
		"nvim-telescope/telescope.nvim",
		lazy = true,
		event = {"VeryLazy"},
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope-file-browser.nvim", -- 文件浏览器
			"nvim-telescope/telescope-live-grep-args.nvim", -- 增强 live_grep
			"nvim-telescope/telescope-ui-select.nvim", -- 增强 UI 选择
			{
				"rcarriga/nvim-notify", -- 通知窗口
				config = pcfg.notify_init
			},
			{
				"nvim-telescope/telescope-fzf-native.nvim", -- 提供更快的模糊查找
				build = "make" -- 需要编译
			}
		},
		config = pcfg.telescope_init
	},
	-- 调试插件
	{
		"mfussenegger/nvim-dap",
		ft = {"h", "hpp", "cpp", "cxx"},
		dependencies = {
			"nvim-neotest/nvim-nio",
			"rcarriga/nvim-dap-ui",
			"theHamsta/nvim-dap-virtual-text",
			"mfussenegger/nvim-dap-python",
			"nvim-telescope/telescope-dap.nvim"
		},
		config = function()
			require("config/dap_cfg")
		end
	},
	-- CMAKE 插件
	{
		"Civitasv/cmake-tools.nvim",
		ft = {"cmake", "cpp", "c"}, -- 指定需要延迟加载的文件类型
		dependencies = {
			"nvim-lua/plenary.nvim", -- 依赖插件
			"mfussenegger/nvim-dap" -- 调试支持
		},
		config = pcfg.cmake_tools_init
	},
	-- 会话保存与恢复
	-- {
	-- 	"Shatur/neovim-session-manager",
	-- 	lazy = true,
	-- 	event = {"VeryLazy"},
	-- 	dependencies = {"nvim-lua/plenary.nvim"},
	-- 	config = pcfg.session_manager_init
	-- },
	{
		"stevearc/dressing.nvim",
		event = {"VeryLazy"},
		config = pcfg.dressing_init
	},
	{
		"MeanderingProgrammer/render-markdown.nvim",
		lazy = true,
		config = function()
			require("render-markdown").setup()
		end,
	},
	------------------------------------------
	----     codecompanion AI             ----
	------------------------------------------
	{
		"olimorris/codecompanion.nvim",
		enabled = ai_provider == "codecomp" and true or false,
		dependencies = {
			"nvim-lualine/lualine.nvim",
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			{
				"MeanderingProgrammer/render-markdown.nvim",
				config = function()
					if ai_provider == 'codecomp' then
						require("render-markdown").setup(
							{
								file_types = {"markdown", "codecompanion"}
							}
						)
					end
				end
			}
		},
		-- opt = require("config.codecomp_cfg").opts(),
		config = function()
			if ai_provider == 'codecomp' then
				local comp = require("config.codecomp_cfg"):new()
				comp:setup_codecomp()
				comp:init()
				nmap("<leader>ac", ":CodeCompanionActions<CR>")
				nmap("<leader>aa", ":CodeCompanionChat Toggle<CR>")
				vmap("<leader>aa", ":CodeCompanionChat<CR>")
				nmap2("<leader>as", ":CodeCompanionChat ")
				nmap2("<leader>ae", ":CodeCompanion ")
				vmap2("<leader>ae", ":CodeCompanion ")
			end
		end
	},
	------------------------------------------
	----     codecompanion AI             ----
	------------------------------------------
	---
	------------------------------------------
	----     avante AI                    ----
	------------------------------------------
	{
		"yetone/avante.nvim",
		-- event = {"BufRead", "BufNewFile"},
		-- event = {"VeryLazy"},
		lazy = false,
		enabled = ai_provider == "avante" and true or false,
		-- version = '*', -- 最新tag
		-- version = nil, -- 最新提交
		-- ft = programming_filetypes,
		config = function()

			if ai_provider == 'avante' then
				require("config/avante_cfg")
			end

			-- nmap(
			-- 	"<leader>aa",
			-- 	function()
			-- 		require("avante").toggle() -- Assuming the function is named toggle and exported by avante.nvim
			-- 	end,
			-- 	{noremap = true, silent = true}
			-- )
		end,
		build = vim.g.is_unix == 1 and "make" or nil, -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
		-- run = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"stevearc/dressing.nvim",
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			"hrsh7th/nvim-cmp",
			--- The below dependencies are optional,
			"nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
			-- "zbirenbaum/copilot.lua", -- for providers='copilot'
			-- {
			-- 	-- support for image pasting
			-- 	"HakonHarnes/img-clip.nvim",
			-- 	event = "VeryLazy",
			-- 	config = function()
			-- 		require("img-clip").setup(
			-- 			{
			-- 				-- recommended settings
			-- 				default = {
			-- 					embed_image_as_base64 = false,
			-- 					prompt_for_file_name = false,
			-- 					drag_and_drop = {
			-- 						insert_mode = true
			-- 					},
			-- 					-- required for Windows users
			-- 					use_absolute_path = true
			-- 				}
			-- 			}
			-- 		)
			-- 	end
			-- },
			{
				"MeanderingProgrammer/render-markdown.nvim",
				config = function()
					if ai_provider == 'avante' then
						require("render-markdown").setup(
							{
								file_types = {"markdown", "Avante"},
								highlight = {
									enabled = true,
									-- 设置高亮模式为始终启用
									always_enabled = true,
									-- 设置高亮组
									highlight_groups = {
										normal = "Normal",
										visual = "Visual",
										insert = "Insert",
										replace = "Replace",
										command = "Command"
									}
								}
							}
						)
					end
				end,
			}
		}
	}
	------------------------------------------
	----     avante AI END                ----
	------------------------------------------
	-- install = { colorscheme = { "default" } },
}
