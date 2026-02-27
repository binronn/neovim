local ips = {}
function get_url_ip(urlxxx)
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

return {
    http = {
        dskfee = function()
            return require("codecompanion.adapters").extend("openai_compatible", {
                name = "dskfee",
                env = {
                    url = "http://" .. get_url_ip('rm.basicbit.cn') .. ":43410",
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
        a0pen_qwen = function()
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
        a0pen_minimax = function()
            return require("codecompanion.adapters").extend("openai_compatible", {
                name = "kimi",
                env = {
                    url = "https://api.minimaxi.com",
                    chat_url = '/v1/text/chatcompletion_v2',
                    api_key = vim.fn.getenv("MINIMAX")
                },
                schema = {
                    model = {
                        default = "minimax-m2.5",
                        choices = {
                            ["minimax-m2.5"] = { opts = { can_reason = true } },
                        }
                    }
                }
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
                        api_key = vim.fn.getenv("ANTIGRAVITY2API")
                    },
                })
            end
        },
    }
