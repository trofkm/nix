add_library(toml INTERFACE)
target_include_directories(toml INTERFACE $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>)