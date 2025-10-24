local M = {}

-----------------------------------------------------------------------------------------
-- 公共 require（避免多次 require）
-----------------------------------------------------------------------------------------
local telescope_builtin = require("telescope.builtin")
local root_pattern = require("lspconfig.util").root_pattern("compile_commands.json", ".git")


function lsp_common_attach(client, bufnr)
    -----------------------------------------------------------------------------------------
    -- lsp 高亮同一个变量时的显示效果，仅给光标下符号加下划线，不加背景/前景色
    -----------------------------------------------------------------------------------------
    vim.api.nvim_set_hl(0, "LspReferenceText",  { underline = true, undercurl = false, fg = nil, bg = nil })
    vim.api.nvim_set_hl(0, "LspReferenceRead",  { underline = true, undercurl = false, fg = nil, bg = nil })
    vim.api.nvim_set_hl(0, "LspReferenceWrite", { underline = true, undercurl = false, fg = nil, bg = nil })


    local nmap = require("keymap_help").nmap
    -- 只跳转到下一个错误
    nmap(
        "]e",
        "<cmd>lua vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })<CR>",
        {noremap = true, silent = true}
    )
    -- 只跳转到上一个错误
    nmap(
        "[e",
        "<cmd>lua vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })<CR>",
        {noremap = true, silent = true}
    )
    -- 只跳转到下一个警告
    nmap(
        "]d",
        "<cmd>lua vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.WARN })<CR>",
        {noremap = true, silent = true}
    )
    -- 只跳转到上一个警告
    nmap(
        "[d",
        "<cmd>lua vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.WARN })<CR>",
        {noremap = true, silent = true}
    )

    -- 高亮当前作用域变量
    if client.server_capabilities.documentHighlightProvider then
        local group = vim.api.nvim_create_augroup("LspDocumentHighlight" .. bufnr, { clear = true })
        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            group = group,
            buffer = bufnr,
            callback = vim.lsp.buf.document_highlight,
        })
        vim.api.nvim_create_autocmd("CursorMoved", {
            group = group,
            buffer = bufnr,
            callback = vim.lsp.buf.clear_references,
        })
    end
end

-----------------------------------------------------------------------------------------
-- 切换头文件并搜索
-----------------------------------------------------------------------------------------
local function switch_file_and_search()
    local current_file = vim.fn.expand("%:t:r")
    local file_extension = vim.fn.expand("%:e")
    local filename

    if file_extension == "c" or file_extension == "cpp" or file_extension == "cxx" then
        filename = current_file .. ".h"
    elseif file_extension == "h" or file_extension == "hpp" then
        filename = current_file .. ".c"
    else
        vim.notify("Not a C/C++ file", vim.log.levels.WARN)
        return
    end

    telescope_builtin.find_files({
        cwd = vim.g.workspace_dir.get(),
        default_text = filename,
    })
end

-----------------------------------------------------------------------------------------
-- capabilities 设置
-----------------------------------------------------------------------------------------
local g_capabilities = require("cmp_nvim_lsp").default_capabilities()

-----------------------------------------------------------------------------------------
-- clangd 配置
-----------------------------------------------------------------------------------------
local function on_clangd_attach(client, bufnr)
    lsp_common_attach(client, bufnr)

    local opts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set("n", "gd", telescope_builtin.lsp_definitions, { buffer = bufnr, desc = "Find definitions" })
    vim.keymap.set("n", "gi", telescope_builtin.lsp_implementations, { buffer = bufnr, desc = "Find implementations" })
    vim.keymap.set("n", "gr", telescope_builtin.lsp_references, { buffer = bufnr, desc = "Find references" })
    vim.keymap.set("n", "gl", telescope_builtin.lsp_document_symbols, { buffer = bufnr, desc = "Document symbols" })
    vim.keymap.set("n", "ga", telescope_builtin.lsp_dynamic_workspace_symbols, { buffer = bufnr, desc = "Workspace symbols" })
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<leader>fx", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "<leader>hS", switch_file_and_search, opts)

    -- clang-format init
    local config_path = vim.fn.stdpath("config") .. "/.clang-format"
    local cwd_config = vim.g.workspace_dir2()..'/.clang-format'

    if vim.fn.executable('clang-format') == 0 then
        vim.notify('clang-format not found! Please install clang-format', vim.log.levels.ERROR)
        return
    else
        local effective_config = vim.fn.filereadable(cwd_config) == 1 and cwd_config or
        vim.fn.filereadable(config_path) == 1 and config_path or nil
        vim.keymap.set('n', '<leader>ff', '', {
            noremap = true,
            silent = true,
            callback = function()
                local current_bufnr = vim.api.nvim_get_current_buf()
                local cursor_pos = vim.api.nvim_win_get_cursor(0)
                local lines = vim.api.nvim_buf_get_lines(current_bufnr, 0, -1, false)
                local formatted = vim.fn.systemlist('clang-format -style=file:"'.. effective_config:gsub('/', '\\') .. '"', lines)
                vim.api.nvim_buf_set_lines(current_bufnr, 0, -1, false, formatted)
                vim.api.nvim_win_set_cursor(0, cursor_pos)
            end
        })
    end


    -- 头文件切换
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
    end, opts)
    vim.keymap.set("i", "<M-k>", vim.lsp.buf.signature_help, opts)

