return require("avante").setup(
	{
		provider = "openai",
		auto_suggestions_provider = "openai", -- Since auto-suggestions are a high-frequency operation and therefore expensive, it is recommended to specify an inexpensive provider or even a free provider: copilot
		openai = {
			endpoint = "https://api.deepseek.com/v1",
			model = "deepseek-chat",
			timeout = 30000, -- Timeout in milliseconds
			temperature = 0,
			max_tokens = 4096
			-- api_key_name = 'OPENAI_KEY_NAME'
		},
		behaviour = {
			auto_suggestions = false, -- Experimental stage
			auto_set_highlight_group = true,
			auto_set_keymaps = true,
			auto_apply_diff_after_generation = false,
			support_paste_from_clipboard = false,
			minimize_diff = true -- Whether to remove unchanged lines when applying a code block
		},
		mappings = {
			ask = "<leader>aa",
			refresh = "<leader>ar"
		},
		windows = {
			wrap = true,
			width = 35
		},
		highlights = {
			---@type AvanteConflictHighlights
			diff = {
				current = "DiffText",
				incoming = "DiffAdd"
			}
		},
		--- @class AvanteConflictUserConfig
		diff = {
			autojump = true,
			---@type string | fun(): any
			list_opener = "copen",
			--- Override the 'timeoutlen' setting while hovering over a diff (see :help timeoutlen).
			--- Helps to avoid entering operator-pending mode with diff mappings starting with `c`.
			--- Disable by setting to -1.
			override_timeoutlen = 500
		},
		hints = {enable = true},
		  --- @class AvanteConflictUserConfig
		diff = {
			autojump = true,
			---@type string | fun(): any
			list_opener = "copen",
			--- Override the 'timeoutlen' setting while hovering over a diff (see :help timeoutlen).
			--- Helps to avoid entering operator-pending mode with diff mappings starting with `c`.
			--- Disable by setting to -1.
			override_timeoutlen = 500,
		},
	}
)
