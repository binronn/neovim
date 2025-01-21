-----------------------------------------------------------------------------------------
-- LSP 配置
------------------------------------------------------------------------------------------
local lspconfig = require("lspconfig")

function switch_file_and_search()
	-- 获取当前文件名
	local current_file = vim.fn.expand("%:t:r") -- 获取文件名（不带路径和扩展名）
	local file_extension = vim.fn.expand("%:e") -- 获取文件扩展名
	local filename

	-- 根据扩展名修改文件名
	if file_extension == "c" or file_extension == "cpp" or file_extension == "cxx" then
		filename = current_file .. ".h" -- 修改为头文件
	elseif file_extension == "h" or file_extension == "hpp" then
		filename = current_file .. ".c" -- 修改为源文件
	else
		print("Not a C/C++ file")
		return
	end

	-- 拼接 LeaderfFilePattern 命令
	-- local command = ':LeaderfFilePattern ' .. filename
	local command =
		string.format(
		'lua require("telescope.builtin").find_files({ cwd = vim.g.workspace_dir.get(), default_text="%s" })',
		filename
	)
	vim.cmd(command)
end

-- C++ 配置 (clangd)
lspconfig.clangd.setup(
	{
		cmd = {
			"clangd", 
			"--background-index=true",
			"--clang-tidy",
			"--compile-commands-dir=build",
			"--completion-style=detailed",  -- 增强补全信息
			-- "--header-insertion=never"      -- 禁用自动头文件插入
		},
		filetypes = {"c", "cpp", "objc", "objcpp", "cuda", "proto", "hpp", "cxx"},
		capabilities = require('cmp_nvim_lsp').default_capabilities(),
		diagnostics = {
			-- 设置诊断刷新延迟（单位：毫秒）
			update_in_insert = false, -- 在插入模式下不更新诊断
			debounce = 300, -- 设置诊断刷新延迟为 300 毫秒
			severity_sort = true            -- 按严重程度排序诊断
		},
		on_attach = function(client, bufnr)
			local opts = {noremap = true, silent = true}
			local keymap = vim.api.nvim_buf_set_keymap
			vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<cr>", {desc = "Find definitions"})
			vim.keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<cr>", {desc = "Find implementations"})
			vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<cr>", {desc = "Find references"})
			vim.keymap.set("n", "gl", "<cmd>Telescope lsp_document_symbols<cr>", {desc = "Find references"})
			vim.keymap.set("n", "ga", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", {desc = "Find references"})
			keymap(bufnr, "n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", opts)
			keymap(bufnr, "n", "<leader>rn", "<Cmd>lua vim.lsp.buf.rename()<CR>", opts)
			keymap(bufnr, "n", "<leader>ff", "<Cmd>lua vim.lsp.buf.format()<CR>", opts)
			keymap(bufnr, "n", "<leader>fx", "<Cmd>lua vim.lsp.buf.code_action()<CR>", opts)
			keymap(
				bufnr,
				"n",
				"<leader>wf",
				"<cmd>lua for _, folder in ipairs(vim.lsp.buf.list_workspace_folders()) do print(folder) end<CR>",
				opts
			)
			keymap(bufnr, "n", "<leader>hs", "<cmd>lua switch_file_and_search()<CR>", opts)
			keymap(bufnr, "i", "<C-j>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts) -- 弹出参数提示
			-- vim.api.nvim_create_autocmd('CursorHoldI', { -- 自动弹出参数提示
			--     buffer = bufnr,
			--     callback = function()
			--         vim.lsp.buf.signature_help()
			--     end
			-- })
		end
	}
)

------------------------------------------------------------------------------------------
-- Python 配置 (pyright)
------------------------------------------------------------------------------------------
lspconfig.pyright.setup(
	{
		filetypes = {"py", "python"},
		on_attach = function(client, bufnr)
			local opts = {noremap = true, silent = true}
			local keymap = vim.api.nvim_buf_set_keymap
			keymap(bufnr, "n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)
			vim.keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<cr>", {desc = "Find implementations"})
			vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<cr>", {desc = "Find references"})
			vim.keymap.set("n", "gl", "<cmd>Telescope lsp_document_symbols<cr>", {desc = "Find references"})
			vim.keymap.set("n", "ga", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", {desc = "Find references"})
			keymap(bufnr, "n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", opts)
			keymap(bufnr, "n", "<leader>rn", "<Cmd>lua vim.lsp.buf.rename()<CR>", opts)
			keymap(bufnr, "n", "<leader>ff", "<Cmd>lua vim.lsp.buf.format()<CR>", opts)
			keymap(bufnr, "n", "<leader>fx", "<Cmd>lua vim.lsp.buf.code_action()<CR>", opts)
		end,
		settings = {
			python = {
				analysis = {
					typeCheckingMode = "default",
					autoSearchPaths = true,
					useLibraryCodeForTypes = true
				}
			}
		}
	}
)

-- 自定义诊断符号
vim.diagnostic.config(
	{
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

					[vim.diagnostic.severity.ERROR] = "⨯",
					[vim.diagnostic.severity.WARN] = "▲",
					[vim.diagnostic.severity.INFO] = "»",
					[vim.diagnostic.severity.HINT] = "➤"
				}
				return icons[diagnostic.severity] .. " " .. diagnostic.message
			end
		},
		update_in_insert = false,
		severity_sort = true,
		float = {
			source = "always"
		},
		signs = {
			text = {
				[vim.diagnostic.severity.ERROR] = "⨯",
				[vim.diagnostic.severity.WARN] = "▲",
				[vim.diagnostic.severity.INFO] = "»",
				[vim.diagnostic.severity.HINT] = "➤"
				-- [vim.diagnostic.severity.ERROR] = "❌",
				-- [vim.diagnostic.severity.WARN]  = "⚠️",
				-- [vim.diagnostic.severity.INFO]  = "ℹ️",
				-- [vim.diagnostic.severity.HINT]  = "💡",
			}
		}
	}
)
------------------------------------------------------------------------------------------
-- 补全配置
------------------------------------------------------------------------------------------
local cmp = require "cmp"
cmp.setup({
	window = {
		completion = {
			max_width = 50, -- 补全窗口的最大宽度（字符数）
			min_width = 50, -- 补全窗口的最大宽度（字符数）
		},
		documentation = {
			max_height = 15, -- 文档窗口的最大高度
		},
	},
	mapping = {
		['<Tab>'] = cmp.mapping(function(fallback)
			local luasnip = vim.g.luasnip
			if cmp.visible() then
				cmp.select_next_item() -- 选择下一个补全项
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump() -- 跳到luasnip的下一个插入点
			else
				fallback() -- 默认行为（插入 Tab）
			end
		end, { 'i', 's' }), -- 在插入模式和选择模式下生效

		['<S-Tab>'] = cmp.mapping(function(fallback)
			local luasnip = vim.g.luasnip
			if cmp.visible() then
				cmp.select_prev_item() -- 选择上一个补全项
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1) -- 跳到luasnip的上一个插入点
			else
				fallback() -- 默认行为
			end
		end, { 'i', 's' }),

		['<C-j>'] = cmp.mapping(function(fallback)
			local luasnip = vim.g.luasnip
			if cmp.visible() then
				cmp.confirm({ select = true })
			elseif luasnip.choice_active() then
				luasnip.change_choice(1)
			else
				fallback()
			end
		end, {'i', 's'}),
		-- ['<C-j>'] = cmp.mapping.confirm({ select = true }), -- 确认当前选择的补全项
	},
	sources = {
		{ name = 'nvim_lsp' }, -- LSP 补全源
		{ name = 'luasnip' }, -- LSP 补全源
		{ name = 'buffer' },   -- 缓冲区补全源
		{ name = 'path' },     -- 路径补全源
	},
})
