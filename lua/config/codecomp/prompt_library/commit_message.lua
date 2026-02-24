local M = {
    interaction = "chat",
    description = "000 Generate a commit message",
    opts = {
        index = 10,
        is_default = true,
        is_slash_cmd = true,
        alias = "commit",
        auto_submit = true,
        is_workflow = true,
    },
    prompts = {
        {
            role = "user",
            content = function()
                return string.format(
[[你是一位遵循 Conventional Commit 规范的专家。请根据下面列出的 git diff 内容，为我生成一个提交信息。
内容不可以包含任何提交消息以外的内容！:

```diff
%s
```
]],
vim.fn.system("git diff --no-ext-diff")
                )
            end,
            opts = {
                contains_code = true,
            },
        },
    },
} 

return M