end

-- 使用新的 vim.lsp.start API 配置 clangd
vim.api.nvim_create_autocmd('FileType', {
    pattern = { "c", "cpp", "objc", "objcpp", "cuda", "proto", "hpp", "cxx", "h" },
    -- once = true,
    callback = function(args)
        local bufnr = args.buf
        -- 如果当前缓冲区已经有 clangd 附加则跳过
        for _, c in ipairs(vim.lsp.get_clients({ name = "clangd" })) do
            if c.attached_buffers[bufnr] then return end
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
            root_dir = root_pattern,
        })
    end,
})

-----------------------------------------------------------------------------------------
-- 动态切换 clangd
-----------------------------------------------------------------------------------------
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
        root_dir = root_pattern,
        on_attach = on_clangd_attach,
        capabilities = g_capabilities,
    }

    -- 停止所有 clangd 客户端（直接传 client 更现代）
    for _, client in ipairs(vim.lsp.get_clients({ name = "clangd" })) do
        vim.lsp.stop_client(client)
    end

    -- 启动新实例
    vim.defer_fn(function()
        vim.lsp.start(new_config)
    end, 100)
end

-----------------------------------------------------------------------------------------
-- Python 配置（只用 "python" filetype）
-----------------------------------------------------------------------------------------
vim.api.nvim_create_autocmd('FileType', {
    pattern = { "python" },
    -- once = true,
    callback = function(args)
        local bufnr = args.buf
        for _, c in ipairs(vim.lsp.get_clients({ name = "pyright" })) do
            if c.attached_buffers[bufnr] then return end
        end

        if vim.g.lsp_settings == nil then
            -- 2. 查找项目根目录
            local root_markers = { ".git", "pyproject.toml", "setup.py", ".venv", ".venv_win", ".venv_wsl" }
            local buf_path = vim.api.nvim_buf_get_name(bufnr)
            local buf_dir = vim.fn.fnamemodify(buf_path, ":h")

            -- vim.fs.find 会向上查找第一个标记
            local marker_path = vim.fs.find(root_markers, { path = buf_dir, upward = true, stop = vim.fn.globpath('~', '~/') })[1]

            local root_dir = vim.g.workspace_dir2()

            -- 3. 动态确定 Python 解释器的路径
            local python_path = nil

            -- 要搜索的虚拟环境列表，按优先级排序
            local venv_options = {
                { name = ".venv_win", executable = "Scripts/python.exe" }, -- 典型的 Windows 路径
                { name = ".venv_wsl", executable = "bin/python" },        -- 典型的 Linux/WSL 路径
                { name = ".venv",      executable = vim.g.is_win32 == 1 and "Scripts/python.exe" or "bin/python" } -- 标准路径 (检测操作系统)
            }

            for _, venv in ipairs(venv_options) do
                local potential_venv_root = root_dir .. "/" .. venv.name
                local potential_python_path = potential_venv_root .. "/" .. venv.executable
                
                -- 检查可执行文件是否存在
                if vim.fn.filereadable(potential_python_path) == 1 then 
                    python_path = potential_python_path
                    venv_root = potential_venv_root  -- <-- 新增：存储 venv 根目录
                    break
                end
            end

            lsp_settings = {
                python = {
                    analysis = {
                        typeCheckingMode = "basic",
                        autoSearchPaths = true, -- <-- 重要：保持为 true
                        useLibraryCodeForTypes = true,
                        diagnosticMode = "workspace",
                        autoImportCompletions = true,
                        diagnosticSeverityOverrides = {
                            reportUnusedImport = "warning",
                            reportUnusedVariable = "warning",
                            reportMissingImports = "error",
                            reportUnusedFunction = "warning",
                        },
                        extraPaths = {},
                    },
                },
            }

            -- 5. 如果找到了 Python 路径，就将其添加到配置中
            if python_path ~= nil then
                lsp_settings.python.pythonPath = python_path
                
                if venv_root ~= nil then
                     lsp_settings.python.venvPath = venv_root
                     print("找到 Venv: " .. lsp_settings.python.venvPath) -- 调试信息
                     vim.notify("找到 Venv: " .. lsp_settings.python.venvPath)
                end
            else
                -- print("未找到自定义 venv。让 Pyright 自动检测。") -- 调试信息
            end
            vim.g.lsp_settings = lsp_settings
        end

        vim.lsp.start({
            name = "pyright",
            cmd = { "pyright-langserver", "--stdio" },
            filetypes = { "python" },
            settings = vim.g.lsp_settings,
            root_dir = root_dir,
            on_attach = function(client, bufnr)
                lsp_common_attach(client, bufnr)

                local opts = { noremap = true, silent = true, buffer = bufnr }
                vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
                vim.keymap.set("n", "gi", telescope_builtin.lsp_implementations, opts)
                vim.keymap.set("n", "gr", telescope_builtin.lsp_references, opts)
                vim.keymap.set("n", "gl", telescope_builtin.lsp_document_symbols, opts)
                vim.keymap.set("n", "ga", telescope_builtin.lsp_dynamic_workspace_symbols, opts)
                vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
                vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
                vim.keymap.set("n", "<leader>ff", vim.lsp.buf.format, opts)
                vim.keymap.set("n", "<leader>fx", vim.lsp.buf.code_action, opts)
                vim.keymap.set("i", "<M-k>", vim.lsp.buf.signature_help, opts)
            end,
        })
    end,
})

