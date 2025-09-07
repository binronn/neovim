local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node  -- 新增恢复节点
local rep = require("luasnip.extras").rep  -- 正确导入重复函数

local fmt = require("luasnip.extras.fmt").fmt

-- 通用 C/C++ 片段（适用于C和C++）
local c_cpp_snippets = {
	-- Main 函数
	s("main", fmt([[
	int main(int argc, char *argv[]) 
	{{
		{}
		return 0;
	}}]], { i(1) })),

	-- For 循环
	s("for", fmt([[
	for (int {} = 0; {} < {}; ++{}) 
	{{
		{}
	}}]], { 
		i(1, "i"), 
		rep(1), 
		i(2, "n"), 
		rep(1), 
		i(0) 
	})),

    s("while", fmt([[
    while ({}) 
    {{
        {}
    }}]], { i(1, "condition"), i(0) })),

    s("do", fmt([[
    do 
    {{
        {}
    }} while ({});]], { i(2), i(1) })),

	-- 函数定义
	s("fn", fmt([[
	{} {}({}) 
	{{
		{}
	}}]], { 
		c(1, { t("void"),  t("auto"), t(nil, "type") }),
		i(2, 'function_name'),
		i(3),
		i(0)
	})),

	-- Include 头文件
	s("inc", fmt([[#include <{}>]], { i(1) })),

	-- 结构体
	s("struct", fmt([[
	struct {} 
	{{
		{} ;
	}};]], { i(1, "StructName"), i(0) })),

	-- If 条件
	s("if", fmt([[
	if ({}) 
	{{
		{}
	}}]], { i(1), i(0) })),

	-- If-Else
	s("ife", fmt([[
	if ({}) 
	{{
		{}
	}}
	else 
	{{
		{}
	}}]], { i(1), i(2), i(0) })),

	-- 指针声明
	s(
		"ptr", fmt([[{}* {} = {};]], 
		{ c(1, { t("uint64_t"), t("uint8_t"), i(nil, "type") })
		, i(2, "var"), i(3, "NULL") })
	),

	-- Enum 定义
	s("enum", fmt([[
	enum {} 
	{{
		{}
	}};]], { i(1, "EnumName"), i(0) })),

	-- Union 定义
	s("union", fmt([[
	union {} 
	{{
		{}
	}};]], { i(1, "UnionName"), i(0) })),

	-- Typedef
	s("typedef", fmt([[typedef {} {};]], { i(1, "type"), i(2, "alias") })),

	-- Switch 语句
	s("switch", fmt([[
	switch ({}) 
	{{
		case {}:
			{};
			break;
		default:
			{};
			break;
	}}]], { i(1, "var"), i(2, "value"), i(3), i(0) })),

	-- Const 声明
	s("const", fmt([[const {} {} = {};]], { i(1, "type"), i(2, "var"), i(3) })),

	-- Static 声明
	s("static", fmt([[static {} {} = {};]], { i(1, "type"), i(2, "var"), i(3) })),

	-- Extern 声明
	s("extern", fmt([[extern {} {};]], { i(1, "type"), i(2, "var") })),

	-- Macro 定义
	s("macro", fmt([[#define {} {}]], { i(1, "NAME"), i(2, "value") })),

	-- Ifdef
	s("ifdef", fmt([[
	#ifdef {}
		{}
	#endif]], { i(1, "MACRO"), i(0) })),

	-- Ifndef
	s("ifndef", fmt([[
	#ifndef {}
		{}
	#endif]], { i(1, "MACRO"), i(0) })),

	-- Pragma
	s("pragma", fmt([[#pragma {}]], { i(1, "once") })),

	-- Array 声明
	s("arr", fmt([[{} {}[{}] = {};]], { i(1, "type"), i(2, "name"), i(3, "size"), i(4) })),

	-- Malloc
	s("malloc", fmt([[{} *{} = ({})malloc(sizeof({}) * {});]], { i(1, "type"), i(2, "ptr"), rep(1), rep(1), i(3, "count") })),

	-- Free
	s("free", fmt([[free({});]], { i(1, "ptr") })),

	-- Printf
	s("printf", fmt([[printf("{}");]], { i(1, "%d\\n") })),

	-- Scanf
	s("scanf", fmt([[scanf("{}");]], { i(1, "%d") })),

	-- File open
	s("fopen", fmt([[FILE *{} = fopen("{}", "{}");]], { i(1, "fp"), i(2, "file.txt"), i(3, "r") })),

	-- File close
	s("fclose", fmt([[fclose({});]], { i(1, "fp") })),
}

-- C++ 专用片段
local cpp_snippets = {
	-- 类定义
	s({trig = "class", dscr = "C++ class definition"}, fmt([[
	class {} 
	{{
		public:
		{}();
		~{}();

		private:
		{}
	}};]], { 
		i(1, "ClassName"),
		rep(1),
		rep(1),
		i(0)
	})),

	-- 命名空间
	s("ns", fmt([[
	namespace {} 
	{{
		{}
	}} // namespace {}]], { 
		i(1, "namespace_name"), 
		i(0), 
		rep(1) 
	})),

	-- cout 输出
	s("cout", fmt([[std::cout << "{}" << std::endl;]], { i(1, "") })),

	-- 智能指针
	s("sptr", fmt([[std::shared_ptr<{}> {};]], { i(1, "T"), i(2, "ptr") })),

	-- 模板函数
	s("tmplfn", fmt([[
	template <typename {}> 
	{} {}({}) 
	{{
		{}
	}}]], { i(1, "T"), i(2, "return_type"), i(3, "function_name"), i(4), i(0) })),

	-- Vector 定义
	s("vec", fmt([[std::vector<{}> {};]], { i(1, "int"), i(2, "v") })),

	-- Map 定义
	s("map", fmt([[std::map<{}, {}> {};]], { i(1, "key_type"), i(2, "value_type"), i(3, "m") })),

	-- Lambda 表达式
	s("lambda", fmt([[auto {} = [{}] ({}) {{ {} }};]], { i(1, "lambda"), i(2), i(3), i(0) })),

	-- Include 标准库 (C++ specific, e.g., iostream)
	s("incios", t("#include <iostream>")),

	-- Using namespace
	s("usingns", fmt([[using namespace {};]], { i(1, "std") })),

	-- Template class
	s("tmplclass", fmt([[
	template <typename {}> 
	class {} 
	{{
		public:
			{}();
			~{}();
		private:
			{};
	}};]], { i(1, "T"), i(2, "ClassName"), rep(2), rep(2), i(0) })),

	-- Override
	s("override", fmt([[{} {}() override {{ {} }};]], { i(1, "void"), i(2, "method"), i(0) })),

	-- Unique pointer
	s("uptr", fmt([[std::unique_ptr<{}> {};]], { i(1, "T"), i(2, "ptr") })),

	-- String
	s("str", fmt([[std::string {} = "{}";]], { i(1, "s"), i(2) })),

	-- Cin
	s("cin", fmt([[std::cin >> {};]], { i(1, "var") })),

	-- Thread
	s("thread", fmt([[std::thread {}({});]], { i(1, "th"), i(2, "func") })),

	-- Mutex
	s("mutex", fmt([[std::mutex {};]], { i(1, "mtx") })),

	-- Lock guard
	s("lockg", fmt([[std::lock_guard<std::mutex> {}({});]], { i(1, "lock"), i(2, "mtx") })),

	-- Auto
	s("auto", fmt([[auto {} = {};]], { i(1, "var"), i(2) })),

	-- Range-based for
	s("forr", fmt([[
	for (auto& {} : {}) 
	{{
		{}
	}}]], { i(1, "item"), i(2, "container"), i(0) })),

	-- Constructor initialization list
	s("ctorinit", fmt([[{}::{}() : {} {{ }}]], { i(1, "Class"), rep(1), i(2, "member(init)") })),

	-- Destructor
	s("dtor", fmt([[{}::~{}() {{ {} }}]], { i(1, "Class"), rep(1), i(0) })),

	-- Friend
	s("friend", fmt([[friend class {};]], { i(1, "FriendClass") })),

	-- Virtual
	s("virt", fmt([[virtual {} {}() = 0;]], { i(1, "void"), i(2, "method") })),

	-- Constexpr
	s("constexpr", fmt([[constexpr {} {} = {};]], { i(1, "int"), i(2, "const"), i(3) })),

	-- Noexcept
	s("noex", fmt([[{} {}() noexcept {{ {} }}]], { i(1, "void"), i(2, "method"), i(0) })),

	-- Static assert
	s("stassert", fmt([[static_assert({}, "{}");]], { i(1, "condition"), i(2, "message") })),

	-- Tuple
	s("tuple", fmt([[std::tuple<{}, {}> {};]], { i(1, "int"), i(2, "std::string"), i(3, "tup") })),

	-- Get tuple
	s("gettup", fmt([[std::get<{}>({});]], { i(1, "0"), i(2, "tup") })),

	-- Optional
	s("opt", fmt([[std::optional<{}> {};]], { i(1, "int"), i(2, "opt") })),

	-- Variant
	s("varnt", fmt([[std::variant<{}, {}> {};]], { i(1, "int"), i(2, "std::string"), i(3, "var") })),
}

-- Python 片段
local python_snippets = {
	-- Import 语句
	s("imp", fmt([[import {}]], { i(1) })),

	-- From import
	s("fromimp", fmt([[from {} import {}]], { i(1, "module"), i(2, "item") })),

	-- 函数定义
	s("def", fmt([[
	def {}({}):
		{}
	]], { i(1, "function_name"), i(2), i(3) })),

	-- 类定义
	s("class", fmt([[
	class {}:
		def __init__(self, {}):
			{}
	]], { i(1, "ClassName"), i(2), i(3) })),

	-- If 语句
	s("if", fmt([[
	if {}:
		{}
	]], { i(1, "condition"), i(0) })),

	-- If-Else
	s("ife", fmt([[
	if {}:
		{}
	else:
		{}
	]], { i(1, "condition"), i(2), i(0) })),

	-- For 循环
	s("for", fmt([[
	for {} in {}:
		{}
	]], { i(1, "var"), i(2, "iterable"), i(0) })),

	-- While 循环
	s("while", fmt([[
	while {}:
		{}
	]], { i(1, "condition"), i(0) })),

	-- Try-Except
	s("try", fmt([[
	try:
		{}
	except {} as e:
		{}
	]], { i(1), i(2, "Exception"), i(0) })),

	-- List comprehension
	s("listcomp", fmt([[{} = [{} for {} in {}] ]], { i(1, "result"), i(2, "expr"), i(3, "var"), i(4, "iterable") })),

	-- Main guard
	s("ifmain", t('if __name__ == "__main__":')),

	-- Print
	s("print", fmt([[print({})]], { i(1) })),

	-- Lambda
	s("lambda", fmt([[lambda {}: {}]], { i(1, "x"), i(2, "x + 1") })),

	-- Dict
	s("dict", fmt([[{} = {{ {}: {} }}]], { i(1, "d"), i(2, "key"), i(3, "value") })),

	-- List
	s("list", fmt([[{} = [{}] ]], { i(1, "lst"), i(2) })),

	-- Set
	s("set", fmt([[{} = {{ {} }} ]], { i(1, "s"), i(2) })),

	-- Tuple
	s("tuple", fmt([[{} = ({}) ]], { i(1, "tup"), i(2) })),

	-- With statement
	s("with", fmt([[
	with {} as {}:
		{}
	]], { i(1, "open('file.txt')"), i(2, "f"), i(0) })),

	-- Async def
	s("asyncdef", fmt([[
	async def {}({}):
		{}
	]], { i(1, "func"), i(2), i(0) })),

	-- Await
	s("await", fmt([[await {}]], { i(1) })),

	-- Decorator
	s("dec", fmt([[
	@{}
	def {}({}):
		{}
	]], { i(1, "decorator"), i(2, "func"), i(3), i(0) })),

	-- Property
	s("prop", fmt([[
	@property
	def {} (self):
		return self.{}
	]], { i(1, "prop"), i(2, "_prop") })),

	-- Static method
	s("staticmethod", fmt([[
	@staticmethod
	def {} ({}):
		{}
	]], { i(1, "method"), i(2), i(0) })),

	-- Class method
	s("classmethod", fmt([[
	@classmethod
	def {} (cls, {}):
		{}
	]], { i(1, "method"), i(2), i(0) })),

	-- Enum
	s("enum", fmt([[
	from enum import Enum
	class {} (Enum):
		{} = {}
	]], { i(1, "MyEnum"), i(2, "VALUE"), i(3, "1") })),

	-- Dataclass
	s("dataclass", fmt([[
	from dataclasses import dataclass
	@dataclass
	class {}:
		{}: {}
	]], { i(1, "MyClass"), i(2, "field"), i(3, "str") })),

	-- Type hint
	s("typehint", fmt([[{}: {} = {}]], { i(1, "var"), i(2, "int"), i(3, "0") })),

	-- Argparse
	s("argparse", fmt([[
	import argparse
	parser = argparse.ArgumentParser()
	parser.add_argument('{}', type={})
	args = parser.parse_args()
	]], { i(1, "--flag"), i(2, "str") })),

	-- Logging
	s("logging", fmt([[
	import logging
	logging.basicConfig(level=logging.{})
	logging.{}("{}")
	]], { i(1, "INFO"), i(2, "info"), i(3, "message") })),

	-- Exception raise
	s("raise", fmt([[raise {}("{}")]], { i(1, "ValueError"), i(2, "message") })),

	-- Assert
	s("assert", fmt([[assert {}, "{}"]], { i(1, "condition"), i(2, "message") })),

	-- Context manager
	s("ctxmgr", fmt([[
	class {}:
		def __enter__(self):
			{}
		def __exit__(self, exc_type, exc_val, exc_tb):
			{}
	]], { i(1, "MyContext"), i(2), i(0) })),
}

-- CMake 片段
local cmake_snippets = {
	-- Minimum required
	s("minreq", fmt([[cmake_minimum_required(VERSION {})]], { i(1, "3.10") })),

	-- Project
	s("project", fmt([[project({} VERSION {} {})]], { i(1, "ProjectName"), i(2, "1.0"), i(3, "LANGUAGES CXX") })),

	-- Add executable
	s("addexe", fmt([[add_executable({} {})]], { i(1, "target"), i(2, "source.cpp") })),

	-- Add library
	s("addlib", fmt([[add_library({} {} {})]], { i(1, "target"), i(2, "STATIC"), i(3, "source.cpp") })),

	-- Target include directories
	s("tinc", fmt([[target_include_directories({} PRIVATE {})]], { i(1, "target"), i(2, "${CMAKE_CURRENT_SOURCE_DIR}/include") })),

	-- Target link libraries
	s("tlink", fmt([[target_link_libraries({} PRIVATE {})]], { i(1, "target"), i(2, "lib") })),

	-- Set property
	s("setprop", fmt([[set_target_properties({} PROPERTIES {} {})]], { i(1, "target"), i(2, "CXX_STANDARD"), i(3, "11") })),

	-- Find package
	s("findpkg", fmt([[find_package({} REQUIRED)]], { i(1, "PackageName") })),

	-- Install
	s("install", fmt([[install(TARGETS {} DESTINATION {})]], { i(1, "target"), i(2, "bin") })),

	-- Set variable
	s("setvar", fmt([[set({} {})]], { i(1, "VAR"), i(2, "value") })),

	-- Message
	s("msg", fmt([[message({} "{}")]], { i(1, "STATUS"), i(2, "text") })),

	-- Include directories
	s("incdir", fmt([[include_directories({})]], { i(1, "${CMAKE_CURRENT_SOURCE_DIR}/include") })),

	-- Link directories
	s("linkdir", fmt([[link_directories({})]], { i(1, "/usr/lib") })),

	-- Add subdirectory
	s("addsub", fmt([[add_subdirectory({})]], { i(1, "subdir") })),

	-- Option
	s("option", fmt([[option({} "{}" {})]], { i(1, "ENABLE_FEATURE"), i(2, "Enable feature"), i(3, "ON") })),

	-- If
	s("if", fmt([[
	if({})
		{}
	endif()
	]], { i(1, "condition"), i(0) })),

	-- Foreach
	s("foreach", fmt([[
	foreach({} IN {})
		{}
	endforeach()
	]], { i(1, "var"), i(2, "LISTS items"), i(0) })),

	-- Function
	s("function", fmt([[
	function({} {})
		{}
	endfunction()
	]], { i(1, "func_name"), i(2), i(0) })),

	-- Macro
	s("macro", fmt([[
	macro({} {})
		{}
	endmacro()
	]], { i(1, "macro_name"), i(2), i(0) })),

	-- Configure file
	s("conf_file", fmt([[configure_file({} {} {})]], { i(1, "input.in"), i(2, "output"), i(3, "COPYONLY") })),

	-- Enable testing
	s("entest", t("enable_testing()")),

	-- Add test
	s("addtest", fmt([[add_test(NAME {} COMMAND {})]], { i(1, "test_name"), i(2, "executable") })),

	-- CPack
	s("cpack", fmt([[
	include(CPack)
	set(CPACK_PACKAGE_NAME "{}")
	set(CPACK_PACKAGE_VERSION "{}")
	]], { i(1, "MyPackage"), i(2, "1.0.0") })),

	-- Export
	s("export", fmt([[export(TARGETS {} FILE {})]], { i(1, "target"), i(2, "Targets.cmake") })),

	-- Include FetchContent
	s("incfetch", t("include(FetchContent)")),

	-- FetchContent Declare
	s("fetchdec", fmt([[
	FetchContent_Declare(
		{}
		GIT_REPOSITORY {}
		GIT_TAG {}
	)
	]], { i(1, "dep_name"), i(2, "https://github.com/user/repo.git"), i(3, "v1.0.0") })),

	-- FetchContent MakeAvailable
	s("fetchmake", fmt([[FetchContent_MakeAvailable({})]], { i(1, "dep_name") })),

	-- FetchContent Populate
	s("fetchpop", fmt([[
	FetchContent_Populate(
		{}
		QUIET
		SUBBUILD_DIR {}
		SOURCE_DIR {}
		BINARY_DIR {}
	)
	]], { i(1, "dep_name"), i(2, "${CMAKE_CURRENT_BINARY_DIR}/subbuild"), i(3, "${CMAKE_CURRENT_BINARY_DIR}/source"), i(4, "${CMAKE_CURRENT_BINARY_DIR}/binary") })),

	-- Target compile options
	s("tcompopt", fmt([[target_compile_options({} PRIVATE {})]], { i(1, "target"), i(2, "-Wall") })),

	-- Target compile definitions
	s("tcompdef", fmt([[target_compile_definitions({} PRIVATE {})]], { i(1, "target"), i(2, "MY_DEF=1") })),

	-- Add custom command
	s("addcmd", fmt([[
	add_custom_command(
		OUTPUT {}
		COMMAND {}
		DEPENDS {}
	)
	]], { i(1, "output.file"), i(2, "command"), i(3, "input.file") })),

	-- Add custom target
	s("addtgt", fmt([[add_custom_target({} {})]], { i(1, "custom_target"), i(2, "ALL DEPENDS output.file") })),

	-- File GLOB
	s("fglob", fmt([[file(GLOB {} "{}")]], { i(1, "sources"), i(2, "*.cpp") })),

	-- File COPY
	s("fcopy", fmt([[file(COPY {} DESTINATION {})]], { i(1, "file.txt"), i(2, "${CMAKE_BINARY_DIR}") })),

	-- File REMOVE
	s("fremove", fmt([[file(REMOVE {})]], { i(1, "file.txt") })),

	-- String REPLACE
	s("strrep", fmt([[string(REPLACE "{}" "{}" {} {})]], { i(1, "old"), i(2, "new"), i(3, "out_var"), i(4, "input_str") })),

	-- List APPEND
	s("lappend", fmt([[list(APPEND {} {})]], { i(1, "my_list"), i(2, "item") })),

	-- List REMOVE_ITEM
	s("lremove", fmt([[list(REMOVE_ITEM {} {})]], { i(1, "my_list"), i(2, "item") })),

	-- Math
	s("math", fmt([[math(EXPR {} "{}")]], { i(1, "result"), i(2, "1 + 2") })),

	-- Include
	s("include", fmt([[include({})]], { i(1, "module.cmake") })),

	-- ExternalProject Add
	s("extproj", fmt([[
	include(ExternalProject)
	ExternalProject_Add(
		{}
		GIT_REPOSITORY {}
		GIT_TAG {}
		CMAKE_ARGS {}
	)
	]], { i(1, "ext_proj"), i(2, "https://github.com/user/repo.git"), i(3, "v1.0.0"), i(4, "-DCMAKE_INSTALL_PREFIX=${CMAKE_BINARY_DIR}/install") })),

	-- Target precompile headers
	s("tpch", fmt([[target_precompile_headers({} PRIVATE {})]], { i(1, "target"), i(2, "<header.h>") })),

	-- Set source properties
	s("srcprop", fmt([[set_source_files_properties({} PROPERTIES {} {})]], { i(1, "source.cpp"), i(2, "COMPILE_FLAGS"), i(3, "-O2") })),

	-- Enable language
	s("enlang", fmt([[enable_language({})]], { i(1, "ASM") })),

	-- Check include file
	s("chkinc", fmt([[check_include_file({} {})]], { i(1, "header.h"), i(2, "HAVE_HEADER") })),

	-- Check function exists
	s("chkfunc", fmt([[check_function_exists({} {})]], { i(1, "func"), i(2, "HAVE_FUNC") })),

	-- Add definitions (deprecated)
	s("adddef", fmt([[add_definitions({})]], { i(1, "-DMY_DEF=1") })),

	-- Target sources
	s("tsrc", fmt([[target_sources({} PRIVATE {})]], { i(1, "target"), i(2, "additional.cpp") })),

	-- Package config
	s("pkgconf", fmt([[
	include(CMakePackageConfigHelpers)
	write_basic_package_version_file(
		{}.cmake
		VERSION {}
		COMPATIBILITY {}
	)
	]], { i(1, "MyPackageVersion"), i(2, "${PROJECT_VERSION}"), i(3, "AnyNewerVersion") })),

	-- Install files
	s("instfiles", fmt([[install(FILES {} DESTINATION {})]], { i(1, "header.h"), i(2, "include") })),

	-- Install directory
	s("instdir", fmt([[install(DIRECTORY {} DESTINATION {})]], { i(1, "dir/"), i(2, "share") })),

	-- CTest
	s("ctest", t("include(CTest)")),

	-- Build testing
	s("buildtest", t("if(BUILD_TESTING) endif()")),

	-- Add dependencies
	s("adddep", fmt([[add_dependencies({} {})]], { i(1, "target"), i(2, "dep") })),
}

-- Bash (Shell) 片段，使用 "sh" 文件类型
local bash_snippets = {
	-- Shebang
	s("shebang", t("#!/bin/bash")),

	-- Function
	s("fn", fmt([[
	{}() {{
		{}
	}}
	]], { i(1, "function_name"), i(0) })),

	-- If 语句
	s("if", fmt([[
	if [ {} ]; then
		{}
	fi
	]], { i(1, "condition"), i(0) })),

	-- If-Else
	s("ife", fmt([[
	if [ {} ]; then
		{}
	else
		{}
	fi
	]], { i(1, "condition"), i(2), i(0) })),

	-- For 循环
	s("for", fmt([[
	for {} in {}; do
		{}
	done
	]], { i(1, "var"), i(2, "list"), i(0) })),

	-- While 循环
	s("while", fmt([[
	while [ {} ]; do
		{}
	done
	]], { i(1, "condition"), i(0) })),

	-- Case 语句
	s("case", fmt([[
	case {} in
		{})
			;;
		*)
			;;
	esac
	]], { i(1, "var"), i(2, "pattern") })),

	-- Echo
	s("echo", fmt([[echo "{}"]], { i(1) })),

	-- Export
	s("export", fmt([[export {}={} ]], { i(1, "VAR"), i(2, "value") })),

	-- Read
	s("read", fmt([[read -p "{}" {} ]], { i(1, "Prompt: "), i(2, "var") })),

	-- Trap
	s("trap", fmt([[trap "{}" {} ]], { i(1, "cleanup"), i(2, "EXIT") })),

	-- Source
	s("source", fmt([[source {} ]], { i(1, "file.sh") })),

	-- Array
	s("array", fmt([[{}=( {} ) ]], { i(1, "arr"), i(2) })),

	-- Until
	s("until", fmt([[
	until [ {} ]; do
		{}
	done
	]], { i(1, "condition"), i(0) })),

	-- Select
	s("select", fmt([[
	select {} in {}; do
		{}
	done
	]], { i(1, "var"), i(2, "options"), i(0) })),

	-- Shift
	s("shift", t("shift")),

	-- Getopts
	s("getopts", fmt([[
	while getopts "{}" opt; do
		case $opt in
			{})
				;;
		esac
	done
	]], { i(1, "ab:"), i(2, "a) ;;") })),

	-- Mkdir
	s("mkdir", fmt([[mkdir -p {} ]], { i(1, "dir") })),

	-- Rm
	s("rm", fmt([[rm -rf {} ]], { i(1, "file") })),

	-- Cp
	s("cp", fmt([[cp -r {} {} ]], { i(1, "src"), i(2, "dest") })),

	-- Mv
	s("mv", fmt([[mv {} {} ]], { i(1, "src"), i(2, "dest") })),

	-- Grep
	s("grep", fmt([[grep "{}" {} ]], { i(1, "pattern"), i(2, "file") })),

	-- Sed
	s("sed", fmt([[sed 's/{}/{}/g' {} ]], { i(1, "old"), i(2, "new"), i(3, "file") })),

	-- Awk
	s("awk", fmt([[awk '{}' {} ]], { i(1, "{print $1}"), i(2, "file") })),

	-- Curl
	s("curl", fmt([[curl -O {} ]], { i(1, "url") })),

	-- Wget
	s("wget", fmt([[wget {} ]], { i(1, "url") })),

	-- Tar
	s("tar", fmt([[tar -czvf {}.tar.gz {} ]], { i(1, "archive"), i(2, "files") })),

	-- Untar
	s("untar", fmt([[tar -xzvf {} ]], { i(1, "archive.tar.gz") })),

	-- Sleep
	s("sleep", fmt([[sleep {} ]], { i(1, "1") })),

	-- Exit
	s("exit", fmt([[exit {} ]], { i(1, "0") })),
}

-- Lua 片段
local lua_snippets = {
	-- Function
	s("fn", fmt([[
	function {}({})
		{}
	end
	]], { i(1, "function_name"), i(2), i(0) })),

	-- Local function
	s("lfn", fmt([[
	local function {}({})
		{}
	end
	]], { i(1, "function_name"), i(2), i(0) })),

	-- If 语句
	s("if", fmt([[
	if {} then
		{}
	end
	]], { i(1, "condition"), i(0) })),

	-- If-Else
	s("ife", fmt([[
	if {} then
		{}
	else
		{}
	end
	]], { i(1, "condition"), i(2), i(0) })),

	-- For 循环 (numeric)
	s("forn", fmt([[
	for {}={}, {} do
		{}
	end
	]], { i(1, "i"), i(2, "1"), i(3, "n"), i(0) })),

	-- For 循环 (ipairs)
	s("fori", fmt([[
	for {}, {} in ipairs({}) do
		{}
	end
	]], { i(1, "i"), i(2, "v"), i(3, "table"), i(0) })),

	-- While 循环
	s("while", fmt([[
	while {} do
		{}
	end
	]], { i(1, "condition"), i(0) })),

	-- Require
	s("req", fmt([[local {} = require("{}")]], { i(1, "var"), i(2, "module") })),

	-- Print
	s("print", fmt([[print({})]], { i(1) })),

	-- Table
	s("table", fmt([[{} = {{ {} = {} }} ]], { i(1, "tbl"), i(2, "key"), i(3, "value") })),

	-- Do
	s("do", fmt([[
	do
		{}
	end
	]], { i(0) })),

	-- Repeat
	s("repeat", fmt([[
	repeat
		{}
	until {}
	]], { i(1), i(2, "condition") })),

	-- Local variable
	s("local", fmt([[local {} = {} ]], { i(1, "var"), i(2) })),

	-- Metatable
	s("meta", fmt([[setmetatable({}, {{ {} = {} }}) ]], { i(1, "tbl"), i(2, "__index"), i(3, "func") })),

	-- Coroutine
	s("coro", fmt([[local {} = coroutine.create(function() {} end) ]], { i(1, "co"), i(2) })),

	-- Resume
	s("resume", fmt([[coroutine.resume({}) ]], { i(1, "co") })),

	-- Yield
	s("yield", fmt([[coroutine.yield({}) ]], { i(1) })),

	-- Pcall
	s("pcall", fmt([[local ok, err = pcall({}) ]], { i(1, "func") })),

	-- Assert
	s("assert", fmt([[assert({}, "{}") ]], { i(1, "condition"), i(2, "message") })),

	-- Error
	s("error", fmt([[error("{}") ]], { i(1, "message") })),

	-- Pairs
	s("pairs", fmt([[
	for {}, {} in pairs({}) do
		{}
	end
	]], { i(1, "k"), i(2, "v"), i(3, "tbl"), i(0) })),

	-- -- Module
	-- s("module", fmt([[
	-- local M = {}
	-- {}
	-- return M
	-- ]], { i(0) })),

	-- Vim keymap
	s("keymap", fmt([[vim.keymap.set("{}", "{}", "{}") ]], { i(1, "n"), i(2, "<leader>x"), i(3, ":command<CR>") })),

	-- Vim option
	s("opt", fmt([[vim.opt.{} = {} ]], { i(1, "number"), i(2, "true") })),

	-- Vim api
	s("api", fmt([[vim.api.nvim_{}({}) ]], { i(1, "set_keymap"), i(2) })),

	-- Table insert
	s("tinsert", fmt([[table.insert({}, {}) ]], { i(1, "tbl"), i(2, "value") })),

	-- Table remove
	s("tremove", fmt([[table.remove({}, {}) ]], { i(1, "tbl"), i(2, "index") })),

	-- String format
	s("sformat", fmt([[string.format("{}", {}) ]], { i(1, "%s"), i(2, "var") })),

	-- Io open
	s("ioopen", fmt([[local f = io.open("{}", "{}") ]], { i(1, "file.txt"), i(2, "r") })),

	-- Io read
	s("ioread", fmt([[f:read("{}") ]], { i(1, "*all") })),

	-- Io write
	s("iowrite", fmt([[f:write("{}") ]], { i(1, "text") })),

	-- Io close
	s("ioclose", fmt([[f:close() ]], { })),

	-- Os execute
	s("osexec", fmt([[os.execute("{}") ]], { i(1, "command") })),

	-- Math random
	s("random", fmt([[math.random({}) ]], { i(1, "1, 10") })),
}

-- 注册片段
-- 对于C：只用通用片段
ls.add_snippets("c", c_cpp_snippets)

-- 对于C++：通用 + C++专用（使用 "force" 以确保合并覆盖，如果有冲突）
ls.add_snippets("cpp", vim.tbl_extend("force", c_cpp_snippets, cpp_snippets))

-- Python
ls.add_snippets("python", python_snippets)

-- CMake
ls.add_snippets("cmake", cmake_snippets)

-- Bash (使用 "sh" 文件类型)
ls.add_snippets("sh", bash_snippets)

-- Lua
ls.add_snippets("lua", lua_snippets)
