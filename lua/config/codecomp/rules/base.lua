
local function get_rule_base_path()
    return vim.fn.stdpath("config") .. "/lua/config/codecomp/rules/"
end

--- 自动扫描规则目录，生成规则表
--- 每个子目录作为一个规则 key，子目录下所有 .md 文件作为 files
local function build_rules()
    local base = get_rule_base_path()
    local rules = {
        -- opts = {
        --     chat = {
        --         autoload = "default",
        --         enable = true
        --     }
        -- },
        project_rules = {
            description = "",
            files = {
                -- get_rule_base_path() .. 'memory/base.md',
                get_rule_base_path() .. 'bigfile/base.md',
                get_rule_base_path() .. 'project_big/base.md',
                get_rule_base_path() .. 'analysis/base.md',
            }
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

local project_rules2 = {
    project_rules = {
        description = "综合规则：项目分析 + 大文件 + 问题分析",
        files = {
            get_rule_base_path() .. 'project_analysis/base.md',
            get_rule_base_path() .. 'bigfile/base.md',
            get_rule_base_path() .. 'analysis/base.md',
        }
    },
    project_analysis = {
        description = "大型项目分析：上下文收集 → 深度分析 → 回应",
        files = {
            get_rule_base_path() .. 'project_analysis/base.md',
        }
    },
    memory = {
        description = "长期记忆：架构决策、任务状态、用户偏好、环境信息",
        files = {
            get_rule_base_path() .. 'memory/base.md',
        }
    },
    bigfile = {
        description = "大文件处理：定向查找、按需读取、禁止全量加载",
        files = {
            get_rule_base_path() .. 'bigfile/base.md',
        }
    },
    analysis = {
        description = "问题分析修复：审查 → 确认 → 验证",
        files = {
            get_rule_base_path() .. 'analysis/base.md',
        }
    },
    python = {
        description = "Python 开发规范：风格、类型、文档、测试",
        files = {
            get_rule_base_path() .. 'python/base.md',
        }
    }
}

return project_rules2

