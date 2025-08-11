local autocmd = vim.api.nvim_create_autocmd
local vim = vim

local keymap = require("keymap_help")
local nmap = keymap.nmap

----------------------------------------------------------------
--- 构建cpp项目函数
----------------------------------------------------------------
local function get_compiler_config()
    return {
        cc = require('config.compiles_cfg').cc_path,
        cxx = require('config.compiles_cfg').cxx_path
    }
end

local function get_build_command(build_dir, cmd)
    -- local make_cmd = vim.g.is_win32 == 1 and 'mingw32-make' or 'make'
    -- return string.format('cd "%s" && %s', build_dir, cmd:gsub("make", make_cmd))
	
    return string.format('cd "%s" && make', build_dir)
end

local function setup_cmake_build(build_dir, compile_command)
    local param = vim.g.is_cmake_debug and ' -DCMAKE_BUILD_TYPE=Debug -DCMAKE_CXX_FLAGS="-O0 -g" -DCMAKE_C_FLAGS="-O0 -g"' or ' -DCMAKE_BUILD_TYPE=Release' 
    
    local compilers = get_compiler_config()
    local cmake_pam = vim.g.is_win32 == 0 
        and ('-DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ ' .. param)
        or (' -G "MinGW Makefiles" -DCMAKE_C_COMPILER=' .. compilers.cc .. 
            ' -DCMAKE_CXX_COMPILER=' .. compilers.cxx .. param)

    local cmd = 'cmake ' .. cmake_pam .. ' -DCMAKE_EXPORT_COMPILE_COMMANDS=ON ..'
    if compile_command then
        cmd = cmd .. ' && make'
    end
    
    return get_build_command(build_dir, cmd)
end


function RunCmdHiddenWithPause(command)

    -- Construct the full command to start a new, minimized cmd window that runs the command and then pauses.
    local full_command = 'cmd.exe /c start /min cmd.exe /c "'..command..' & pause"'

    vim.fn.jobstart(full_command, {
        detach = true, -- Crucial for preventing resource leaks.
        on_exit = function(_, code)
            if code == 0 then
                print("Build command completed successfully.")
            else
                print("Build command failed with exit code: " .. code)
            end
        end
    })
end


function RunCmdHiddenWithPause2(command)
    -- 构造完整的cmd命令（添加pause）
    local full_command = 'start "" /min cmd /c "'..command..' & pause"'
    
    vim.fn.system(full_command)
    
    -- vim.defer_fn(function()
    --     print(command)
    -- end, 1)
end

function build_project(compile_command)
    local wsdir = vim.g.workspace_dir2()
    local is_win32 = vim.g.is_win32 == 1

    -- Check build systems
    local cmake_path = wsdir .. "/CMakeLists.txt"
    local makefile_path = wsdir .. "/Makefile"
	local build_dir = vim.g.is_cmake_debug and (wsdir .. "/build") or (wsdir .. "/build_release")
    local build_makefile = build_dir .. "/Makefile"

    local function run_command(cmd)
		-- RunCmdHiddenWithPause(cmd)
		require('FTerm').run(cmd)
        -- local width = math.floor(vim.o.columns * 0.3)
        -- local height = math.floor(vim.o.lines * 0.3)
        -- 
        -- local buf = vim.api.nvim_create_buf(false, true)
        -- local win = vim.api.nvim_open_win(buf, true, {
        --     relative = 'editor',
        --     width = width,
        --     height = height,
        --     col = (vim.o.columns - width) / 2,
        --     row = (vim.o.lines - height) / 2,
        --     style = 'minimal',
        --     border = 'single'
        -- })
        -- 
        -- vim.api.nvim_buf_set_keymap(buf, 'n', 'q', ':q<CR>', {noremap = true, silent = true})
        -- vim.fn.termopen(cmd)
        -- vim.cmd('startinsert')
    end

    -- if compile_command and vim.fn.isdirectory(build_dir) == 1 then
    --     vim.fn.delete(build_dir, "rf")
    -- end

    if vim.fn.isdirectory(build_dir) == 1 and vim.fn.filereadable(build_makefile) == 1 and compile_command then
        run_command(get_build_command(build_dir, "make"))
    elseif vim.fn.filereadable(cmake_path) == 1 then
        if vim.fn.isdirectory(build_dir) == 0 then
            vim.fn.mkdir(build_dir, "p")
        end
        run_command(setup_cmake_build(build_dir, compile_command))
        vim.g.build_dir = build_dir
    elseif vim.fn.filereadable(makefile_path) == 1 then
        local cmd = compile_command and 'compiledb --output compile_commands.json make' or 'make'
        run_command(get_build_command(wsdir, cmd))
        vim.g.build_dir = wsdir
    else
        local file = vim.fn.expand("%:p")
        local ext = vim.fn.expand("%:e")
        local compilers = get_compiler_config()
        
        if ext == "cpp" then
            run_command(compilers.cxx .. ' -g "' .. file .. '" -o "' .. wsdir .. '/main"')
        elseif ext == "c" then
            run_command(compilers.cc .. ' -g "' .. file .. '" -o "' .. wsdir .. '/main"')
        else
            print("Unsupported file type. Only .c and .cpp files are supported.")
            return
        end
        vim.g.build_dir = wsdir
    end
