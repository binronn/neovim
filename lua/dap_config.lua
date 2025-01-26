local dap = require("dap")
local dapui = require("dapui")

require("telescope").load_extension("dap")
require("nvim-dap-virtual-text").setup()
-- dapui.setup()

-----------------------------------------------
-- 全局参数
-----------------------------------------------
---
---
vim.g.debuger_short = false
local tmux_split_pty = nil -- 保存终端的设备ID
local original_K_mapping = nil -- 保存 K 快捷键功能
local debug_args = nil
local g_is_tagbar_open = false
local g_is_avante_open = false
local g_is_nvimtree_open = false
local g_temp_side_window_groupid = nil
local g_dapui_closed = false

-----------------------------------------------
-- 默认调试UI
-----------------------------------------------
---
local function default_dapui()
	require("dapui").setup(
	{
		layouts = {
			{
				elements = {
					{id = "breakpoints", size = 0.25}, -- 断点窗口，占 25% 宽度
					{id = "stacks", size = 0.25}, -- 调用栈窗口，占 25% 宽度
					{id = "watches", size = 0.20}, -- 监视窗口，占 25% 宽度
					{id = "scopes", size = 0.30}, -- 作用域窗口，占 25% 宽度
				},
				size = 40, -- 左侧总宽度为 40 列
				position = "left" -- 左侧显示
			},
			{
				elements = {
					{ id = "repl", size = 0.5 }, -- REPL 窗口，占 50% 高度
					{ id = "console", size = 0.5 },      -- 控制台窗口，占 50% 高度
				},
				size = 20, -- 底部总高度为 10 行
				position = "bottom" -- 底部显示
			}
		}
	}
	)
end
-----------------------------------------------
-- 保存并恢复窗口
-----------------------------------------------
---
local function on_aerial_loaded()
	-- 检查当前文件类型是否为 aerial
end

local function save_window_status()
	local nvim_tree = require("nvim-tree.api").tree

	g_is_nvimtree_open = nvim_tree.is_visible() -- 检测 NvimTree 是否打开
	g_is_tagbar_open = false
	g_is_avante_open = false
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		local buf = vim.api.nvim_win_get_buf(win)
		if vim.api.nvim_buf_get_option(buf, "filetype") == "aerial" then
			g_is_tagbar_open = true
			break
		end
	end

	for _, win in ipairs(vim.api.nvim_list_wins()) do
		local buf = vim.api.nvim_win_get_buf(win)
		if vim.api.nvim_buf_get_option(buf, "filetype") == "Avante" then
			g_is_avante_open = true
			vim.cmd('AvanteToggle')
			break
		end
	end
end

local function close_dap_repl_buffers()
	local bufnr = vim.fn.bufnr("^%[dap%-repl%-") -- 匹配以 "[dap-repl-" 开头的缓冲区
	while bufnr ~= -1 do -- -1 表示未找到
		vim.api.nvim_buf_delete(bufnr, {force = true}) -- 强制删除缓冲区
		print("Closed buffer:", vim.api.nvim_buf_get_name(bufnr))
		bufnr = vim.fn.bufnr("^%[dap%-repl%-") -- 继续查找下一个匹配的缓冲区
	end
end

-----------------------------------------------
-- 窗口操作函数
-----------------------------------------------
function jump_to_file_window()
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)
        local filetype = vim.api.nvim_buf_get_option(buf, "filetype")
        -- 检查是否是普通文件缓冲区（排除特殊缓冲区如NvimTree等）
        if filetype ~= "" and filetype ~= "AvanteInput" and filetype ~= "AvanteSelectedFiles" 
            and filetype ~= "Avante" and filetype ~= "qf" and filetype ~= "NvimTree" 
            and filetype ~= "aerial" then
            vim.api.nvim_set_current_win(win)
            return
        end
    end
    print("No file window found")
end

