cmake_minimum_required(VERSION 3.16)
project(example VERSION 1.0)

# Set the project type to shared library (DLL)
set(LIBRARY_TYPE SHARED)

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

# Create a shared library (DLL) instead of an executable
qt_add_library(${PROJECT_NAME} ${LIBRARY_TYPE}
    ${SOURCE_FILES} ${META_FILES_TO_INCLUDE} ${RESOURCE_FILES}
)

# Set DLL properties
set_target_properties(${PROJECT_NAME}
    PROPERTIES
        CXX_STANDARD 17
        CXX_STANDARD_REQUIRED ON
        WINDOWS_EXPORT_ALL_SYMBOLS ON  # Export all symbols on Windows
        VERSION ${PROJECT_VERSION}
        SOVERSION ${PROJECT_VERSION_MAJOR}
)

# Define export macro for DLL
target_compile_definitions(${PROJECT_NAME} PRIVATE example_EXPORTS)

# Option to build test executable
option(BUILD_TEST "Build test executable" OFF)

if(BUILD_TEST)
    # Add definition for test build
    target_compile_definitions(${PROJECT_NAME} PRIVATE EXAMPLE_BUILD_TEST)
    
    # For test builds, we need to link with Qt6::Core for QApplication
    target_link_libraries(${PROJECT_NAME} Qt6::Widgets Qt6::Core)
else()
    target_link_libraries(${PROJECT_NAME} Qt6::Widgets)
endif()

target_precompile_headers(${PROJECT_NAME} INTERFACE QtWidgets.h)

# Install the DLL library
install(
    TARGETS ${PROJECT_NAME}
    RUNTIME DESTINATION bin
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib
)

# Install headers if needed
# install(
#     DIRECTORY src/
#     DESTINATION include/${PROJECT_NAME}
#     FILES_MATCHING PATTERN "*.h"
# )

# Option to build test application
option(BUILD_TEST_APP "Build test application that uses the DLL" OFF)

if(BUILD_TEST_APP)
    message(STATUS "Building test application...")
    
    # Add test subdirectory
    add_subdirectory(test)
    
    # Make test app depend on the DLL
    add_dependencies(example_test example)
    
    # On Windows, copy DLL to test executable directory
    if(WIN32)
        add_custom_command(TARGET example_test POST_BUILD
            COMMAND ${CMAKE_COMMAND} -E copy_if_different
                $<TARGET_FILE:example>
                $<TARGET_FILE_DIR:example_test>/
            COMMENT "Copying DLL to test executable directory"
        )
    endif()
endif()
