local M = {}
-----------------------------------------------------------------------------------------
-- LSP 配置
------------------------------------------------------------------------------------------
-- local lspconfig = require("lspconfig")

-----------------------------------------------------------------------------------------
-- 切换头文件函数
------------------------------------------------------------------------------------------
local function switch_file_and_search()
    -- 获取当前文件名
    local current_file = vim.fn.expand("%:t:r") -- 文件名（不带路径和扩展名）
    local file_extension = vim.fn.expand("%:e") -- 扩展名
    local filename

    if file_extension == "c" or file_extension == "cpp" or file_extension == "cxx" then
        filename = current_file .. ".h"
    elseif file_extension == "h" or file_extension == "hpp" then
        filename = current_file .. ".c"
    else
        vim.notify("Not a C/C++ file", vim.log.levels.WARN)
        return
    end

    require("telescope.builtin").find_files({
        cwd = vim.g.workspace_dir.get(),
        default_text = filename,
    })
end

-----------------------------------------------------------------------------------------
-- capabilities 设置
------------------------------------------------------------------------------------------
local g_capabilities = require("cmp_nvim_lsp").default_capabilities()
g_capabilities.textDocument.completion.completionItem.snippetSupport = false

-----------------------------------------------------------------------------------------
-- clangd 配置
------------------------------------------------------------------------------------------
local function on_clangd_attach(client, bufnr)
    local telescope = require("telescope.builtin")
    local opts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set("n", "gd", telescope.lsp_definitions, { buffer = bufnr, desc = "Find definitions" })
    vim.keymap.set("n", "gi", telescope.lsp_implementations, { buffer = bufnr, desc = "Find implementations" })
    vim.keymap.set("n", "gr", telescope.lsp_references, { buffer = bufnr, desc = "Find references" })
    vim.keymap.set("n", "gl", telescope.lsp_document_symbols, { buffer = bufnr, desc = "Document symbols" })
    vim.keymap.set("n", "ga", telescope.lsp_dynamic_workspace_symbols, { buffer = bufnr, desc = "Workspace symbols" })
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<leader>fx", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "<leader>hS", switch_file_and_search, opts)
    vim.keymap.set("n", "<leader>hs", function()
        local params = { uri = vim.uri_from_bufnr(0) }
        vim.lsp.buf_request(0, "textDocument/switchSourceHeader", params, function(err, result)
            if err then
                vim.notify("SwitchSourceHeader error: " .. err.message, vim.log.levels.ERROR)
                return
            end
            if not result then
                vim.notify("No corresponding header/source found", vim.log.levels.INFO)
                return
            end
            vim.cmd("edit " .. vim.uri_to_fname(result))
        end)
    end, { noremap = true, silent = true, desc = "Switch between source/header" })
    vim.keymap.set("i", "<M-k>", vim.lsp.buf.signature_help, opts)
end

-- 使用新的 vim.lsp.start API 配置 clangd
vim.api.nvim_create_autocmd('FileType', {
    pattern = { "c", "cpp", "objc", "objcpp", "cuda", "proto", "hpp", "cxx", "h" },
    callback = function(args)
        local bufnr = args.buf
        if vim.lsp.get_clients({ bufnr = bufnr, name = "clangd" })[1] then
            return -- 已经附加了 clangd
        end
        
        vim.lsp.start({
            name = "clangd",
            cmd = {
                "clangd",
                "--background-index=true",
                "--clang-tidy",
                "--compile-commands-dir=build",
                "--pch-storage=disk",
                "--all-scopes-completion",
                "--cross-file-rename",
                "--header-insertion=never",
                "--completion-style=detailed",
                "--function-arg-placeholders",
                "--header-insertion-decorators",
                "--j=6",
                "--query-driver=" .. require("config.compiles_cfg").cxx_path,
            },
            capabilities = g_capabilities,
            on_attach = on_clangd_attach,
            root_dir = require("lspconfig.util").root_pattern("compile_commands.json", ".git"),
        })
    end,
})