-----------------------------------------------------------------
-- 重新打开类文件窗口，并移动光标到编辑窗口
-----------------------------------------------------------------
local function restore_window()
	-- 如果有窗口被打开，则设置 autocmd
	if g_is_tagbar_open == true then
		vim.api.nvim_create_autocmd(
			"FileType",
			{
				pattern = "aerial", -- 监听所有缓冲区
				once = true,
				callback = function()
					vim.defer_fn(
						function()
							vim.cmd("wincmd p") -- 切换到上一个窗口
							-- close_dap_repl_buffers()
						end,
						5
					)
				end
			}
		)
	end

	if g_is_nvimtree_open == true then
		vim.api.nvim_create_autocmd(
			"FileType",
			{
				pattern = "NvimTree", -- 监听所有缓冲区
				once = true,
				callback = function()
					vim.defer_fn(
						function()
							vim.cmd("wincmd p") -- 切换到上一个窗口
							-- close_dap_repl_buffers()
						end,
						5
					)
				end
			}
		)
	end

	-- 检查 NvimTree 是否打开
	if g_is_nvimtree_open == true then
		vim.cmd("NvimTreeOpen") -- 确保命令名称正确
	end

	-- 检查 Aerial 是否打开
	if g_is_tagbar_open == true then
		vim.cmd("AerialOpen") -- 确保命令名称正确
	end

	-- -- 检查 Avante 是否打开
	-- if g_is_avante_open == true then
	-- 	vim.cmd("") -- 确保命令名称正确
	-- end

	-- if g_is_avante_open == true or g_is_tagbar_open == true or g_is_avante_open == true then
	-- 	vim.defer_fn(
	-- 	function()
	-- 		jump_to_file_window()
	-- 		-- vim.cmd("wincmd p") -- 切换到上一个窗口
	-- 		-- close_dap_repl_buffers()
	-- 	end,
	-- 	5
	-- 	)

	-- end

    g_is_nvimtree_open = false
    g_is_tagbar_open = false
end

-----------------------------------------------------------------
-- 配置 GDB 以将输出重定向到新建TMUX终端窗口
-----------------------------------------------------------------
function terminate_tmux_split_and_get_pty()
	if tmux_split_pty == nil then
		return
	end
	local cmd =
		string.format(
		'tmux list-windows -F "#{window_id}" | while read win_id;' ..
			' do tmux list-panes -t $win_id -F "#{pane_tty} #{pane_id}" | grep "^/dev/pts/";' ..
				'done | grep %s | cut -d" " -f2 | xargs -I {} tmux kill-pane -t {};',
		tmux_split_pty
	)
	vim.fn.system(cmd)
	tmux_split_pty = nil

	vim.api.nvim_del_keymap("n", "<leader>dk")
end


local function close_windows()
	vim.cmd("cclose")
	vim.cmd("AerialClose")
	vim.cmd("NvimTreeClose")
end

----------------------------------------------------------------------
-- 水平分屏后切换到右侧 Pane：
-- tmux split-window -h -P -F '#{pane_tty}' \; select-pane -R
--
-- 垂直分屏后切换到下方 Pane：
-- tmux split-window -v -P -F '#{pane_tty}' \; select-pane -D
--
-- 水平分屏后切换到左侧 Pane：
-- tmux split-window -h -P -F '#{pane_tty}' \; select-pane -L
----------------------------------------------------------------------
--
local function create_tmux_split_and_get_pty()
	close_windows()
	terminate_tmux_split_and_get_pty()

	-- 创建一个新的 tmux 分屏，大小为当前窗口的三分之一
	local split_cmd = "tmux split-window -h -p 33 -c '#{pane_current_path}' 'sh'" -- 水平分屏，使用 -v 垂直分屏
	vim.fn.system(split_cmd)

	-- 获取新分屏的 pty 路径
	local pty_cmd = "tmux display-message -p '#{pane_tty}'; tmux select-pane -R"
	local pty = vim.fn.system(pty_cmd):gsub("\n", "") -- 去除换行符
	tmux_split_pty = pty
	return pty
end

local function get_debug_option(case)
	if vim.g.build_bin_path == nil or vim.fn.filereadable(vim.g.build_bin_path) == 0 then
		if vim.fn.isdirectory(vim.g.build_dir) == 1 then
			vim.g.build_bin_path = vim.fn.input("Path to executable: ", vim.g.build_dir .. "/", "file")
		else
			vim.g.build_bin_path = vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
		end
	elseif debug_args == nil then
		debug_args = vim.fn.input("Debug args: ", "-", "file")
	end

	if case == nil then
		print("Can not get debug option, case is nil")
	elseif case == "path" then
		return vim.g.build_bin_path
	elseif case == "args" then
		-- print(debug_args)
		return {debug_args}
	end
	return nil
