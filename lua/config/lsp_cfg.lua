local M = {}

-----------------------------------------------------------------------------------------
-- 公共 require（避免多次 require）
-----------------------------------------------------------------------------------------
local telescope_builtin = require("telescope.builtin")
local root_pattern = require("lspconfig.util").root_pattern("compile_commands.json", ".git")


function lsp_common_attach(client, bufnr)

    for _, mode in ipairs({ "n", "v", "i" }) do
        -- grn → vim.lsp.buf.rename()
        pcall(vim.keymap.del, mode, "grn")

        -- gra → vim.lsp.buf.code_action()
        pcall(vim.keymap.del, mode, "gra")

        -- grr → vim.lsp.buf.references()
        pcall(vim.keymap.del, mode, "grr")

        -- gri → vim.lsp.buf.implementation()
        pcall(vim.keymap.del, mode, "gri")

        -- grt → vim.lsp.buf.type_definition()
        pcall(vim.keymap.del, mode, "grt")

        -- gO → vim.lsp.buf.document_symbol()
        pcall(vim.keymap.del, mode, "gO")

        -- <C-S> → vim.lsp.buf.signature_help()
        pcall(vim.keymap.del, mode, "<C-S>")
    end

    local opts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set("n", "gd", telescope_builtin.lsp_definitions, { buffer = bufnr, desc = "Find definitions" })
    vim.keymap.set("n", "gi", telescope_builtin.lsp_implementations, { buffer = bufnr, desc = "Find implementations" })
    -- vim.keymap.set("n", "gt", telescope_builtin.lsp_type_definitions, { buffer = bufnr, desc = "Find type_definition" })
    vim.keymap.set("n", "gr", telescope_builtin.lsp_references, { buffer = bufnr, desc = "Find references" })
    vim.keymap.set("n", "gl", telescope_builtin.lsp_document_symbols, { buffer = bufnr, desc = "Document symbols" })
    vim.keymap.set("n", "ga", telescope_builtin.lsp_dynamic_workspace_symbols, { buffer = bufnr, desc = "Workspace symbols" })
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<leader>fx", vim.lsp.buf.code_action, opts)
    vim.keymap.set("i", "<M-k>", vim.lsp.buf.signature_help, opts)

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

end

vim.lsp.config.clangd = {
    filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto", "hpp", "cxx", "h" },
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
        "-j=6",
        "--query-driver=" .. require("config.compiles_cfg").cxx_path,
    },
    root_markers = { ".git", "compile_commands.json", "CMakeLists.txt" },
    capabilities = g_capabilities,
    on_attach = on_clangd_attach,
}

--------------------------------------------------------------------------------
-- CPP LSP 自启动
--------------------------------------------------------------------------------

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "c", "cpp", "objc", "objcpp", "cuda", "proto", "hpp", "cxx", "h" },
    callback = function(args)
        if vim.bo[args.buf].buftype ~= "" then return end -- 跳过特殊 buffer
        vim.lsp.start(vim.lsp.config.clangd, { bufnr = args.buf })
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


--------------------------------------------------------------------------------
-- 1. Python 基础配置模板 (只定义静态内容，不要放 before_init)
--------------------------------------------------------------------------------
local py_base_config = {
    filetypes = { 'python' },
    cmd = { 'pyright-langserver', '--stdio' },
    capabilities = g_capabilities, -- 假设 g_capabilities 上文已定义
    settings = {
        python = {
            analysis = {
                typeCheckingMode = "off",
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "workspace",
                autoImportCompletions = true,
                diagnosticSeverityOverrides = {
                    reportUnusedImport = "warning",
                    reportUnusedVariable = "warning",
                    reportMissingImports = "error",
                },
            },
        },
    },
    on_attach = function(client, bufnr)
        lsp_common_attach(client, bufnr) -- 假设你上文有这个函数
        local opts = { noremap = true, silent = true, buffer = bufnr }
        vim.keymap.set("n", "<leader>ff", function()
            vim.lsp.buf.format({ async = true })
        end, opts)
    end,
}

--------------------------------------------------------------------------------
-- 2. python 缓存容器与工具函数
--------------------------------------------------------------------------------
local root_cache = {}   -- 缓存: 文件夹路径 -> 项目根目录 (字符串)
local config_cache = {} -- 缓存: 项目根目录 -> 实例化的 Config Table

local py_root_match = require("lspconfig.util").root_pattern(
    ".git", "pyproject.toml", "setup.py", "requirements.txt", 
    ".venv", ".venv_win", ".venv_wsl"
)

-- [工具] 查找并注入 Python 路径到配置中 (只在生成 Config 时运行一次)
local function inject_python_path(config, root_dir)
    local venv_options = {
        { name = ".venv_win", exe = "Scripts/python.exe" },
        { name = ".venv_wsl", exe = "bin/python" },
        { name = ".venv",     exe = (vim.g.is_win32 == 1) and "Scripts/python.exe" or "bin/python" }
    }

    for _, venv in ipairs(venv_options) do
        local venv_path = root_dir .. "/" .. venv.name
        local py_path = venv_path .. "/" .. venv.exe
        if vim.fn.filereadable(py_path) == 1 then
            config.settings.python.pythonPath = py_path
            config.settings.python.venvPath = venv_path
            vim.notify("Found venv: " .. venv_path)
            return
        end
    end
end

