cmake_minimum_required(VERSION 3.10)
project(CppConsole CXX)

# ==============================================================================
# Configuration Variables
# ==============================================================================

# Control which entry point to use: "MAIN", "WINMAIN", "DLL", or "STATIC"
set(ENTRY_POINT "MAIN" CACHE STRING "Choose the entry point: MAIN, WINMAIN, DLL, or STATIC_DLL")

# Control linking type: "STATIC" or "DYNAMIC"
set(LINK_TYPE "STATIC" CACHE STRING "Choose linking type: STATIC or DYNAMIC")

# Control Subsystem: "CONSOLE" or "WINDOWS"
# "CONSOLE" = Standard console application (cmd.exe attached)
# "WINDOWS" = GUI application (no console window)
set(SUBSYSTEM "CONSOLE" CACHE STRING "Choose subsystem: CONSOLE or WINDOWS")

# Control Architecture: "x64" or "x86"
set(TARGET_ARCH "x64" CACHE STRING "Choose target architecture: x64 or x86")

# ==============================================================================
# Source Selection
# ==============================================================================

set(SRC "")

if(ENTRY_POINT STREQUAL "MAIN")
    list(APPEND SRC "main.cpp")
elseif(ENTRY_POINT STREQUAL "WINMAIN")
    list(APPEND SRC "winmain.cpp")
elseif(ENTRY_POINT STREQUAL "DLL" OR ENTRY_POINT STREQUAL "STATIC")
    list(APPEND SRC "dllmain.cpp")
else()
    message(FATAL_ERROR "Invalid ENTRY_POINT: ${ENTRY_POINT}. Must be MAIN, WINMAIN, DLL, or STATIC.")
endif()

message(STATUS "Selected Source File: ${SRC}")

# ==============================================================================
# Compiler Options (Customizable)
# ==============================================================================

set(CUSTOM_COMPILE_OPTIONS
    -Wall
    -Wextra
    -std=c++17
)

set(CUSTOM_LINK_OPTIONS "")

# ==============================================================================
# Architecture Configuration
# ==============================================================================

if(TARGET_ARCH STREQUAL "x86")
    message(STATUS "Configuring for x86 (32-bit)")
    list(APPEND CUSTOM_COMPILE_OPTIONS "-m32")
    list(APPEND CUSTOM_LINK_OPTIONS "-m32")
elseif(TARGET_ARCH STREQUAL "x64")
    message(STATUS "Configuring for x64 (64-bit)")
    list(APPEND CUSTOM_COMPILE_OPTIONS "-m64")
    list(APPEND CUSTOM_LINK_OPTIONS "-m64")
else()
    message(WARNING "Unknown TARGET_ARCH: ${TARGET_ARCH}. Defaulting to compiler default.")
endif()

# ==============================================================================
# Linkage Configuration
# ==============================================================================

if(LINK_TYPE STREQUAL "STATIC")
    list(APPEND CUSTOM_LINK_OPTIONS "-static")
    message(STATUS "Configuring for STATIC linking")
elseif(LINK_TYPE STREQUAL "DYNAMIC")
    message(STATUS "Configuring for DYNAMIC linking")
else()
    message(WARNING "Unknown LINK_TYPE: ${LINK_TYPE}. Defaulting to DYNAMIC behavior.")
endif()

# ==============================================================================
# Target Definition
# ==============================================================================

if(ENTRY_POINT STREQUAL "DLL")
    add_library(AppTarget SHARED ${SRC})
    message(STATUS "Building Dynamic Link Library")
elseif(ENTRY_POINT STREQUAL "STATIC_DLL")
    add_library(AppTarget STATIC ${SRC})
    message(STATUS "Building Static Library")
else()
    if(SUBSYSTEM STREQUAL "WINDOWS")
        add_executable(AppTarget WIN32 ${SRC})
        message(STATUS "Building Executable (Subsystem: WINDOWS)")
    else()
        add_executable(AppTarget ${SRC})
        message(STATUS "Building Executable (Subsystem: CONSOLE)")
    endif()
endif()

# ==============================================================================
# Apply Options
# ==============================================================================

target_compile_options(AppTarget PRIVATE ${CUSTOM_COMPILE_OPTIONS})
target_link_options(AppTarget PRIVATE ${CUSTOM_LINK_OPTIONS})

# Set output file name to match Project Name
set_target_properties(AppTarget PROPERTIES OUTPUT_NAME ${PROJECT_NAME})

# If on Windows, we might need to link standard Windows libraries
if(WIN32)
    target_link_libraries(AppTarget PRIVATE user32 kernel32)
endif()