-----------------------------------------------------------------------------------------
-- 动态切换 clangd
------------------------------------------------------------------------------------------
function M.switch_clangd(clangd_path, compiler_path)
    local new_config = {
        name = "clangd",
        cmd = {
            clangd_path,
            "--background-index=true",
            "--clang-tidy",
            "--compile-commands-dir=build",
            "--pch-storage=disk",
            "--completion-style=bundled",
            "--query-driver=" .. compiler_path,
        },
        root_dir = require("lspconfig.util").root_pattern("compile_commands.json", ".git"),
        on_attach = on_clangd_attach,
        capabilities = g_capabilities,
    }

    -- 停止所有 clangd 客户端（更安全的写法）
    for _, client in ipairs(vim.lsp.get_clients({ name = "clangd" })) do
        vim.lsp.stop_client(client)
    end

    -- 启动新实例
    vim.defer_fn(function()
        vim.lsp.start(new_config)
    end, 100)
end

-----------------------------------------------------------------------------------------
-- Python 配置
------------------------------------------------------------------------------------------
vim.api.nvim_create_autocmd('FileType', {
    pattern = { "py", "python" },
    callback = function(args)
        local bufnr = args.buf
        if vim.lsp.get_clients({ bufnr = bufnr, name = "pyright" })[1] then
            return -- 已经附加了 pyright
        end
        
        vim.lsp.start({
            name = "pyright",
            cmd = { "pyright-langserver", "--stdio" },
            filetypes = { "py", "python" },
            on_attach = function(_, bufnr)
                local telescope = require("telescope.builtin")
                local opts = { noremap = true, silent = true, buffer = bufnr }
                vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
                vim.keymap.set("n", "gi", telescope.lsp_implementations, opts)
                vim.keymap.set("n", "gr", telescope.lsp_references, opts)
                vim.keymap.set("n", "gl", telescope.lsp_document_symbols, opts)
                vim.keymap.set("n", "ga", telescope.lsp_dynamic_workspace_symbols, opts)
                vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
                vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
                vim.keymap.set("n", "<leader>ff", vim.lsp.buf.format, opts)
                vim.keymap.set("n", "<leader>fx", vim.lsp.buf.code_action, opts)
                vim.keymap.set("i", "<M-k>", vim.lsp.buf.signature_help, opts)
            end,
            settings = {
                python = {
                    analysis = {
                        typeCheckingMode = "basic",
                        autoSearchPaths = true,
                        useLibraryCodeForTypes = true,
                        diagnosticMode = "workspace",
                        autoImportCompletions = true,
                        diagnosticSeverityOverrides = {
                            reportUnusedImport = "warning",
                            reportUnusedVariable = "warning",
                            reportMissingImports = "error",
                            reportUnusedFunction = "warning",
                        },
                    },
                },
            },
        })
    end,
})

-----------------------------------------------------------------------------------------
-- 诊断符号
------------------------------------------------------------------------------------------
vim.diagnostic.config({
    virtual_text = { prefix = "■", source = "always" },
    update_in_insert = false,
    severity_sort = true,
    float = { source = "always" },
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN] = "▲",
            [vim.diagnostic.severity.INFO] = "✶",
            [vim.diagnostic.severity.HINT] = "☀",
        },
    },
})

-----------------------------------------------------------------------------------------
-- nvim-cmp 配置
------------------------------------------------------------------------------------------

