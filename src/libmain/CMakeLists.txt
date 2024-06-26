file(GLOB libmain_SRCS *.cc)
add_library(libmain STATIC
    ${libmain_SRCS}
)

target_include_directories(libmain PUBLIC $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>)

target_link_libraries(libmain PUBLIC libstore libutil)