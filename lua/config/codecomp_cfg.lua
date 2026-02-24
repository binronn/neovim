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

local function get_rule_base_path()
    return vim.fn.stdpath("config") .. "/lua/config/codecomp/rules/"
end

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

local ips = {}
function M:get_url_ip(urlxxx)
	ips['rm.basicbit.cn'] = '115.120.244.116'
	if ips[urlxxx] == nil then

		local handle = io.popen("ping -c 1 " .. urlxxx) -- 替换为你的域名
		local result = handle:read("*a")
		handle:close()

		-- 使用正则表达式提取IP地址（适用于Linux）
		ips[urlxxx] = string.match(result, "%((%d+%.%d+%.%d+%.%d+)%)")
	end
	return ips[urlxxx]
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
        prompt_library = {
            -- ["Generate a Commit Message"] = require('config.codecomp.prompt_library.commit_message'),
        },
        rules = {
            python = {
                description = 'Python rules',
                files = {
                    get_rule_base_path() .. 'python/base.md'
                }
            },
            memory = {
                description = 'Memory rules',
                files = {
                    get_rule_base_path() .. 'memory/base.md'
                }
            },
            bigfile = {
                description = 'Big file read rules',
                files = {
                    get_rule_base_path() .. 'bigfile/base.md'
                }
            }
        },
        adapters = {
            http = {
                dskfee = function()
                    return require("codecompanion.adapters").extend("openai_compatible", {
                        name = "dskfee",
                        env = {
                            url = "http://" .. M:get_url_ip('rm.basicbit.cn') .. ":43410",
                            api_key = vim.fn.getenv("DSK_FEE_TKN"),
                            chat_url = "/v1/chat/completions"
                        },
                        schema = { model = { default = "deepseek-chat" } }
                    })
                end,
                a0pen_dsk = function()
                    return require("codecompanion.adapters").extend("openai_compatible", {
                        name = "open_dsk",
                        env = {
                            url = "https://api.deepseek.com",
                            chat_url = "/v1/chat/completions",
                            api_key = vim.fn.getenv("DSK")
                        },
                        schema = {
                            model = {
                                default = "deepseek-chat",
                                choices = {
                                    'deepseek-chat',
                                    ["deepseek-reasoner"] = { opts = { can_reason = true } }
                                }
                            }
                        }
                    })
                end,
                a0pen_qwen_fast = function()
                    return require("codecompanion.adapters").extend("openai_compatible", {
                        name = "qwen3.5-plus-fast",
                        env = {
                            url = "https://dashscope.aliyuncs.com",
                            chat_url = "/compatible-mode/v1/chat/completions",
                            api_key = vim.fn.getenv("QWEN_API")
                        },
                        schema = {
                            model = {
                                default = "qwen3.5-plus-2026-02-15",
                                choices = {
                                    ["qwen3.5-plus"] = { opts = { can_reason = true } },
                                    'qwen3.5-plus-2026-02-15',
                                    'qwen3.5-397b-a17b'
                                }
                            }
                        }
                    })
                end,
                a0pen_kimi = function()
                    return require("codecompanion.adapters").extend("openai_compatible", {
                        name = "kimi",
                        env = {
                            url = "https://api.moonshot.ai",
                            chat_url = "/v1/chat/completions",
                            api_key = vim.fn.getenv("KIMI")
                        },
                        schema = {
                            model = {
                                default = "kimi-k2.5",
                            },
                        },
                        body = {
                            thinking = { type = "disabled" }
                        },
                    })
                end,
                a2siliconflow = function()
                    return require("codecompanion.adapters").extend("openai_compatible", {
                        name = "siliconflow",
                        env = {
                            url = "https://api.siliconflow.cn",
                            chat_url = "/v1/chat/completions",
                            api_key = vim.fn.getenv("SILICONFLOW_DSK")
                        },
                        schema = {
                            model = {
                                default = "Qwen/Qwen3-30B-A3B",
                                -- choices = {
                                --     'deepseek-ai/DeepSeek-V3',
                                --     ["deepseek-ai/DeepSeek-R1"] = { opts = { can_reason = true } },
                                --     ["Qwen/Qwen3-32B"] = { opts = { can_reason = true } },
                                --     ["Qwen/Qwen3-30B-A3B"] = { opts = { can_reason = true } },
                                --     ["Qwen/Qwen3-Coder-480B-A35B-Instruct"] = { opts = { can_reason = true } }
                                -- }
                            }
                        }
                    })
                end,
                a1gemini = function()
                    return require("codecompanion.adapters").extend("openai_compatible", {
                        name = "gemini",
                        env = {
                            url = "http://localhost:8045",
                            chat_url = "/v1/chat/completions",
                            api_key = vim.fn.getenv("ANTHROPIC_AUTH_TOKEN")
                        },
                    })
                end
            },
        },
        interactions = {
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
                    -- calculator = require('config.codecomp.tools.calculator'),
                    cmd_runner = require('config.codecomp.tools.cmd_runner')
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
