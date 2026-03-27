return {
    servers = {
        ["ida-pro-mcp"] = {
            cmd = {
                "C:\\Program Files\\IDA Professional 9.3\\Python313\\python.exe",
                "C:\\Program Files\\IDA Professional 9.3\\Python313\\Lib\\site-packages\\ida_pro_mcp\\server.py",
                "--ida-rpc",
                "http://127.0.0.1:13337"
            },
            tool_overrides = {
                divide = {
                    opts = {
                        require_approval_before = false,
                    },
                },
            },
        },
        ["MiniMax"] = {
            cmd = { "uvx", "minimax-coding-plan-mcp", "-y" },
        }
    }
}
