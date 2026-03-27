return {
    servers = {
        ["ida-pro-mcp"] = {
            cmd = { "C:\\SoftFolder\\develop_env\\python3\\python.exe",
            "C:\\SoftFolder\\develop_env\\python3\\Lib\\site-packages\\ida_pro_mcp\\server.py",
            "--ida-rpc", "http://127.0.0.1:13337" },
            tool_overrides = {
                divide = {
                    opts = {
                        require_approval_before = false,
                    },
                },
            },
        }
    }
}
