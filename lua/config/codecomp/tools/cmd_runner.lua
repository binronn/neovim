local M = {
    description = "Execute shell commands",
    callback = {
        name = "cmd_runner",
        cmds = {
            ---@param self CodeCompanion.Tool.CmdRunner The CmdRunner tool
            ---@param args table The arguments from the LLM's tool call
            ---@param input? any The output from the previous function call
            ---@return nil|{ status: "success"|"error", data: string }
            function(self, args, input)
                local command = args.command

                -- Validate input
                if not command or command == "" then
                    return { status = "error", data = "Command is missing or empty" }
                end

                -- Detect current OS
                local is_windows = vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1
                local os_name = is_windows and "Windows" or "Linux"

                -- Platform-specific command execution
                local handle
                if is_windows then
                    -- Windows: use cmd.exe for compatibility
                    handle = io.popen('cmd.exe /C "' .. command .. '" 2>&1')
                else
                    -- Linux/Unix: use sh with stderr redirection
                    handle = io.popen(command .. " 2>&1")
                end

                if not handle then
                    return { status = "error", data = "Failed to execute command" }
                end

                local result = handle:read("*a")
                handle:close()

                if result then
                    -- Trim trailing newlines
                    result = result:gsub("%s+$", "")
                    return { status = "success", data = result }
                else
                    return { status = "success", data = "Command executed (no output)" }
                end
            end,
        },
        system_prompt = function()
            -- Detect current OS at runtime
            local is_windows = vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1
            local os_name = is_windows and "Windows" or "Linux"
            local shell_info = is_windows
                    and "You are running on **Windows**. Use Windows Command Prompt (cmd.exe) commands. Avoid Unix-specific commands."
                    or "You are running on **Linux/Unix**. Use bash/shell commands."

            return [[## CmdRunner Tool (`cmd_runner`)

## CONTEXT
- You have access to a command execution tool running within CodeCompanion, in Neovim.
- You can use it to execute shell commands on the user's machine.
- ]] .. shell_info .. [[

### OBJECTIVE
- Execute shell commands when the user asks for it or when you need to run system commands

### RESPONSE
- Always use the structure above for consistency.
- Be careful with destructive commands.
- Prefer safe, read-only commands unless explicitly requested otherwise.
- Use ]] .. os_name .. [[-compatible commands only.
]]
        end,

        schema = {
            type = "function",
            ["function"] = {
                name = "cmd_runner",
                description = "Execute shell commands on the user's machine",
                parameters = {
                    type = "object",
                    properties = {
                        command = {
                            type = "string",
                            description = "The shell command to execute",
                        },
                    },
                    required = {
                        "command",
                    },
                    additionalProperties = false,
                },
                strict = true,
            },
        },
        env = function()
            return {}
        end,
        handlers = {
            ---@param self CodeCompanion.Tool.CmdRunner
            ---@param tools CodeCompanion.Tools The tool object
            setup = function(self, tools)
                -- return vim.notify("CmdRunner: setup function called", vim.log.levels.INFO)
            end,
            ---@param self CodeCompanion.Tool.CmdRunner
            ---@param tools CodeCompanion.Tools
            on_exit = function(self, tools)
                -- return vim.notify("CmdRunner: on_exit function called", vim.log.levels.INFO)
            end,
        },
        output = {
            ---@param self CodeCompanion.Tool.CmdRunner
            ---@param tools CodeCompanion.Tools
            ---@param cmd table The command that was executed
            ---@param stdout table|nil
            success = function(self, tools, cmd, stdout)
                local chat = tools.chat
                local output = stdout and table.concat(stdout, "\n") or "Command executed successfully (no output)"
                return chat:add_tool_output(self, output)
            end,
            ---@param self CodeCompanion.Tool.CmdRunner
            ---@param tools CodeCompanion.Tools
            ---@param cmd table
            ---@param stderr table|nil The error output from the command
            error = function(self, tools, cmd, stderr)
                local chat = tools.chat
                local err_msg = stderr and table.concat(stderr, "\n") or "Unknown error occurred"
                return chat:add_tool_output(self, "Error: " .. err_msg)
                -- return vim.notify("CmdRunner: " .. err_msg, vim.log.levels.ERROR)
            end,
        },
    },
    opts = {
        require_approval_before = true,
    },
}

return M
