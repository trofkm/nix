
set(libutil_platform_srcs)

if (UNIX)
    set (libutil_platform_srcs "linux/*.cc unix/*.cc")
elseif (WIN32)
    set (libutil_platform_srcs "windows/*.cc")
endif()

file(GLOB libutil_SRCS "*.cc" ${libutil_platform_srcs})



add_library(libutil STATIC
    ${libutil_SRCS}
)

target_include_directories(libutil PUBLIC $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}> $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/unix> $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/linux>)
target_compile_definitions(libutil PUBLIC -DHAVE_LIBCPUID)

target_link_libraries(libutil PRIVATE Threads::Threads nlohmann_json::nlohmann_json libstore LibArchive::LibArchive OpenSSL::SSL ${BROTLI_LIBRARIES})

# TODO: add test ssubdir