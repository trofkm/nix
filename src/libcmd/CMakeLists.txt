
file(GLOB libcmd_srcs "*.cc")

# TODO: make sure you name it properly
add_library(libcmd STATIC
        ${libcmd_srcs}
)
# TODO: this is very stupid way, but we need to handle that somehow in our code
target_compile_definitions(libcmd PRIVATE -DREADLINE)

target_include_directories(libcmd PUBLIC $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>)

target_link_libraries(libcmd PUBLIC libexpr libmain PRIVATE edit lowdown editreadline)