-----------------------------------------------------------------------------------------
-- 诊断符号
-----------------------------------------------------------------------------------------
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
-- nvim-cmp 配置（保持你的原始设置）
-----------------------------------------------------------------------------------------
local cmp = require('cmp')
local luasnip = require("luasnip")
cmp.setup({
    performance = {
        max_view_entries = 30,
    },
    window = {
        completion = {
            border = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' },
            scrollbar = false,
            winhighlight = 'Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None',
            max_width = 50,
            min_width = 50,
        },
        documentation = {
            border = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' },
            scrollbar = false,
            winhighlight = 'Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None',
            max_height = 25,
        },
    },
    mapping = {
        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { 'i', 's' }),

        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { 'i', 's' }),

        ['<M-j>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.confirm({ select = true })
            elseif luasnip.choice_active() then
                luasnip.change_choice(1)
            else
                cmp.complete()
            end
        end, { 'i', 's' }),

        ['<M-h>'] = cmp.mapping(function(fallback)
            if luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { 'i', 's' }),

        ['<M-l>'] = cmp.mapping(function(fallback)
            if luasnip.jumpable(1) then
                luasnip.jump(1)
            else
                fallback()
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
    --[[ formatting = {
        format = function(entry, vim_item)
            if vim_item.menu and #vim_item.menu > 60 then
                vim_item.menu = vim_item.menu:sub(1, 60) .. '...'
            end
            if vim_item.abbr and #vim_item.abbr > 60 then
                vim_item.abbr = vim_item.abbr:sub(1, 60) .. '...'
            end
            local kind_icons = {
                Text = "", Method = "", Function = "", Constructor = "",
                Field = "識", Variable = "", Class = "ﴯ", Interface = "",
                Module = "", Property = "", Unit = "", Value = "",
                Enum = "", Keyword = "", Snippet = "", Color = "",
                File = "", Reference = "", Folder = "ﱮ", EnumMember = "",
                Constant = "", Struct = "", Event = "", Operator = "",
                TypeParameter = ""
            }
            vim_item.kind = kind_icons[vim_item.kind] or ""
            return vim_item
        end
    }, ]]
    sources = {
        { name = 'luasnip' },
        { name = 'nvim_lsp' },
        { name = 'buffer' },
        { name = 'path' },
    },
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
            return nil
        end,
    },
    completion = {
        completeopt = "menuone,noselect,insert,preview",
    },
})


return M