end

function build_project_bin()
	if vim.g.is_cmake_debug == nil then
		vim.g.is_cmake_debug = true
	end
	build_project(true)
end

function build_project_release_sym()
	vim.g.is_cmake_debug = false
	build_project(false)
end

function build_project_sym()
	vim.g.is_cmake_debug = true
	build_project(false)
end

----------------------------------------------------------------
--- 弃用
----------------------------------------------------------------
vim.api.nvim_create_autocmd(
	"BufEnter",
	{
		-- 自动添加工作区
		pattern = "*.cpp,*.h,*.py,CMakeLists.txt",
		callback = function()
			-- vim.lsp.buf.add_workspace_folder(vim.fn.getcwd())  -- 添加工作区目录
		end
	}
)

----------------------------------------------------------------
-- CPP 文件启用:
--  调试
--  构建
----------------------------------------------------------------
vim.api.nvim_create_autocmd(
	"BufEnter",
	{
		pattern = {"*.h", "*.hpp", "*.cxx", "*.c", "*.cpp"}, -- 匹配的文件类型
		callback = function()

			vim.api.nvim_create_user_command(
				"Cb",
				function()
					build_project_bin()
				end,
				{bang = true}
			)

			vim.api.nvim_create_user_command(
				"Cg",
				function()
					build_project_sym()
				end,
				{bang = true}
			)
			vim.api.nvim_create_user_command(
				"Cgr",
				function()
					build_project_release_sym()
				end,
				{bang = true}
			)
			-- vim.keymap.set("n", "<leader>wbd", build_project_bin, {noremap = true, silent = true, buffer = true})
			-- vim.keymap.set("n", "<leader>wbg", build_project_sym, {noremap = true, silent = true, buffer = true})
		end
	}
)


------------------------------------------------------------------------------------------
-- 格式化代码 null-ls
------------------------------------------------------------------------------------------
-- vim.api.nvim_create_autocmd(
-- 	"FileType",
-- 	{
-- 		pattern = "lua", -- 仅对 Lua 文件生效
-- 		callback = function()
-- 			nmap("<leader>ff", ":lua vim.lsp.buf.format()<CR>")
-- 		end
-- 	}
-- )

----------------------------------------------------------------
-- 设置Windows路径分隔符 && buflist_filter
----------------------------------------------------------------
vim.api.nvim_create_autocmd(
	"BufWinEnter",
	{
		pattern = "*",
		callback = function()
			----------------------------------------------------------------
			-- buflist_filter quickfix窗口不会出现在缓冲区列表里, bp bn 将不会滚动到quikfix窗口
			----------------------------------------------------------------
			---
			if vim.bo.buftype == 'quickfix' then
				vim.bo.buflisted = false
			end

			----------------------------------------------------------------
			-- 解决Windows下路径分隔符 \\ / 不一致的问题
			----------------------------------------------------------------
			---
			vim.schedule(
				function()
					if vim.g.is_win32 == 1 then
						vim.opt.shellslash = true
					end
					vim.opt.laststatus = 3
				end
			)

		end
	}
)