end

-----------------------------------------------------------------
-- CPP调试配置
-----------------------------------------------------------------
--
-- 配置 CPP 调试
dap.configurations.cpp = {
	{
		name = "Launch",
		type = function()
            if vim.g.is_unix == 1 then
				dap.adapters.lldb = {
					type = 'executable',
					command = '/usr/bin/lldb-dap', -- adjust as needed, must be absolute path
					name = 'lldb',
				}
                return 'lldb'
            else
				dap.adapters.gdb = {
					id = 'gdb',
					type = 'executable',
					command =  vim.fn.getenv("gdb_path") .. '\\gdb.exe',
						args = {
							"-iex", "source " .. vim.fn.stdpath("config") .. "\\.gdbinit",
							"--interpreter=dap",
							"--eval-command",
							"set print pretty on",
						}
				}
				-- dap.adapters.cppdbg = {
				-- 	id = 'cppdbg',
				-- 	type = 'executable',
				-- 	command = vim.fn.getenv("DEVELOP_BASE") .. 'cpptools-windows-x64\\extension\\debugAdapters\\bin\\OpenDebugAD7.exe',
				-- 	options = {
				-- 		detached = false
				-- 	}
				-- }
				-- dap.adapters.codelldb = {
				-- 	id = 'codelldb',
				-- 	type = 'executable',
				-- 	command = vim.fn.getenv("DEVELOP_BASE") .. 'codelldb-win32-x64\\extension\\adapter\\codelldb.exe',
				-- 	options = {
				-- 		detached = false
				-- 	}
				-- }
                return 'gdb'
            end
        end,
		request = "launch",
		program = function()
			return get_debug_option("path")
		end,
		args = function()
			return get_debug_option("args")
		end,
		cwd = "${workspaceFolder}",
		-- stopAtBeginningOfMainSubprogram = true,
		-- runInTerminal = true, -- 若为false输出内容则不再console窗口中
        runInTerminal = (vim.g.is_unix == 1) and true or false, -- Windows 上可能需要关闭此选项
		MIDebuggerPath = function()
            if vim.g.is_unix == 1 then
				return''
			else
				return vim.fn.getenv("DEVELOP_BASE") .. 'gdb\\bin\\gdb.exe'
			end
		end,
		setupCommands = {
			{
				text = "-enable-pretty-printing",
				description = "enable pretty printing",
				ignoreFailures = false
			}
		},
		externalConsole = (vim.g.is_unix == 1) and false or true,
		-- stdio = pty,
	}
}
dap.configurations.c = dap.configurations.cpp

-----------------------------------------------------------------
-- 配置 Python 调试
-----------------------------------------------------------------
if vim.g.is_unix == 1 then
	require("dap-python").setup("python3")
else
	require("dap-python").setup("python")
end
dap.configurations.python = {
	{
		type = "python",
		request = "launch",
		name = "Launch file",
		program = function()
			return get_debug_option("path")
		end,
		pythonPath = function()
			return (vim.g.is_unix == 1) and "python3" or "python"
		end,
		-- In linux maybe not externalTerminal!!
	    console = 'externalTerminal', -- 关键参数：externalTerminal/integratedTerminal/internalConsole
		justMyCode = true,
	}
}

-----------------------------------------------
-- 调试函数定义
-----------------------------------------------
---
local function setup_debug_keymaps()
	if vim.g.debuger_short == true then
		return
	else
		vim.g.debuger_short = true
	end
	-- 设置调试快捷键
	original_K_mapping = vim.fn.maparg("K", "n")
	vim.api.nvim_set_keymap("n", "<F5>", '<cmd>lua require("dap").continue()<CR>', {noremap = true, silent = true})
	vim.api.nvim_set_keymap("n", "<F8>", '<cmd>lua require("dap").step_over()<CR>', {noremap = true, silent = true})
	vim.api.nvim_set_keymap("n", "<F7>", '<cmd>lua require"dap".step_into()<CR>', {noremap = true, silent = true})
	vim.api.nvim_set_keymap("n", "I", '<cmd>lua require"dapui".eval()<CR>', {noremap = true, silent = true})

    -- 杀死调试器
    vim.api.nvim_set_keymap("n", "<leader>dk", "<cmd>lua close_debug_session()<CR>", {noremap = true, silent = true}) 
    -- 杀死调试器
