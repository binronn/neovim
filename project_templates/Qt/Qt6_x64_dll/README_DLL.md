# Qt6 DLL 项目转换说明

## 项目概述

此项目已从 Qt6 Widget 可执行程序转换为 Qt6 动态链接库 (DLL)。转换包括以下主要更改：

## 主要更改

### 1. CMake 配置更改
- 将 `qt_add_executable` 改为 `qt_add_library` 创建共享库
- 添加了 DLL 导出属性 (`WINDOWS_EXPORT_ALL_SYMBOLS`)
- 设置了库版本信息
- 添加了导出宏定义 (`example_EXPORTS`)

### 2. 代码更改
- 创建了 `example_export.h` 导出宏头文件
- 为 `MainWindow` 类添加了 `EXAMPLE_EXPORT` 宏
- 将 `main.cpp` 改为 DLL 入口点函数
- 添加了工厂函数用于创建窗口实例

### 3. 新增文件
- `src/example_export.h` - DLL 导出宏定义
- `test/test_dll.cpp` - 测试程序演示如何使用 DLL
- `test/CMakeLists.txt` - 测试程序的构建配置
- `README_DLL.md` - 本说明文档

## 构建说明

### 构建 DLL

```bash
mkdir build
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
cmake --build .
```

### 构建测试程序

```bash
cd test
mkdir build
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
cmake --build .
```

## DLL 接口

DLL 提供了以下 C 接口函数：

### `createMainWindow(QWidget* parent)`
- **功能**: 创建 MainWindow 实例
- **参数**: parent - 父窗口指针（可选）
- **返回**: 创建的 MainWindow 指针

### `getMainWindowClassName()`
- **功能**: 获取 MainWindow 类名
- **返回**: 类名字符串

### `getLibraryVersion()`
- **功能**: 获取库版本
- **返回**: 版本字符串

## 使用示例

### C++ 中使用 DLL

```cpp
#include <QApplication>
#include <QWidget>

// 声明DLL函数
extern "C" QWidget* createMainWindow(QWidget* parent = nullptr);
extern "C" const char* getMainWindowClassName();
extern "C" const char* getLibraryVersion();

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);
    
    // 创建窗口
    QWidget* window = createMainWindow();
    window->setWindowTitle("Window from DLL");
    window->show();
    
    return app.exec();
}
```

### 动态加载 DLL (Windows)

```cpp
#include <windows.h>
#include <QApplication>
#include <QWidget>

typedef QWidget* (*CreateMainWindowFunc)(QWidget*);
typedef const char* (*GetClassNameFunc)();
typedef const char* (*GetVersionFunc)();

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);
    
    // 加载DLL
    HINSTANCE hDll = LoadLibrary(TEXT("example.dll"));
    if (!hDll) {
        // 错误处理
        return -1;
    }
    
    // 获取函数指针
    CreateMainWindowFunc createFunc = 
        (CreateMainWindowFunc)GetProcAddress(hDll, "createMainWindow");
    GetClassNameFunc classNameFunc = 
        (GetClassNameFunc)GetProcAddress(hDll, "getMainWindowClassName");
    GetVersionFunc versionFunc = 
        (GetVersionFunc)GetProcAddress(hDll, "getLibraryVersion");
    
    if (createFunc && classNameFunc && versionFunc) {
        // 使用DLL功能
        QWidget* window = createFunc();
        window->show();
        
        qDebug() << "Class name:" << classNameFunc();
        qDebug() << "Library version:" << versionFunc();
    }
    
    // 清理
    FreeLibrary(hDll);
    
    return app.exec();
}
```

## 注意事项

1. **导出符号**: 所有需要从 DLL 导出的类都必须使用 `EXAMPLE_EXPORT` 宏
2. **资源文件**: UI 文件和资源文件会自动包含在 DLL 中
3. **内存管理**: 由 DLL 创建的对象应在同一模块中删除
4. **Qt 版本**: 确保使用相同版本的 Qt 构建和使用 DLL

## 测试

项目包含一个测试程序 (`test/test_dll.cpp`) 演示如何：
1. 调用 DLL 函数获取信息
2. 创建 MainWindow 实例
3. 处理可能的错误

## 扩展建议

1. 添加更多工厂函数创建不同类型的窗口
2. 实现插件系统架构
3. 添加版本兼容性检查
4. 实现配置接口
5. 添加日志和错误处理机制