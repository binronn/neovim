#include <QApplication>
#include <QWidget>
#include <QLabel>
#include <QVBoxLayout>
#include <QPushButton>
#include <QMessageBox>
#include <iostream>

// 声明DLL函数
extern "C" QWidget* createMainWindow(QWidget* parent = nullptr);
extern "C" const char* getMainWindowClassName();
extern "C" const char* getLibraryVersion();

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);
    
    // 创建主窗口
    QWidget mainWindow;
    mainWindow.setWindowTitle("Qt6 DLL Test Application");
    mainWindow.resize(400, 300);
    
    // 创建布局
    QVBoxLayout *layout = new QVBoxLayout(&mainWindow);
    
    // 添加标签显示信息
    QLabel *infoLabel = new QLabel("Qt6 DLL Test Application");
    infoLabel->setAlignment(Qt::AlignCenter);
    QFont font = infoLabel->font();
    font.setPointSize(16);
    infoLabel->setFont(font);
    layout->addWidget(infoLabel);
    
    // 添加DLL信息
    QLabel *dllInfoLabel = new QLabel();
    dllInfoLabel->setAlignment(Qt::AlignCenter);
    layout->addWidget(dllInfoLabel);
    
    // 创建按钮来测试DLL功能
    QPushButton *testButton = new QPushButton("Test DLL Functions");
    layout->addWidget(testButton);
    
    QPushButton *createWindowButton = new QPushButton("Create MainWindow from DLL");
    layout->addWidget(createWindowButton);
    
    QPushButton *quitButton = new QPushButton("Quit");
    layout->addWidget(quitButton);
    
    // 连接按钮信号
    QObject::connect(testButton, &QPushButton::clicked, [&]() {
        try {
            const char* className = getMainWindowClassName();
            const char* version = getLibraryVersion();
            
            dllInfoLabel->setText(QString("DLL Info:\nClass: %1\nVersion: %2")
                                 .arg(className)
                                 .arg(version));
            
            QMessageBox::information(&mainWindow, "DLL Test", 
                QString("Successfully called DLL functions!\n"
                       "Class name: %1\n"
                       "Library version: %2")
                .arg(className)
                .arg(version));
        } catch (...) {
            QMessageBox::critical(&mainWindow, "Error", 
                "Failed to call DLL functions. Make sure the DLL is loaded correctly.");
        }
    });
    
    QObject::connect(createWindowButton, &QPushButton::clicked, [&]() {
        try {
            QWidget* dllWindow = createMainWindow();
            if (dllWindow) {
                dllWindow->setWindowTitle("MainWindow from DLL");
                dllWindow->show();
                QMessageBox::information(&mainWindow, "Success", 
                    "MainWindow created successfully from DLL!");
            } else {
                QMessageBox::warning(&mainWindow, "Warning", 
                    "Failed to create MainWindow from DLL.");
            }
        } catch (...) {
            QMessageBox::critical(&mainWindow, "Error", 
                "Exception occurred while creating window from DLL.");
        }
    });
    
    QObject::connect(quitButton, &QPushButton::clicked, &app, &QApplication::quit);
    
    mainWindow.show();
    
    return app.exec();
}