--     vim.api.nvim_set_keymap(
--         "n",
--         "<leader>dK",
--         "<cmd>lua terminate_tmux_split_and_get_pty(); close_debug_session(); <CR>",
--         {noremap = true, silent = true}
-- )
end

local function clear_debug_keymaps()
	if vim.g.debuger_short == false then
		return
	else
		vim.g.debuger_short = false
	end
	-- 恢复 K 的原始映射
	-- 删除调试快捷键
	vim.api.nvim_del_keymap("n", "<F5>")
	vim.api.nvim_del_keymap("n", "<F7>")
	vim.api.nvim_del_keymap("n", "<F8>")
	vim.api.nvim_del_keymap("n", "I")
	vim.api.nvim_del_keymap("n", "<leader>dk")
    -- vim.api.nvim_set_keymap("n", "<leader>dk", "<cmd>lua terminate_tmux_split_and_get_pty()<CR>", {noremap = true, silent = true}) 
	-- vim.api.nvim_del_keymap("n", "<leader>dK")
end

function start_debug_session()
	save_window_status()
	close_windows()

	------------------------------------------------
	-- cpp 单独设置UI配置项
	------------------------------------------------
	local filetype = vim.bo.filetype
	if vim.g.g_dapui_closed == nil and (filetype == "c" or filetype == "cpp") then
		local btm_win_elements = {
			{ id = "repl", size = 1 }, -- REPL 窗口，占 100% 高度
		}

		local btm_unix_elements = {
			{ id = "repl", size = 0.5 },			-- REPL 窗口，占 50% 高度
			{ id = "console", size = 0.5 },			-- 控制台窗口，占 50% 高度
		}

		require("dapui").setup(
			{
				layouts = {
					{
						elements = {
							{id = "breakpoints", size = 0.25}, -- 断点窗口，占 25% 宽度
							{id = "stacks", size = 0.25}, -- 调用栈窗口，占 25% 宽度
							{id = "watches", size = 0.20}, -- 监视窗口，占 25% 宽度
							{id = "scopes", size = 0.30}, -- 作用域窗口，占 25% 宽度
						},
						size = 40, -- 左侧总宽度为 40 列
						position = "left" -- 左侧显示
					},
					{
						elements = vim.g.is_unix == 1 and btm_unix_elements or btm_win_elements,
						size = vim.g.is_unix == 1 and 20 or 25, -- 底部总高度为 10 行
						position = "bottom" -- 底部显示
					}
				}
			}
		)
		vim.g.is_dapui_inited = true
	elseif g_dapui_closed == false then
		vim.g.is_dapui_inited = true
		default_dapui()
	end

	require("dap").continue()
	print('Debugger is running ...')
end
function start_debug_session_new()
	vim.g.build_bin_path = nil
	debug_args = nil
	start_debug_session()
end

function close_debug_session()
	clear_debug_keymaps()
	-- 获取 dap 和 dapui 模块
	local dap = require("dap")
	local dapui = require("dapui")

	-- 关闭当前 DAP 会话
	if dap.session() then
		dap.terminate() -- 终止调试会话
		dapui.close() -- 关闭调试器
        restore_window()
	end

	-- 关闭 dap-ui 的界面
	if g_dapui_closed == false then
		dapui.close()
		g_dapui_closed = true
	end


end

