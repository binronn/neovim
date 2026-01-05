local M = {}

-- 1. 定义模板所在的绝对路径
local template_dir = vim.fn.stdpath('config') .. '/project_templates'

-- 辅助函数：判断是否为目录
local function is_dir(path)
    return vim.fn.isdirectory(path) == 1
end

function M.create_project()
    -- 检查根目录是否存在
    if not is_dir(template_dir) then
        vim.notify("模板目录不存在: " .. template_dir, vim.log.levels.ERROR)
        return
    end

    local template_list = {}

    -- 2. 第一层循环：扫描类别 (例如 cpp, python)
    local categories = vim.fn.readdir(template_dir, function(name)
        return is_dir(template_dir .. '/' .. name) and not name:match("^%.")
    end)

    for _, category in ipairs(categories) do
        local category_path = template_dir .. '/' .. category

        -- 3. 第二层循环：扫描具体模板 (例如 main, dllmain)
        local variants = vim.fn.readdir(category_path, function(name)
            return is_dir(category_path .. '/' .. name) and not name:match("^%.")
        end)

        for _, variant in ipairs(variants) do
            -- 组合成 "cpp/main" 这样的字符串放入列表
            table.insert(template_list, category .. '/' .. variant)
        end
    end

    if #template_list == 0 then
        vim.notify("未找到任何二级项目模板", vim.log.levels.WARN)
        return
    end

    vim.ui.select(template_list, {
        prompt = "🚀 选择项目模板 (Category/Template):",
    }, function(selected)
        if not selected then return end

        local src_path = template_dir .. '/' .. selected
        local dest_path = vim.fn.getcwd()
        
        -- 提前判断系统类型
        local is_windows = vim.fn.has('win32') == 1
        local cmd

        if is_windows then
            -- Windows: 使用 robocopy
            -- 参数说明：
            -- /E : 复制子目录，包括空的
            -- /NFL /NDL /NJH /NJS /nc /ns /np : 静默模式，不输出大量日志
            cmd = string.format('robocopy "%s" "%s" /E /NFL /NDL /NJH /NJS /nc /ns /np', src_path:gsub('/', '\\'), dest_path:gsub('/', '\\'))
        else
            -- Linux/Mac: cp
            cmd = string.format('cp -r "%s/." "%s"', src_path, dest_path)
        end

        vim.notify("正在从 [" .. selected .. "] 生成项目...", vim.log.levels.INFO)

        -- 执行命令
        -- 注意：os.execute 在 Neovim LuaJIT 中通常直接返回状态码 (number)
        local result_code = os.execute(cmd)

        -- 判断成功逻辑
        local success = false
        if is_windows then
            -- Robocopy: 返回值 < 8 都代表成功 (1代表成功复制文件)
            if result_code and result_code < 8 then
                success = true
            end
        else
            -- Linux/Mac (cp): 返回值 0 代表成功
            if result_code == 0 then
                success = true
            end
        end

        if success then
            vim.notify("✅ 项目初始化成功！", vim.log.levels.INFO)
            vim.defer_fn(function()
                vim.cmd("Telescope find_files")
            end, 200) -- 200ms 延时
        else
            vim.notify("❌ 复制失败，错误码: " .. tostring(result_code), vim.log.levels.ERROR)
        end
    end)
end

return M
