# Python 开发规则

## 代码风格

- PEP 8 规范，4 空格缩进
- 行长度 88 字符（Black 默认）
- 字符串用双引号

## 类型注解

- 所有函数参数和返回值使用类型注解
- `from __future__ import annotations`（Python 3.9+）
- 使用 `typing` 泛型（List, Dict, Optional 等）

## 文档字符串

Google 风格，所有公共模块/函数/类/方法必须包含：
```python
def process_data(data: list[dict]) -> dict:
    """处理数据并返回结果。

    Args:
        data: 输入数据列表。

    Returns:
        处理后的结果字典。

    Raises:
        ValueError: 输入为空时抛出。
    """
```

## 导入规范

标准库 → 第三方库 → 本地模块，分组空行分隔，优先绝对导入：
```python
import os
import sys
from pathlib import Path

import requests
from pydantic import BaseModel

from myproject.utils import helper
```

## 错误处理

- 使用具体异常类型，避免裸 `except:`
- 自定义异常继承 `Exception`

## 函数设计

- 单一职责，参数不超过 5 个
- 避免可变对象作为默认参数

## 类设计

- `@dataclass` 简化数据类
- 优先组合而非继承
- 私有属性用单下划线前缀

## 性能

- 列表推导式、生成器表达式
- 大数据集用生成器
- `lru_cache` 缓存重复计算

## 测试

- pytest，目标覆盖率 80%+
- 测试函数 `test_` 开头
- `pytest.mark.parametrize` 参数化测试
