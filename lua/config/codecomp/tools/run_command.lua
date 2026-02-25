local cmd_tool = require("codecompanion.interactions.chat.tools.builtin.cmd_tool")
local helpers = require("codecompanion.interactions.chat.tools.builtin.helpers")
local os_utils = require("codecompanion.utils.os")

local fmt = string.format

-- 自定义的 execute_shell_command 实现
local function execute_shell_command(cmd, callback)
  -- if vim.fn.has("win32") == 1 then
  --   -- Windows 平台处理
  --   local shell_cmd = table.concat(cmd, " ") .. "\r\nEXIT %ERRORLEVEL%\r\n"
  --   vim.system({ "cmd.exe", "/Q", "/K" }, {
  --     stdin = shell_cmd,
  --     env = { PROMPT = "\r\n" },
  --   }, callback)
  -- else
    -- Unix/Linux 平台处理
    vim.system(os_utils.build_shell_command(cmd), {}, callback)
  -- end
end

---@class CodeCompanion.Tool.RunCommand: CodeCompanion.Tools.Tool
return cmd_tool({
  name = "run_command",
  description = "Run shell commands on the user's system, sharing the output with the user before then sharing with you.",
  opts = { require_approval_before = true, },
  schema = {
    properties = {
      cmd = {
        type = "string",
        description = "The command to run, e.g. `pytest` or `make test`",
      },
      flag = {
        anyOf = {
          { type = "string" },
          { type = "null" },
        },
        description = 'If running tests, set to `"testing"`; null otherwise',
      },
    },
    required = {
      "cmd",
      "flag",
    },
  },
  build_cmd = function(args)
    return args.cmd
  end,
  handlers = {
    ---@param self CodeCompanion.Tool.RunCommand
    ---@param meta { tools: CodeCompanion.Tools }
    setup = function(self, meta)
      local args = self.args

      -- 创建自定义的命令执行函数
      local cmd_array = vim.split(args.cmd, " ", { trimempty = true })
      local flag = args.flag
      
      local function custom_cmd_executor(tools, _, opts)
        local cb = vim.schedule_wrap(opts.output_cb)
        execute_shell_command(cmd_array, function(out)
          if flag then
            tools.chat.tool_registry.flags = tools.chat.tool_registry.flags or {}
            tools.chat.tool_registry.flags[flag] = (out.code == 0)
          end

          local eol_pattern = vim.fn.has("win32") == 1 and "\r?\n" or "\n"

          if out.code == 0 then
            -- 成功处理
            local stdout_lines = vim.split(out.stdout, eol_pattern, { trimempty = true })
            -- 移除 ANSI 颜色代码
            for i, line in ipairs(stdout_lines) do
              stdout_lines[i] = line:gsub("\027%[[0-9;]*%a", "")
            end
            cb({
              status = "success",
              data = stdout_lines,
            })
          else
            -- 错误处理
            local combined = {}
            if out.stderr and out.stderr ~= "" then
              local stderr_lines = vim.split(out.stderr, eol_pattern, { trimempty = true })
              for _, line in ipairs(stderr_lines) do
                table.insert(combined, line:gsub("\027%[[0-9;]*%a", ""))
              end
            end
            if out.stdout and out.stdout ~= "" then
              local stdout_lines = vim.split(out.stdout, eol_pattern, { trimempty = true })
              for _, line in ipairs(stdout_lines) do
                table.insert(combined, line:gsub("\027%[[0-9;]*%a", ""))
              end
            end
            cb({ status = "error", data = combined })
          end
        end)
      end

      table.insert(self.cmds, custom_cmd_executor)
    end,
  },
  output = {
    ---Returns the command that will be executed
    ---@param self CodeCompanion.Tool.RunCommand
    ---@param meta { tools: CodeCompanion.Tools }
    ---@return string
    cmd_string = function(self, meta)
      return self.args.cmd
    end,

    ---@param self CodeCompanion.Tool.RunCommand
    ---@param meta {tools: CodeCompanion.Tools}
    ---@return string
    prompt = function(self, meta)
      return fmt("Run the command `%s`?", self.args.cmd)
    end,

    ---Rejection message back to the LLM
    ---@param self CodeCompanion.Tool.RunCommand
    ---@param meta {tools: CodeCompanion.Tools, cmd: string, opts: table}
    ---@return nil
    rejected = function(self, meta)
      local message = fmt("The user rejected the execution of the `%s` command", self.args.cmd)
      meta = vim.tbl_extend("force", { message = message }, meta or {})
      helpers.rejected(self, meta)
    end,
  },
})