--------------------------------------------------------------------------------
-- 3. python 核心: 获取或创建 Config (懒加载模式)
--------------------------------------------------------------------------------
local function get_py_config(buf_path)
    local file_dir = vim.fs.dirname(buf_path)

    local root_dir = root_cache[file_dir]
    if not root_dir then
        root_dir = py_root_match(buf_path) or file_dir
        root_cache[file_dir] = root_dir
    end

    if config_cache[root_dir] then
        return config_cache[root_dir]
    end

    local new_config = vim.deepcopy(py_base_config)
    
    new_config.root_dir = root_dir
    new_config.workspace_folders = {
        { name = vim.fs.basename(root_dir), uri = vim.uri_from_fname(root_dir) }
    }

    inject_python_path(new_config, root_dir)

    config_cache[root_dir] = new_config
    return new_config
end

--------------------------------------------------------------------------------
-- 4. python Autocmd (极简入口)
--------------------------------------------------------------------------------
vim.api.nvim_create_autocmd("FileType", {
    pattern = "python",
    callback = function(args)
        if vim.bo[args.buf].buftype ~= "" then return end
        local file_path = vim.api.nvim_buf_get_name(args.buf)
        if file_path == "" then return end

        -- 极速获取配置对象 (O(1) 复杂度)
        local config = get_py_config(file_path)

        -- 启动 (vim.lsp.start 内部会处理 Client 复用，不会重复启动进程)
        vim.lsp.start(config, { bufnr = args.buf })
    end,
})

--------------------------------------------------------------------------------
-- 极致优化的 LSP 进度通知 (数据与渲染分离模式)
--------------------------------------------------------------------------------
local progress_state = {}
local render_timer = nil

local spinner_frames = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
local spinner_idx = 1

local function render_progress()
    -- 如果没有任务了，停止定时器，节省资源
    if vim.tbl_isempty(progress_state) then
        if render_timer then
            render_timer:stop()
            render_timer:close()
            render_timer = nil
        end
        return
    end

    -- 更新全局 Spinner 帧
    spinner_idx = (spinner_idx % #spinner_frames) + 1
    local current_time = vim.loop.now()

    -- 遍历所有活跃任务进行渲染
    -- 使用 vim.schedule 确保在主线程操作 UI
    vim.schedule(function()
        for key, task in pairs(progress_state) do
            
            -- A. 构造显示内容
            local icon = spinner_frames[spinner_idx]
            if task.kind == "end" then icon = "✔" end

            local msg_parts = {
                string.format("%s %s: %s", icon, task.client_name, task.title)
            }

            if task.percentage then
                table.insert(msg_parts, string.format("(%d%%)", task.percentage))
            end

            if task.message and task.message ~= "" then
                table.insert(msg_parts, string.format("- %s", task.message))
            end
            
            local notif_body = table.concat(msg_parts, " ")
            
            -- B. 构造 notify 选项
            local opts = {
                title = "LSP Progress",
                icon = "",
                timeout = false, -- 默认不消失，由我们控制
                hide_from_history = true,
                replace = task.notify_id, -- 【核心】尝试复用窗口 ID
            }

            if task.kind == "end" then
                opts.timeout = 2000 -- 结束时，2秒后自动消失
            end

            -- C. 调用 vim.notify (使用 pcall 防止窗口已关闭导致的报错)
            local status, new_id = pcall(vim.notify, notif_body, vim.log.levels.INFO, opts)

            -- D. 状态维护
            if status then
                -- 更新 ID，以便下次循环复用
                task.notify_id = new_id 
            else
                -- 如果更新失败 (用户手动关闭了弹窗)，清除 ID，让它下次重新创建(或者根据需求不再弹窗)
                task.notify_id = nil 
            end

            -- E. 清理逻辑：如果是 end 状态，渲染完这一帧后，从状态表中移除
            -- 这样确保了用户能看到最后一帧的 "✔ Finished"
            if task.kind == "end" then
                -- 这里做一个简单的延迟移除，或者直接移除（因为设置了 timeout=2000，notify 插件会接管消失逻辑）
                progress_state[key] = nil
            end
        end
    end)
end

local function ensure_timer()
    if not render_timer then
        render_timer = vim.loop.new_timer()
        render_timer:start(0, 500, vim.schedule_wrap(render_progress))
    end
end

-- 4. 【事件层】监听 LSP 消息
vim.api.nvim_create_autocmd("LspProgress", {
    callback = function(ev)
        local client_id = ev.data.client_id
        local val = ev.data.params.value
        local token = ev.data.params.token

        if not token then return end

        local key = string.format("%s-%s", client_id, token)
        
        -- 如果是任务结束，但状态表里没有记录（可能开始太快结束太快），则忽略
        if val.kind == "end" and not progress_state[key] then
            return
        end

        -- 获取 Client 名字
        local client = vim.lsp.get_client_by_id(client_id)
        local client_name = client and client.name or "LSP"

        -- 更新或初始化状态数据
        if not progress_state[key] then
            progress_state[key] = {
                client_name = client_name,
                notify_id = nil -- 初始没有 ID
            }
        end

        -- 更新具体的字段
        local task = progress_state[key]
        task.kind = val.kind
        if val.title then task.title = val.title end
        if val.message then task.message = val.message end
        if val.percentage then task.percentage = val.percentage end
        
        -- 只要有数据更新，就确保定时器在跑
        ensure_timer()
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
            [vim.diagnostic.severity.ERROR] = "Ⓧ",
            [vim.diagnostic.severity.WARN] = "ⓦ",
            [vim.diagnostic.severity.INFO] = "ⓘ",
            [vim.diagnostic.severity.HINT] = "Ⓗ",
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