local cmp = require('cmp')
local luasnip = require("luasnip")
cmp.setup({
	performance = {
		max_view_entries = 30,  -- 限制补全窗口中最多显示 20 个条目
	},
	window = {
		completion = {
			border = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' },
			scrollbar = false,  -- 关闭滚动条
			winhighlight = 'Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None',
			max_width = 50, -- 补全窗口的最大宽度（字符数）
			min_width = 50, -- 补全窗口的最大宽度（字符数）
		},
		documentation = {
			border = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' },
			scrollbar = false,  -- 关闭滚动条
			winhighlight = 'Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None',
			max_height = 25, -- 文档窗口的最大高度
		},
	},
	mapping = {
		['<Tab>'] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump() -- 跳到luasnip的下一个插入点
			else
				fallback() -- 默认行为（插入 Tab）
			end
		end, { 'i', 's' }), -- 在插入模式和选择模式下生效

		['<S-Tab>'] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1) -- 跳到luasnip的上一个插入点
			else
				fallback() -- 默认行为
			end
		end, { 'i', 's' }),

		['<M-j>'] = cmp.mapping(function(fallback)
			if cmp.visible() then
				-- 调用 luasnip.lsp_expand
				cmp.confirm({select = true,})
			elseif luasnip.choice_active() then
				luasnip.change_choice(1)
			else
				cmp.complete()
			end
		end, {'i', 's'}),

		['<M-h>'] = cmp.mapping(function(fallback)
			if luasnip.jumpable(-1) then
				luasnip.jump(-1) -- 跳到luasnip的上一个插入点
			else
				fallback() -- 默认行为
			end
		end, { 'i', 's'}),

		['<M-l>'] = cmp.mapping(function(fallback)
			if luasnip.jumpable(1) then
				luasnip.jump(1) -- 跳到luasnip的下一个插入点
			else
				fallback() -- 默认行为
			end
		end, { 'i', 's' }),
	},
	formatting = {
		format = function(entry, vim_item)
			-----------------------------------------------------------------------------------------------------------------------------------------------------------
			-- 删除所有 select_next_item 即可展开的来自lsp的补全项(仅可以补全参数不可以跳转(BUG!!))，但仍可以使用cmp.confirm({select = true,})展开补全
			-----------------------------------------------------------------------------------------------------------------------------------------------------------
			-- local abbr = vim_item.abbr
			-- if abbr:sub(-1) == "~" then 
			-- 	abbr = abbr:sub(1, -2)

			-- 	while string.byte(abbr, 1) == 0x20 do -- 删除空格
			-- 		abbr = abbr:sub(2)
			-- 	end

			-- 	if string.byte(abbr, 1) == 0xE2 then -- 删除<U+2022>(•), 0xE2,0x80,0xA2
			-- 		abbr = abbr:sub(4)
			-- 	end

			-- 	local startPos = string.find(vim_item.word, "%a") -- 若原始补全内容包含 -> . 等非字母数字内容，则保留
			-- 	if startPos ~= nil and startPos > 1 then
			-- 		abbr = string.sub(vim_item.word, 1, startPos - 1) .. abbr
			-- 	end

			-- 	vim_item.word = abbr
			-- else
			-- 	-- vim_item.word = vim_item.word:gsub("%W*$", "") -- 删除补全内容尾部的非字母或数字
			-- 	vim_item.word = vim_item.word:gsub("[^%w{}%=;->()]*$", "")
			-- end

			if vim_item.menu and #vim_item.menu > 60 then -- 提示信息中的参数长度限制
				vim_item.menu = vim_item.menu:sub(1, 60) .. '...'
			end
			if vim_item.abbr and #vim_item.abbr > 60 then -- 提示信息中的提示词显示的长度限制
				vim_item.abbr = vim_item.abbr:sub(1, 60) .. '...'
			end


			local kind_icons = {
				Text = "",          -- 文本
				Method = "",        -- 方法
				Function = "",      -- 函数
				Constructor = "",   -- 构造函数
				Field = "識",         -- 字段
				Variable = "",      -- 变量
				Class = "ﴯ",         -- 类
				Interface = "",     -- 接口
				Module = "",        -- 模块
				Property = "",      -- 属性
				Unit = "",          -- 单位
				Value = "",         -- 值
				Enum = "",          -- 枚举
				Keyword = "",       -- 关键字
				Snippet = "",       -- 代码片段
				Color = "",         -- 颜色
				File = "",          -- 文件
				Reference = "",     -- 引用
				Folder = "ﱮ",        -- 文件夹
				EnumMember = "",    -- 枚举成员
				Constant = "",      -- 常量
				Struct = "",        -- 结构
				Event = "",         -- 事件
				Operator = "",      -- 操作符
				TypeParameter = ""  -- 类型参数
			}

			-- 设置补全项的图标
			vim_item.kind = kind_icons[vim_item.kind] or ""

			return vim_item
		end
	},

	sources = {
		{ name = 'luasnip' }, -- LSP 补全源
		{ 
			name = 'nvim_lsp', 
			-- entry_filter = function(entry, ctx) -- 关闭 lsp 的snippet支持
			-- 	return require('cmp.types').lsp.CompletionItemKind[entry:get_kind()] ~= 'Text'
			-- end,
		}, -- LSP 补全源
		{ name = 'buffer' },   -- 缓冲区补全源
		{ name = 'path' },     -- 路径补全源
	},
	snippet = {
		expand = function(args)
			require('luasnip').lsp_expand(args.body) -- 使用 Luasnip 处理片段，且支持lsp函数参数补全的参数跳转，不加这个就不支持 lsp 函数参数的跳转
			return nil
		end,
	},
	completion = {
		completeopt = "menuone,noselect,insert,preview",  -- 配置为手动选择、插入并启用预览
	},

})


return M
