cmake_minimum_required(VERSION 3.16)
project(example VERSION 1.0)

# Add folder where are supportive functions
set(CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake)
set(CMAKE_INCLUDE_CURRENT_DIR ON)

# Set the path to your Qt installation
if(CMAKE_BUILD_TYPE STREQUAL "Debug")
	set(CMAKE_PREFIX_PATH "$ENV{QT_BASE}/x64/debug")
elseif(CMAKE_BUILD_TYPE STREQUAL "Release")
	set(CMAKE_PREFIX_PATH "$ENV{QT_BASE}/x64/release")
else()
	set(CMAKE_PREFIX_PATH "$ENV{QT_BASE}/x64/release")
endif()

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

# Include Qt basic functions
include(QtCommon)

# Set PROJECT_VERSION_PATCH and PROJECT_VERSION_TWEAK to 0 if not present, needed by add_project_meta
fix_project_version()

# Set additional project information
set(COMPANY "Example")
set(COPYRIGHT "Copyright (c) 2014 Vincent Lee. All rights reserved.")
set(IDENTIFIER "com.example.Example")

set(SOURCE_FILES
    src/main.cpp
    src/mainwindow.cpp
)

add_project_meta(META_FILES_TO_INCLUDE)

set(RESOURCE_FILES ${PROJECT_NAME}.qrc)

find_package(Qt6 COMPONENTS Widgets REQUIRED)

qt_standard_project_setup()

# add_executable(${PROJECT_NAME} WIN32 MACOSX_BUNDLE
#     ${SOURCE_FILES} ${META_FILES_TO_INCLUDE} ${RESOURCE_FILES}
# )

if(CMAKE_BUILD_TYPE STREQUAL "Debug")
	# 添加 qDebug() << .. 输出内容支持
	# Debug 模式，创建控制台程序
	message(STATUS "Creating a CONSOLE application for Debug build.")
	qt_add_executable(${PROJECT_NAME} 
		${SOURCE_FILES} ${META_FILES_TO_INCLUDE} ${RESOURCE_FILES} 
	)
else()
	# Release (或其他) 模式，创建GUI程序
	message(STATUS "Creating a WIN32 GUI application for Release build.")

	qt_add_executable(${PROJECT_NAME} WIN32 MACOSX_BUNDLE
		${SOURCE_FILES} ${META_FILES_TO_INCLUDE} ${RESOURCE_FILES} 
	)
endif()


set_target_properties(${PROJECT_NAME}
    PROPERTIES
        CXX_STANDARD 17
        CXX_STANDARD_REQUIRED ON
)

target_precompile_headers(${PROJECT_NAME} INTERFACE QtWidgets.h)

target_link_libraries(${PROJECT_NAME} Qt6::Widgets)

install(
    TARGETS ${PROJECT_NAME}
    BUNDLE DESTINATION /Applications
)