----------------------------------------------------------------
-- 关闭 codecompanion 的行号
----------------------------------------------------------------
-- 为特定文件类型（这里是python）设置局部选项来关闭行号和相对行号
-- vim.api.nvim_create_autocmd("BufReadPost", 
-- {
-- 	-- pattern = "codecompanion",
-- 	callback = function()
-- 		if vim.bo.filetype == 'codecompanion' then
-- 			vim.cmd('setlocal nonumber norelativenumber')
-- 		end
-- 	end,
-- })

----------------------------------------------------------------
-- 首次进入设置工作目录
----------------------------------------------------------------
vim.api.nvim_create_autocmd(
"BufReadPost", -- 修改为在缓冲区加载完成之后执行
{
	once = true,
	pattern = "*",
	callback = function()

			vim.schedule(
				function()
					-- vim.g.reset_workspace_dir_nop()
					vim.g.workspace_dir.get()
					vim.fn.chdir(vim.g.workspace_dir.get())
					-- vim.g.generate_ctags(true)
					vim.notify('Workdir: ' .. vim.g.workspace_dir.get(), vim.log.levels.INFO, { title = 'Workspace Setup' })
				end
				-- 1000
				)
		end
	}
)

----------------------------------------------------------------
-- 在 Vim 启动时执行 generate_ctags 函数
----------------------------------------------------------------
-- vim.cmd(
-- 	[[
-- augroup GenerateCtags
--     autocmd!
--     autocmd VimEnter * lua vim.schedule(function()vim.g.generate_ctags(true)end) 
-- augroup END
-- ]]
-- )

----------------------------------------------------------------
-- 主题切换部分设置重新设置
----------------------------------------------------------------
vim.api.nvim_create_autocmd(
	"ColorScheme",
	{
		callback = function()
			vim.schedule(
				function()
					if vim.g.is_win32 == 1 then
						vim.opt.shellslash = true -- 解决Windows下路径分隔符 \\ / 不一致的问题
					end
					vim.opt.laststatus = 3
				end
			)
		end
	}
)

------------------------------------------
-- 定义文件格式化函数
------------------------------------------
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'lua',
    callback = function(args)
        -- 获取当前buffer的ID
        local bufnr = args.buf

        -- 检查npx和lua-fmt是否存在
        if vim.fn.executable('npx') == 0 then
            vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ff', '', {
                noremap = true,
                silent = true,
                callback = function()
                    vim.notify('npx not found! Please install npm first', vim.log.levels.ERROR)
                end
            })
            return
        end

        local handle = io.popen('npx --no-install lua-fmt --version 2>&1')
        local result = handle:read('*a')
        handle:close()

        if not result:match('^%d+%.%d+%.%d+') then
            vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ff', '', {
                noremap = true,
                silent = true,
                callback = function()
                    vim.notify('lua-fmt not found! Please install with: npm install -g lua-fmt', vim.log.levels.ERROR)
                end
            })
            return
        end

        -- 仅对当前buffer设置按键映射
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ff', ':%!npx lua-fmt --use-tabs --stdin<CR>', {noremap = true, silent = true})

            vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ff', '', {
                noremap = true,
                silent = true,
                callback = function()
                    local cursor_pos = vim.api.nvim_win_get_cursor(0)
                    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
                    local formatted = vim.fn.systemlist(':%!npx lua-fmt --use-tabs --stdin<CR>', lines)
                    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, formatted)
                    vim.api.nvim_win_set_cursor(0, cursor_pos)
                end
            })
    end,
})