-----------------------------------------------
-- 快捷键映射
-----------------------------------------------
--
-- 断点快捷键
vim.api.nvim_set_keymap("n", "<F9>", '<cmd>lua require"dap".toggle_breakpoint()<CR>', {noremap = true, silent = true})
-- 只跳转到下一个错误
vim.api.nvim_set_keymap(
	"n",
	"]e",
	"<cmd>lua vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })<CR>",
	{noremap = true, silent = true}
)
-- 只跳转到上一个错误
vim.api.nvim_set_keymap(
	"n",
	"[e",
	"<cmd>lua vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })<CR>",
	{noremap = true, silent = true}
)
-- 只跳转到下一个警告
vim.api.nvim_set_keymap(
	"n",
	"]d",
	"<cmd>lua vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.WARN })<CR>",
	{noremap = true, silent = true}
)
-- 只跳转到上一个警告
vim.api.nvim_set_keymap(
	"n",
	"[d",
	"<cmd>lua vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.WARN })<CR>",
	{noremap = true, silent = true}
)
 -- 启动调试器
vim.api.nvim_set_keymap("n", "<leader>dr", "<cmd>lua start_debug_session()<CR>", {noremap = true, silent = true})

-- 启动调试器，重新输入被调试程序的路径
vim.api.nvim_set_keymap("n", "<leader>dR", "<cmd>lua start_debug_session_new()<CR>", {noremap = true, silent = true})
 
-- 断点列表
vim.api.nvim_set_keymap("n", "<leader>db", ":Telescope dap list_breakpoints<CR>", {noremap = true, silent = true}) -- 断点列表
-- 命令列表
vim.api.nvim_set_keymap("n", "<leader>dc", ":Telescope dap commands<CR>", {noremap = true, silent = true}) -- DAP 命令列表
-- 关闭输入输出窗口
-- vim.api.nvim_set_keymap(
-- 	"n",
-- 	"<leader>dq",
-- 	"<cmd>lua terminate_tmux_split_and_get_pty()<CR>",
-- 	{noremap = true, silent = true}
-- )

-----------------------------------------------
-- 调试器事件监听
-----------------------------------------------
---
-- 监听调试器启动事件
dap.listeners.after.event_initialized["dapui_config"] = function()
	setup_debug_keymaps() -- 设置快捷键
	dapui.open() -- 打开 dapui
	g_dapui_closed = false
end

-- 监听调试器终止事件
dap.listeners.before.event_terminated["dapui_config"] = function()
	close_debug_session()
end

-- 监听调试器退出事件
dap.listeners.before.event_exited["dapui_config"] = function()
	close_debug_session()
end

-------------------------------
-- 定义 LSP 诊断图标
-------------------------------
vim.api.nvim_create_autocmd(
	"BufEnter",
	{
		pattern = "*",
		once = true,
		callback = function()
			-- 确保在设置高亮之前，主题已经切换好了，不然高亮失效
			vim.cmd("highlight clear DapBreakpointTextDap")
			vim.cmd("highlight clear DapRunToCusorDap")
			vim.cmd("highlight DapRunToCusorDap guifg=yellow ctermfg=yellow")
			vim.cmd("highlight DapBreakpointTextDap guifg=red ctermfg=red")

			vim.fn.sign_define("DiagnosticSignError", {text = "✗", texthl = "DiagnosticSignError"}) -- 错误
			vim.fn.sign_define("DiagnosticSignWarn", {text = "‼", texthl = "DiagnosticSignWarn"}) -- 警告
			vim.fn.sign_define("DiagnosticSignInfo", {text = "⬥", texthl = "DiagnosticSignInfo"}) -- 信息
			vim.fn.sign_define("DiagnosticSignHint", {text = "★", texthl = "DiagnosticSignHint"}) -- 提示

			vim.fn.sign_define("DapBreakpoint", {text = "✹", texthl = "DapBreakpointTextDap", linehl = "", numhl = ""})
			vim.fn.sign_define("DapStopped", {text = "➔", texthl = "DapRunToCusorDap", linehl = "", numhl = ""})
			vim.fn.sign_define("DapBreakpointRejected", {text = "◉", texthl = "DapBreakpointTextDap", linehl = "", numhl = ""}) -- 无效断点
			vim.fn.sign_define("DapBreakpointResolved", {text = "✓>", texthl = "DapBreakpointTextDap", linehl = "", numhl = ""}) -- 已解析断点
		end
	}
)
