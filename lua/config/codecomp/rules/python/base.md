# Python 开发规则

## 代码风格

- 遵循 PEP 8 规范
- 使用 4 个空格缩进，不使用 Tab
- 行长度限制在 88 个字符（Black 格式化器默认）
- 使用双引号表示字符串，除非字符串内部包含双引号

## 类型注解

- 对所有函数参数和返回值使用类型注解
- 使用 `from __future__ import annotations` 以支持 Python 3.9+ 的类型语法
- 使用 `typing` 模块中的泛型类型（List, Dict, Optional 等）

## 文档字符串

- 所有公共模块、函数、类和方法都必须包含文档字符串
- 使用 Google 风格的文档字符串格式
- 示例：
  ```python
  def process_data(data: list[dict]) -> dict:
      """处理数据并返回结果。

      Args:
          data: 输入数据列表，每个元素是一个字典。

      Returns:
          处理后的结果字典。

      Raises:
          ValueError: 当输入数据为空时抛出。
      """
      if not data:
          raise ValueError("数据不能为空")
      return {"result": data}
  ```

## 导入规范

- 导入顺序：标准库 → 第三方库 → 本地模块
- 每个分组之间用空行分隔
- 使用绝对导入而非相对导入
- 示例：
  ```python
  import os
  import sys
  from pathlib import Path

  import requests
  from pydantic import BaseModel

  from myproject.utils import helper
  ```

## 错误处理

- 使用具体的异常类型，避免裸 `except:`
- 使用 `try/except/else/finally` 结构时保持清晰
- 自定义异常应继承自 `Exception` 或其子类

## 函数设计

- 函数应遵循单一职责原则
- 参数数量建议不超过 5 个，过多时使用数据类或字典
- 避免使用可变对象作为默认参数值

## 类设计

- 使用 `@dataclass` 简化数据类定义
- 优先使用组合而非继承
- 私有属性和方法使用单下划线前缀

## 性能考虑

- 使用列表推导式和生成器表达式替代循环
- 对于大数据集，使用生成器而非列表
- 使用 `lru_cache` 缓存重复计算结果

## 测试

- 使用 `pytest` 进行单元测试
- 测试函数名以 `test_` 开头
- 使用 `pytest.mark.parametrize` 进行参数化测试
- 目标代码覆盖率不低于 80%

## 工具推荐

- 运行：`uv`

