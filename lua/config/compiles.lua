local M = {}

local clangd_param_base = {
			"clangd", 
			"--background-index=true",
			"--clang-tidy",
			"--compile-commands-dir=build",
			-- "--completion-style=detailed",  -- 增强补全信息
			'--pch-storage=disk',
			'--completion-style=bundled',
			-- "--header-insertion=never"      -- 禁用自动头文件插入
		}


-- Initialize paths only if they haven't been set before
if not M.cc_path then
    M.cc_path = 'clang' .. (vim.g.is_win32 == 1 and '.exe' or '')
end
if not M.cxx_path then
    M.cxx_path = 'clang++' .. (vim.g.is_win32 == 1 and '.exe' or '')
end

if not M.clangd_path then
	M.clangd_param = clangd_param_base
end

if vim.g.is_win32 == 0 then
	return M
end

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


local function file_exists(path)
  local file = io.open(path, "r")
  if file then
    file:close()
    return true
  else
    return false
  end
end

local function set_compiler_paths(toolchain_path, cxx_name)
    local bin_dir = toolchain_path .. '\\bin\\'
    M.cxx_path = bin_dir .. cxx_name
    -- Determine corresponding C compiler based on C++ compiler choice
    if cxx_name == 'clang++.exe' then
        M.cc_path = bin_dir .. 'clang.exe'
    elseif cxx_name == 'clang-cl.exe' then
        M.cc_path = bin_dir .. 'clang-cl.exe'
    elseif cxx_name == 'g++.exe' then
        M.cc_path = bin_dir .. 'gcc.exe'
    else
        -- Fallback or other future compilers
        if cxx_name:find("clang") then
            M.cc_path = bin_dir .. 'clang.exe'
        else
            M.cc_path = bin_dir .. 'gcc.exe'
        end
    end
    if not file_exists(M.cc_path) then
        vim.notify("Warning: C compiler not found at " .. M.cc_path, vim.log.levels.WARN)
    end
end
local function update_clang_llvm_version(toolchain_path, cxx_name)
    set_compiler_paths(toolchain_path, cxx_name)

    local query_driver = M.cxx_path
    if vim.bo.filetype == 'c' then
        query_driver = M.cc_path
    end

    M.clangd_param = vim.deepcopy(clangd_param_base)
    M.clangd_param[1] = 'clangd'
    M.clangd_path = 'clangd'
    table.insert(M.clangd_param, '--query-driver=' .. query_driver)

    local success, result = pcall(require, "config.lsp")
    if success then
        require('config.lsp').switch_clangd(M.clangd_path, query_driver)
    end
end

local function detect_compilers(toolchain_path)
    local bin_dir = toolchain_path .. '\\bin\\'
    local candidates = {}
    local has_clang_cpp = file_exists(bin_dir .. "clang++.exe")
    local has_clang_cl = file_exists(bin_dir .. "clang-cl.exe")
    local has_gpp = file_exists(bin_dir .. "g++.exe")
    if has_clang_cpp then
        table.insert(candidates, "clang++.exe")
    end
    if has_clang_cl then
        table.insert(candidates, "clang-cl.exe")
    end
    -- If clang++ exists, we assume g++ is just an alias/copy and ignore it.
    -- We only include g++ if clang++ is NOT present.
    if has_gpp and not has_clang_cpp then
        table.insert(candidates, "g++.exe")
    end
    return candidates
end

local function show_compiler_variant_picker(toolchain_path, variants)
    require('telescope.pickers').new({}, {
        prompt_title = 'Select C++ Compiler Variant',
        finder = require('telescope.finders').new_table {
            results = variants,
        },
        sorter = require('telescope.sorters').get_generic_fuzzy_sorter(),
        attach_mappings = function(prompt_bufnr, map)
            map('i', '<CR>', function()
                local selection = require("telescope.actions.state").get_selected_entry()
                require("telescope.actions").close(prompt_bufnr)
                if selection then
                    update_clang_llvm_version(toolchain_path, selection.value)
                    vim.notify("Selected compiler: " .. selection.value .. " from " .. toolchain_path, vim.log.levels.INFO)
                end
            end)
            return true
        end,
    }):find()
end
-- 注册 comps 命令
vim.api.nvim_create_user_command(
    "Comps",
    function()
        -- 检查当前缓冲区文件类型
        local filetype = vim.bo.filetype
        local valid_filetypes = {"cpp", "cxx", "hpp", "h", "c"}
        -- 如果当前文件类型不在允许的列表中，显示提示并返回
        if not vim.tbl_contains(valid_filetypes, filetype) then
            vim.notify("Comps command is only available for cpp/cxx/hpp/h/c files", vim.log.levels.WARN)
            return
        end
        require('telescope.pickers').new({}, {
            prompt_title = 'Select a Compiler Toolchain',
            finder = require('telescope.finders').new_table {
                results = get_compilers(),
            },
            sorter = require('telescope.sorters').get_generic_fuzzy_sorter(),
            attach_mappings = function(prompt_bufnr, map)
                map('i', '<CR>', function()
                    local selection = require("telescope.actions.state").get_selected_entry()
                    require("telescope.actions").close(prompt_bufnr)
                    if selection then
                        local p = compils_path .. '\\' .. selection.value
                        local variants = detect_compilers(p)
                        if #variants == 0 then
                            vim.notify("No supported compilers (clang++/clang-cl/g++) found in " .. p .. "\\bin", vim.log.levels.WARN)
                        elseif #variants == 1 then
                            update_clang_llvm_version(p, variants[1])
                            vim.notify("Selected compiler: " .. variants[1] .. " from " .. p, vim.log.levels.INFO)
                        else
                            -- Multiple variants found, ask user to choose
                            -- Schedule this to run after the current picker closes to avoid conflicts
                            vim.defer_fn(function() 
                                show_compiler_variant_picker(p, variants)
                            end, 10)
                        end
                    end
                end)
                return true
            end,
        }):find()
    end,
    {}
)

return M
