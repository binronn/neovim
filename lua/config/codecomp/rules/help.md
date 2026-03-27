## 规则文件编写指南

### 1. 规则文件格式
规则文件可以是多种格式：
- **Markdown 文件**（推荐）
- **纯文本文件**
- **mdc 文件**（Cursor 编辑器格式）
- **Claude 专用格式**

### 2. 基本结构示例

#### 示例 1：使用 `codecompanion` 解析器
```markdown
# 规则文件标题

## System Prompt

此部分内容将作为系统提示词发送给 AI。
您可以在这里指定：
- 项目特定的指令
- 编码规范
- 行为约束
- 其他指导原则

## 其他部分

@./path/to/your/file.lua

此部分内容将作为上下文添加到聊天缓冲区。
上面的文件路径也会被包含进来。
```

#### 示例 2：使用 `claude` 解析器
```markdown
# Claude 规则文件

@./path/to/your/file.lua

这是 Claude 解析器可以处理的规则文件。
文件中的所有内容都会作为上下文添加到聊天缓冲区。
包括上面指定的文件。
```

### 3. 关键特性

1. **系统提示词**：在 `## System Prompt` 部分的内容会作为 AI 的系统指令
2. **文件引用**：使用 `@` 符号后跟文件路径来包含其他文件
3. **自由格式**：除了系统提示词部分，其他内容可以自由组织

### 4. 文件位置
规则文件可以放在：
- 项目根目录（如 `CLAUDE.md`）
- 用户主目录（如 `~/.claude/CLAUDE.md`）
- 任意自定义位置

### 5. 配置规则组
在 Neovim 配置中定义规则组：
```lua
require("codecompanion").setup({
  rules = {
    default = {
      description = "默认规则组",
      files = {
        "CLAUDE.md",                    -- 简单路径
        { path = "AGENT.md", parser = "claude" },  -- 指定解析器
        "~/.config/my_rules.md",        -- 绝对路径
      },
    },
  },
})
```

### 6. 使用方式
- **自动加载**：配置 `autoload` 在打开聊天缓冲区时自动加载
- **手动添加**：使用 `/rules` 命令或 Action Palette
- **清除规则**：使用 `gR` 快捷键

**建议下一步**：您可以尝试创建一个简单的规则文件，比如在项目根目录创建 `CLAUDE.md`，然后测试它如何影响聊天交互。
