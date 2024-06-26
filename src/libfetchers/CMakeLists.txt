
file(GLOB_RECURSE fetchers_srcs ${CMAKE_CURRENT_SOURCE_DIR}/*.cc)
add_library(libfetchers STATIC
        ${fetchers_srcs}
)

target_include_directories(libfetchers PUBLIC $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>)

target_link_libraries(libfetchers PUBLIC libstore)