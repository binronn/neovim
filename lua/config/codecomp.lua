local M = require("lualine.component"):extend()

local processing = false
local spinner_index = 1

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
					processing = true
				elseif request.match == "CodeCompanionRequestFinished" then
					processing = false
				end
			end
		}
	)
end

-- Function that runs every time statusline is updated
function M:update_status()
	if processing then
		spinner_index = (spinner_index % spinner_symbols_len) + 1
		return spinner_symbols[spinner_index]
	else
		return '∴' -- ∞
	end
end


-- 自动检测并固定codecompanion窗口宽度
function fix_codecompanion_width()
	local win = nil
    vim.api.nvim_create_autocmd({--[[ 'WinEnter', ]] 'BufEnter', 'VimResized'}, {
        callback = function()

			-- if pcall(vim.api.nvim_win_get_buf, win)  then
			if win ~= nil and vim.api.nvim_win_is_valid(win)  then
				vim.api.nvim_win_set_option(win, 'winfixwidth', true)
				vim.api.nvim_win_set_width(win, math.floor(vim.o.columns * 0.3))
				return
			else
				win = nil
			end

            local filetype = vim.api.nvim_buf_get_option(0, 'filetype')
            if string.match(filetype, 'codecompanion') then
				win = vim.api.nvim_get_current_win()
				--
				-- 避免重复处理同一个窗口
				-- if win == last_win then return end
				-- last_win = win
				--
				vim.api.nvim_win_set_option(win, 'winfixwidth', true)
				vim.api.nvim_win_set_width(win, math.floor(vim.o.columns * 0.3))
			end
		end
	})
end

function M:setup_codecomp()
	fix_codecompanion_width()
	require("codecompanion").setup(
    {
        opts = {
            language = "中文",
        },
        prompt_library = require('config.codecomp.prompt_library.base'),
        rules = require('config.codecomp.rules.base'),
        mcp = require('config.codecomp.mcp.base'),
        extensions = require('config.codecomp.extensions'),
        adapters = require('config.codecomp.adapters'),
        interactions = {
            chat = {
                roles = {
                    ---The header name for the LLM's messages
                    ---@type string|fun(adapter: CodeCompanion.Adapter): string
                    llm = function(adapter)

                        local model_default = adapter.name
                        if adapter.schema then
                            return model_default .. ' / ' .. adapter.schema.model.default
                        end
                        return model_default
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
                adapter = "a0pen_dsk",
                keymaps = {
                    send = {
                        modes = {n = "<Enter>", i = "<C-s>"}
                    },
                    close = {
                        modes = {n = "<C-c>", i = "C-c"}
                    }
                },
                tools = {
                    ["run_command"] = {
                        path = 'config.codecomp.tools.run_command',
                        enabled = true,
                    },
                    -- ["calculator"] = require('config.codecomp.tools.calculator'),
                }
            },
            inline = {
                adapter = "a0pen_dsk"
            },
            cmd = {
                adapter = 'a0pen_dsk'
            }
        },
        display = {
            chat = {
                -- Change the default icons
                  icons = {
                      sync_all = "",
                      sync_diff = "👀"
                  },
                -- Alter the sizing of the debug window
                debug_window = {},
                -- Options to customize the UI of the chat buffer
                -- floating_window = {
                window = {
                    title = 'CodeCompanion',
                    layout = "vertical", -- float|vertical|horizontal|buffer
                    position = "right", -- left|right|top|bottom (nil will default depending on vim.opt.plitright|vim.opt.splitbelow)
                    border = "rounded",
                    height = 0.9,
                    width = 0.3,
                    col = vim.o.columns * 0.7, -- 调整到屏幕右侧
                    row = vim.o.lines * 0.03, -- 调整到屏幕顶部
                    relative = "editor",
                    style = "full",
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
                -- provider = "mini_diff" -- default|mini_diff
            }
        }
    })
end

return M
