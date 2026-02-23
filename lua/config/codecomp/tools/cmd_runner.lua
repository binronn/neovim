local helpers = require("codecompanion.interactions.chat.tools.builtin.helpers")
local os_utils = require("codecompanion.utils.os")
local utils = require("codecompanion.utils")

local fmt = string.format

---@class CodeCompanion.Tool.CmdRunner: CodeCompanion.Tools.Tool
return {
    name = "cmd_runner",
    description = "Run shell commands on the user's system",
    callback = {
        name = "cmd_runner",
        cmds = {
            ---@param self CodeCompanion.Tool.CmdRunner
            ---@param args table The arguments from the LLM's tool call
            ---@param input? any The output from the previous function call
            ---@return nil|{ status: "success"|"error", data: string }
            function(self, args, input)
                local cmd = args.cmd

                -- Validate input
                if not cmd or cmd == "" then
                    return { status = "error", data = "Command is missing or empty" }
                end

                -- Detect current OS
                local is_windows = vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1
                local os_name = is_windows and "Windows" or "Linux"

                -- Platform-specific cmd execution
                local handle
                if is_windows then
                    -- Windows: use cmd.exe for compatibility
                    handle = io.popen('cmd.exe /C "' .. cmd .. '" 2>&1')
                else
                    -- Linux/Unix: use sh with stderr redirection
                    handle = io.popen(cmd .. " 2>&1")
                end

                if not handle then
                    return { status = "error", data = "Failed to execute cmd" }
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
        schema = {
            type = "function",
            ["function"] = {
                name = "cmd_runner",
                description = "Run shell commands on the user's system, sharing the output with the user before then sharing with you.",
                parameters = {
                    type = "object",
                    properties = {
                        cmd = {
                            type = "string",
                            description = "The command to run, e.g. `pytest` or `make test`",
                        },
                    },
                    required = {
                        "cmd",
                    },
                    additionalProperties = false,
                },
                strict = true,
            },
        },
        system_prompt = fmt(
            [[# Command Runner Tool (`cmd_runner`)

            ## CONTEXT
            - You have access to a command runner tool running within CodeCompanion, in Neovim.
            - You can use it to run shell commands on the user's system.
            - You may be asked to run a specific command or to determine the appropriate command to fulfil the user's request.
            - All tool executions take place in the current working directory %s.

            ## OBJECTIVE
            - Follow the tool's schema.
            - Respond with a single command, per tool execution.

            ## RESPONSE
            - Only invoke this tool when the user specifically asks.
            - If the user asks you to run a specific command, do so to the letter, paying great attention.
            - Use this tool strictly for command execution; but file operations must NOT be executed in this tool unless the user explicitly approves.
            - To run multiple commands, you will need to call this tool multiple times.

            ## SAFETY RESTRICTIONS
            - Never execute the following dangerous commands under any circumstances:
            - `rm -rf /` or any variant targeting root directories
            - `rm -rf ~` or any command that could wipe out home directories
            - `rm -rf .` without specific context and explicit user confirmation
            - Any command with `:(){:|:&};:` or similar fork bombs
            - Any command that would expose sensitive information (keys, tokens, passwords)
            - Commands that intentionally create infinite loops
            - For any destructive operation (delete, overwrite, etc.), always:
            1. Warn the user about potential consequences
            2. Request explicit confirmation before execution
            3. Suggest safer alternatives when available
            - If unsure about a command's safety, decline to run it and explain your concerns

            ## POINTS TO NOTE
            - This tool can be used alongside other tools within CodeCompanion

            ## USER ENVIRONMENT
            - Shell: %s
            - Operating System: %s
            - Neovim Version: %s]],
            vim.fn.getcwd(),
            vim.o.shell,
            utils.capitalize(os_utils.get_os()),
            vim.version().major .. "." .. vim.version().minor .. "." .. vim.version().patch
        ),
        handlers = {
            ---@param self CodeCompanion.Tool.CmdRunner
            ---@param tool CodeCompanion.Tools The tool object
            setup = function(self, tool)
                -- 可以在这里进行初始化，但不需要修改 cmds
                -- vim.notify("cmd_runner setup called", vim.log.levels.INFO)
            end,
        },

        output = {
            ---Returns the command that will be executed
            ---@param self CodeCompanion.Tool.CmdRunner
            ---@param args { tools: CodeCompanion.Tools }
            ---@return string
            cmd_string = function(self, args)
                return self.args.cmd
            end,

            ---Prompt the user to approve the execution of the command
            ---@param self CodeCompanion.Tool.CmdRunner
            ---@param tool CodeCompanion.Tools
            ---@return string
            prompt = function(self, tool)
                return fmt("Run the command `%s`?", self.args.cmd)
            end,

            ---Rejection message back to the LLM
            ---@param self CodeCompanion.Tool.CmdRunner
            ---@param tools CodeCompanion.Tools
            ---@param cmd table
            ---@param opts table
            ---@return nil
            rejected = function(self, tools, cmd, opts)
                local message = fmt("The user rejected the execution of the `%s` command", self.args.cmd)
                opts = vim.tbl_extend("force", { message = message }, opts or {})
                helpers.rejected(self, tools, cmd, opts)
            end,

            ---@param self CodeCompanion.Tool.CmdRunner
            ---@param tool CodeCompanion.Tools
            ---@param cmd table
            ---@param stderr table The error output from the command
            -- error = function(self, tool, cmd, stderr)
            --     local chat = tool.chat
            --     local errors = vim.iter(stderr):flatten():join("\n")

            --     local output = [[%s
            --     ```txt
            --     %s
            --     ```]]

            --     local llm_output = fmt(output, fmt("There was an error running the `%s` command:", cmd.cmd), errors)
            --     local user_output = fmt(output, fmt("`%s` error", cmd.cmd), errors)

            --     chat:add_tool_output(self, llm_output, user_output)
            -- end,

            ---@param self CodeCompanion.Tool.CmdRunner
            ---@param tool CodeCompanion.Tools
            ---@param cmd table The command that was executed
            ---@param stdout table The output from the command
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
}