vim.api.nvim_create_autocmd('FileType', {
    pattern = {'c', 'cpp', 'h', 'hpp', 'json'},
    callback = function(args)
        local bufnr = args.buf
        -- local config_path = vim.fn.expand('$HOME/.config/nvim/.clang-format')
		local config_path = vim.fn.stdpath("config") .. "/.clang-format"
        local cwd_config = vim.g.workspace_dir2()..'/.clang-format'

        if vim.fn.executable('clang-format') == 0 then
            vim.notify('clang-format not found! Please install clang-format', vim.log.levels.ERROR)
            return
        end

        local effective_config = vim.fn.filereadable(cwd_config) == 1 and cwd_config or
                               vim.fn.filereadable(config_path) == 1 and config_path or nil

        if not effective_config then
            vim.notify('No clang-format config found (checked: '..cwd_config..' and '..config_path..')', vim.log.levels.WARN)
        else
            vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ff', '', {
                noremap = true,
                silent = true,
                callback = function()
                    local cursor_pos = vim.api.nvim_win_get_cursor(0)
                    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
                    local formatted = vim.fn.systemlist('clang-format -style=file:'..vim.fn.shellescape(effective_config), lines)
                    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, formatted)
                    vim.api.nvim_win_set_cursor(0, cursor_pos)
                end
            })
        end
    end,
})


----------------------------------------------------------------
-- Session保存与恢复
----------------------------------------------------------------
function SaveCurrentSession()
	local wsdir = vim.g.workspace_dir2()
	local session_file_path = wsdir .. "/Session.vim"

	vim.cmd("AerialClose")
	vim.cmd("NvimTreeClose")

	for _, win in ipairs(vim.api.nvim_list_wins()) do
		local buf = vim.api.nvim_win_get_buf(win)
		if vim.api.nvim_buf_get_option(buf, "filetype") == "Avante" then
			vim.cmd("AvanteToggle")
			break
		end
	end

	local function jmp_active_buffers()
		local all_windows = vim.api.nvim_list_wins()
		for _, win_id in ipairs(all_windows) do
			local bufnr = vim.api.nvim_win_get_buf(win_id)
			vim.api.nvim_command("buffer " .. bufnr)
			break
		end
	end
	jmp_active_buffers()

	vim.cmd("mksession! " .. session_file_path)

	-- Check for Avante window and append 'AvanteToggle' to the session file if it exists
	-- local avante_toggle_added = false
	-- local file = io.open(session_file_path, "a")
	-- for _, win in ipairs(vim.api.nvim_list_wins()) do
	-- 	local buf = vim.api.nvim_win_get_buf(win)
	-- 	if vim.api.nvim_buf_get_option(buf, "filetype") == "Avante" then
	-- 		file:write("\nAvanteChat")
	-- 	elseif vim.api.nvim_buf_get_option(buf, "filetype") == "NvimTree" then
	-- 		file:write("\n lua vim.g.toggle_nvimtree()")
	-- 	elseif vim.api.nvim_buf_get_option(buf, "filetype") == "aerial" then
	-- 		file:write("\n vim.g.toggle_tagbar()")
	-- 	end
	-- end
	-- file:close()
	
	-- local mark_name = wsdir:gsub("[:/\\ \\.]", "_") .. "_Session"
	-- local mark_name = vim.g.hash_djb2(session_file_path)
	-- print(mark_namd)
	-- vim.cmd("silent MarkSave")
	vim.notify("Session saved to: " .. session_file_path, vim.log.levels.INFO, { title = 'Session' })
end

-- 注册加载会话的命令
function LoadSavedSession()
	local wsdir = vim.g.workspace_dir2()
	local session_file_path = wsdir .. "/Session.vim"
	if vim.fn.filereadable(session_file_path) == 1 then

		-- vim.cmd("silent! MarkLoad")
		vim.cmd("source " .. session_file_path)
		vim.notify("Session loaded from: " .. session_file_path, vim.log.levels.INFO, { title = 'Session' })
	else
		vim.notify("No session file found at: " .. session_file_path, vim.log.levels.INFO, { title = 'Session' })
	end
end

-- 注册command用于保存和加载会话
vim.api.nvim_create_user_command('Ss', SaveCurrentSession, {desc = 'Abbreviation command to save the current session', bang = true})
vim.api.nvim_create_user_command('Sq', function()
	SaveCurrentSession()
	vim.cmd('q')
end, {desc = 'Abbreviation command to save the current session', bang = true})
vim.api.nvim_create_user_command('Ls', LoadSavedSession, {desc = 'Abbreviation command to load a saved session', bang = true})
