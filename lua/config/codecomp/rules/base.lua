
local function get_rule_base_path()
    return vim.fn.stdpath("config") .. "/lua/config/codecomp/rules/"
end

--- 自动扫描规则目录，生成规则表
--- 每个子目录作为一个规则 key，子目录下所有 .md 文件作为 files
local function build_rules()
    local base = get_rule_base_path()
    local rules = {
        opts = {
            chat = {}
        }
    }

    -- 扫描所有子目录
    local subdirs = vim.fn.glob(base .. "*/", false, true)
    for _, dir in ipairs(subdirs) do
        -- 取子目录名作为 key
        local name = vim.fn.fnamemodify(dir, ":h:t")
        -- 扫描该子目录下所有 .md 文件
        local md_files = vim.fn.glob(dir .. "*.md", false, true)
        if #md_files > 0 then
            rules[name] = {
                description = name .. " rules",
                files = md_files,
            }
        end
    end

    return rules
end

return build_rules()

