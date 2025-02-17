local M = {}
M.cc_path = 'clang.exe'
M.cxx_path = 'clang++.exe'

-- 获取环境变量 COMPILS 的路径
local compils_path = os.getenv("COMPILERS")
if not compils_path then
	vim.notify("COMPILS environment variable is not set", vim.log.levels.ERROR)
	return M
end

-- 读取 COMPILS 路径下的所有目录
local function get_compilers()
	local compilers = {}
	local handle = io.popen('dir "' .. compils_path .. '" /b /ad')
	if handle then
		for line in handle:lines() do
			table.insert(compilers, line)
		end
		handle:close()
	end
	return compilers
end

-- 设置默认编译器
-- local compilers = get_compilers()
-- local default_compiler = compilers[1] or ""
-- M.current_compiler = default_compiler

local function update_clang_llvm_version(clangd_path)
	M.cxx_path = clangd_path .. '\\bin\\clang++.exe'
	M.cc_path = clangd_path .. '\\bin\\clang.exe'
	local clangd_path = clangd_path .. '\\bin\\clangd.exe'

	local success, result = pcall(require, "config.lsp_cfg")
	if success == true then

		vim.notify("Selected clangd: " .. clangd_path, vim.log.levels.INFO)
		require('config.lsp_cfg').reset_clangdex(clangd_path)
	end

	success, result = pcall(require, "cmake-tools")
	if success == true then
		require('config.plugins_cfg').cmake_tools_init(cc_path, cxx_path)
	end

end

-- 注册 comps 命令
vim.api.nvim_create_user_command(
"Comps",
function()
	require('telescope.pickers').new({}, {
		prompt_title = 'Select a Compiler',
		finder = require('telescope.finders').new_table {
			results = get_compilers(),
		},
		sorter = require('telescope.sorters').get_generic_fuzzy_sorter(),
		attach_mappings = function(prompt_bufnr, map)
			map('i', '<CR>', function()
				local selection = require("telescope.actions.state").get_selected_entry()
				if selection then
					local p = compils_path .. '\\' .. selection.value
					update_clang_llvm_version(p)
					vim.notify("Selected compiler: " .. p, vim.log.levels.INFO)
				end
				require("telescope.actions").close(prompt_bufnr)
			end)
			return true
		end,
	}):find()
end,
{}
)

return M
