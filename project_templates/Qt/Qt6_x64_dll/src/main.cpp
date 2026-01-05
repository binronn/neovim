#include "example_export.h"
#include "mainwindow.h"
#include <QApplication>
#include <QWidget>

// DLL入口点 - 创建MainWindow实例
extern "C" EXAMPLE_EXPORT QWidget* createMainWindow(QWidget* parent = nullptr)
{
    return new MainWindow(parent);
}

// DLL入口点 - 获取MainWindow类名
extern "C" EXAMPLE_EXPORT const char* getMainWindowClassName()
{
    return "MainWindow";
}

// DLL入口点 - 获取库版本
extern "C" EXAMPLE_EXPORT const char* getLibraryVersion()
{
    return "1.0.0";
}

// 如果需要，可以保留原来的main函数用于测试
#ifdef EXAMPLE_BUILD_TEST
#include <QApplication>

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);
    MainWindow mainWindow;
    mainWindow.show();
    return app.exec();
}
#endif
