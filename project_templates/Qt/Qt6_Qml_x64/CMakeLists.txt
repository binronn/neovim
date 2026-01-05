cmake_minimum_required(VERSION 3.16)
project(example VERSION 1.0)
# This file is the root CMake configuration for the project.
# It defines project settings, dependencies, and build targets.

# Add folder where are supportive functions
set(CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake)
set(CMAKE_INCLUDE_CURRENT_DIR ON)

# Set the path to your Qt installation based on build type (Debug/Release).
# Debug builds use debug Qt libraries, while Release builds use release Qt libraries.
if(CMAKE_BUILD_TYPE STREQUAL "Debug")
	set(CMAKE_PREFIX_PATH "$ENV{QT_BASE}/x64/debug")
elseif(CMAKE_BUILD_TYPE STREQUAL "Release")
	set(CMAKE_PREFIX_PATH "$ENV{QT_BASE}/x64/release")
	set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -Wl,-subsystem,windows")
else()
	set(CMAKE_PREFIX_PATH "$ENV{QT_BASE}/x64/release")
	set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -Wl,-subsystem,windows")
endif()

# Enable automatic Qt meta-object compilation (MOC), resource compilation (RCC), and UI compilation (UIC).
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

# Define the source files for the project.
set(SOURCE_FILES
    src/main.cpp
)

add_project_meta(META_FILES_TO_INCLUDE)

# Define the Qt resource files for the project.
set(RESOURCE_FILES ${PROJECT_NAME}.qrc)


# Find and include Qt6 modules (Quick and Gui) required for the project.
find_package(Qt6 COMPONENTS Quick Gui REQUIRED)

# Configure standard Qt project settings.
qt_standard_project_setup()

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

# Set C++ standard to 17 and enforce it.

set_target_properties(${PROJECT_NAME}
    PROPERTIES
        CXX_STANDARD 17
        CXX_STANDARD_REQUIRED ON
)

# Link Qt6 Quick and Gui libraries to the project.
target_link_libraries(${PROJECT_NAME} PRIVATE Qt6::Quick Qt6::Gui)

# Install the built target to the specified destination (e.g., /Applications on macOS).
install(
    TARGETS ${PROJECT_NAME}
    BUNDLE DESTINATION /Applications
)
