
local function get_rule_base_path()
    return vim.fn.stdpath("config") .. "/lua/config/codecomp/rules/"
end

return {
    opts = {
        chat = {
            -- autoload = {'bigfile'}
        }
    },
    python = {
        description = 'Python rules',
        files = {
            get_rule_base_path() .. 'python/base.md'
        }
    },
    memory = {
        description = 'Memory rules',
        files = {
            get_rule_base_path() .. 'memory/base.md'
        }
    },
    bigfile = {
        description = 'Big file read rules',
        files = {
            get_rule_base_path() .. 'bigfile/base.md'
        }
    }
}
