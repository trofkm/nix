cmake_minimum_required(VERSION 3.20)


# Standard definition
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)


# Enable link what you use
set(CMAKE_LINK_WHAT_YOU_USE ON)

# Do not use vendor-specific compiler flags.
set(CMAKE_CXX_EXTENSIONS OFF)
# Use ccache if available
find_program(CCACHE_FOUND ccache)
if(CCACHE_FOUND)
    set_property(GLOBAL PROPERTY RULE_LAUNCH_COMPILE ccache)
    set(CMAKE_CXX_COMPILER_LAUNCHER "ccache")
endif(CCACHE_FOUND)
# TODO: add check if we even have such linker
set(CMAKE_EXE_LINKER_FLAGS "-fuse-ld=gold")


# Add custom cmake modules
set(CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")
# Includes
include(version)
include(message_macros)
include(generate_file)
include(CheckIPOSupported)

# Enable Inter-procedural Optimization
check_ipo_supported(RESULT ipo_supported)
if(ipo_supported)
    set(CMAKE_INTERPROCEDURAL_OPTIMIZATION TRUE)
endif ()

# Parse version from file
parse_version_from_file(".version" PROJECT_VERSION)
# Parse commit hash from git
parse_commit_hash(PROJECT_COMMIT_HASH)


project(nix VERSION "${PROJECT_VERSION}" LANGUAGES CXX C)

# Disable in-source builds, because you must not do it.
if(PROJECT_SOURCE_DIR STREQUAL PROJECT_BINARY_DIR)
    message(FATAL_ERROR "In-source builds are not allowed")
endif()


begin_header("Determine build type")

# find Ninja if it is available
find_program(NINJA_FOUND ninja)
if(NINJA_FOUND)
    set(CMAKE_GENERATOR "Ninja")
endif ()

if(NOT DEFINED CMAKE_BUILD_TYPE)
    message(STATUS "Build type is not set, defaulting to Release")
    set(CMAKE_BUILD_TYPE "MinSizeRel")
endif()

if (CMAKE_BUILD_TYPE STREQUAL "Debug")
    message(STATUS "Build type is set to Debug")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -O0 -g -ggdb"
            CACHE STRING "C++ flags")
    set(CMAKE_VERBOSE_MAKEFILE ON)
elseif (CMAKE_BUILD_TYPE STREQUAL "Release" OR CMAKE_BUILD_TYPE STREQUAL "MinSizeRel")
    message(STATUS "Build type is set to Release")
    set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -s -Wl --gc-sections")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Os -DNDEBUG -flto -ffat-lto-objects -ffunction-sections -fdata-sections -march=native"
            CACHE STRING "C++ flags")
endif ()

end_header()
# CLI options

option(BUILD_TESTS "Build tests" ON)
option(BUILD_DOCUMENTATION "Build documentation" ON)

# Dependencies
begin_header("Dependencies")

find_package(Threads REQUIRED)
find_package(Boost 1.63.0 REQUIRED COMPONENTS context)
find_package(SQLite3 3.37 REQUIRED)
find_package(OpenSSL REQUIRED)
find_package(LibArchive REQUIRED)
find_package(CURL REQUIRED)
find_package(Editline 1.15.2 REQUIRED)
find_package(lowdown REQUIRED)
find_package(sodium REQUIRED)
find_package(Brotli REQUIRED)
find_package(cpuid REQUIRED)
find_package(BISON REQUIRED)
find_package(FLEX REQUIRED)


find_package(PkgConfig REQUIRED)
pkg_search_module(libgit2 REQUIRED libgit2)
# TODO: add cmake support for library gc https://www.linuxfromscratch.org/blfs/view/cvs/general/gc.html
# TODO: downgrade the version
find_package(nlohmann_json 3 REQUIRED)

if(BUILD_TESTS)
    find_package(GTest REQUIRED)
endif()

end_header()


# subdirectories

if(BUILD_TESTS)
    # TODO: here we must add the path to the tests
    #    add_subdirectory(tests)
    # For now I do not know how to organize test executables
endif()

add_subdirectory(src)