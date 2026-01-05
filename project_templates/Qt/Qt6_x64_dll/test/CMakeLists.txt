cmake_minimum_required(VERSION 3.16)

project(example_test VERSION 1.0)

# 设置Qt路径
set(CMAKE_PREFIX_PATH "$ENV{QT_BASE}/x64/release")

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

# 查找Qt6
find_package(Qt6 COMPONENTS Widgets REQUIRED)

# 添加测试可执行文件
add_executable(example_test test_dll.cpp)

# 设置C++标准
set_target_properties(example_test
    PROPERTIES
        CXX_STANDARD 17
        CXX_STANDARD_REQUIRED ON
)

# 链接Qt库
target_link_libraries(example_test Qt6::Widgets)

# 添加包含目录（指向DLL的头文件）
target_include_directories(example_test PRIVATE ${CMAKE_SOURCE_DIR}/src)

# 在Windows上，需要链接DLL的导入库
if(WIN32)
    # 假设DLL已经构建，链接导入库
    target_link_libraries(example_test ${CMAKE_SOURCE_DIR}/build/example.lib)
    
    # 复制DLL到测试程序目录
    add_custom_command(TARGET example_test POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different
            ${CMAKE_SOURCE_DIR}/build/example.dll
            $<TARGET_FILE_DIR:example_test>/
        COMMENT "Copying example.dll to test executable directory"
    )
endif()

# 安装目标
install(TARGETS example_test RUNTIME DESTINATION bin)