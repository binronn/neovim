local M = require("lualine.component"):extend()

M.processing = false
M.spinner_index = 1

local spinner_symbols = {
	"⠋",
	"⠙",
	"⠹",
	"⠸",
	"⠼",
	"⠴",
	"⠦",
	"⠧",
	"⠇",
	"⠏"
}
local spinner_symbols_len = 10

-- Initializer
function M:init(options)
	M.super.init(self, options)

	local group = vim.api.nvim_create_augroup("CodeCompanionHooks", {})
	vim.api.nvim_create_autocmd(
		{"User"},
		{
			pattern = "CodeCompanionRequest*",
			group = group,
			callback = function(request)
				if request.match == "CodeCompanionRequestStarted" then
					self.processing = true
				elseif request.match == "CodeCompanionRequestFinished" then
					self.processing = false
				end
			end
		}
	)
end

-- Function that runs every time statusline is updated
function M:update_status()
	if self.processing then
		self.spinner_index = (self.spinner_index % spinner_symbols_len) + 1
		return spinner_symbols[self.spinner_index]
	else
		return nil
	end
end

function M:setup_codecomp()
	require('config.codecomp_nfy').setup()
	require("codecompanion").setup(
		{
			opts = {
				language = "Chinese"
			},
			adapters = {
				qwen = function()
					return require("codecompanion.adapters").extend(
						"openai_compatible",
						{
							name = "qwen",
							env = {
								url = "http://192.168.0.101:8000", 
								api_key = vim.fn.getenv("ORG"), 
								chat_url = "/v1/chat/completions",
							},
							schema = {
								model = {
									default = "qwen-max-2025-01-25",
								}
							}
						}
					)
				end,
				nvidia = function()
					return require("codecompanion.adapters").extend(
						"openai_compatible",
						{
							name = "nvidia",
							env = {
								url = "https://integrate.api.nvidia.com",
								chat_url = "/v1/chat/completions",
								api_key = vim.fn.getenv("GTX"),
							},
							schema = {
								model = {
									default = "deepseek-ai/deepseek-r1",
								}
							}
						}
					)
				end,
				sil_deepseek = function()
					return require("codecompanion.adapters").extend(
						"openai_compatible",
						{
							name = "sil_deepseek",
							env = {
								url = "https://api.siliconflow.cn",
								chat_url = "/v1/chat/completions",
								api_key = vim.fn.getenv("SILICONFLOW_DSK"),
							},
							schema = {
								model = {
									default = "deepseek-ai/DeepSeek-V3",
								}
							}
						}
					)
				end,
				deepseek = function()
					return require("codecompanion.adapters").extend(
						"openai_compatible",
						{
							name = "deepseek",
							env = {
								url = "https://api.deepseek.com",
								chat_url = "/v1/chat/completions",
								api_key = vim.fn.getenv("DSK"),
							},
							schema = {
								model = {
									default = "deepseek-chat",
								}
							}
						}
					)
				end,
				azure_deepseek = function()
					return require("codecompanion.adapters").extend(
						"openai_compatible",
						{
							name = "azure_deepseek",
							opts = {
								proxy = "socks5://127.0.0.1:10807",
							},
							env = {
								url = "https://DeepSeek-R1-jrybg.eastus2.models.ai.azure.com",
								-- chat_url = "/v1/chat/completions",
								api_key = vim.fn.getenv("AZURE_DSKR1"),
							},
							schema = {
								model = {
									default = 'deepseek-r1',
								}
							}
						}
					)
				end,
				luch_deepseek = function()
					return require("codecompanion.adapters").extend(
						"openai_compatible",
						{
							name = "luch_deepseek",
							env = {
								url = "https://cloud.luchentech.com",
								chat_url = "/api/maas/chat/completions",
								model = "deepseek-ai/DeepSeek-R1",
								api_key = vim.fn.getenv("LUCHENTECH_DSK"),
							}
						}
					)
				end
			},
			strategies = {
				chat = {
					roles = {
						---The header name for the LLM's messages
						---@type string|fun(adapter: CodeCompanion.Adapter): string
						llm = function(adapter)
							return adapter.name .. '/' .. adapter.schema.model.default
						end,

						---The header name for your messages
						---@type string
						user = "Byron",
					},
					-- intro_message = "Press ? for options",
					show_header_separator = false, -- Show header separators in the chat buffer? Set this to false if you're using an external markdown formatting plugin
					separator = "-─", -- The separator between the different messages in the chat buffer
					show_references = true, -- Show references (from slash commands and variables) in the chat buffer?
					show_settings = true, -- Show LLM settings at the top of the chat buffer?
					show_token_count = true, -- Show the token count for each response?
					start_in_insert_mode = true, -- Open the chat buffer in insert mode?
					adapter = "qwen",
					keymaps = {
						send = {
							modes = {n = "<Enter>", i = "<C-s>"}
						},
						close = {
							modes = {n = "<C-c>", i = "C-c"}
						}
						-- Add further custom keymaps here
					}
				},
				inline = {
					keymaps = {
						accept_change = {
							modes = {n = "ct"},
							description = "Choose target"
						},
						reject_change = {
							modes = {n = "co"},
							description = "Choose our"
						}
					},
					adapter = "qwen"
				}
			},
			display = {
				chat = {
					-- Change the default icons
					icons = {
						pinned_buffer = "",
						watched_buffer = "👀"
					},
					-- Alter the sizing of the debug window
					debug_window = {},
					-- Options to customize the UI of the chat buffer
					window = {
						title = 'CodeCompanion',
						layout = "float", -- float|vertical|horizontal|buffer
						position = nil, -- left|right|top|bottom (nil will default depending on vim.opt.plitright|vim.opt.splitbelow)
						border = "rounded",
						height = 0.6,
						width = 0.75,
						relative = "editor",
						style = "full", -- 使用最小化的样式
						opts = {
							number = false,
							relativenumber = false,
							breakindent = true,
							cursorcolumn = false,
							cursorline = false,
							foldcolumn = "0",
							linebreak = true,
							list = false,
							numberwidth = 1,
							signcolumn = "no",
							spell = false,
							wrap = true
						}
					},
					---Customize how tokens are displayed
					---@param tokens number
					---@param adapter CodeCompanion.Adapter
					---@return string
					token_count = function(tokens, adapter)
						return " (" .. tokens .. " tokens)"
					end
				},
				action_palette = {
					width = 95,
					height = 10,
					prompt = "Prompt ", -- Prompt used for interactive LLM calls
					provider = "default", -- default|telescope|mini_pick
					opts = {
						show_default_actions = true, -- Show the default actions in the action palette?
						show_default_prompt_library = true -- Show the default prompt library in the action palette?
					}
				},
				diff = {
					enabled = true,
					close_chat_at = 240, -- Close an open chat buffer if the total columns of your display are less than...
					layout = "vertical", -- vertical|horizontal split for default provider
					opts = {"internal", "filler", "closeoff", "algorithm:patience", "followwrap", "linematch:120"},
					provider = "default" -- default|mini_diff
				}
			}
		}
	)
end

return M
