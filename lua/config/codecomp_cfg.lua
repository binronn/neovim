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
	require("codecompanion").setup(
		{
			adapters = {
				deepseek = function()
					return require("codecompanion.adapters").extend(
						"openai_compatible",
						{
							env = {
								url = "https://api.siliconflow.cn", -- optional: default value is ollama url http://127.0.0.1:11434
								model = 'deepseek-ai/Deepseek-V3',
								api_key = vim.fn.getenv('SILICONFLOW'), -- optional: if your endpoint is authenticated
								-- api_key = "OpenAI_API_KEY", -- optional: if your endpoint is authenticated
								-- chat_url = "/v1/chat/completions" -- optional: default value, override if different
							}
						}
					)
				end
			},
			strategies = {
				chat = {
					intro_message = "Welcome to CodeCompanion ✨! Press ? for options",
					show_header_separator = true, -- Show header separators in the chat buffer? Set this to false if you're using an external markdown formatting plugin
					separator = "─", -- The separator between the different messages in the chat buffer
					show_references = true, -- Show references (from slash commands and variables) in the chat buffer?
					show_settings = true, -- Show LLM settings at the top of the chat buffer?
					show_token_count = true, -- Show the token count for each response?
					start_in_insert_mode = true, -- Open the chat buffer in insert mode?
					adapter = "deepseek",
					keymaps = {
						send = {
							modes = {n = "<Enter>", i = "<C-s>"}
						},
						close = {
							modes = {n = "<Esc>", i = "<C-c>"}
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
					adapter = "deepseek"
				}
			},
			display = {
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
