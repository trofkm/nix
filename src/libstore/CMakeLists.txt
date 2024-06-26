generate_inline_file(${CMAKE_CURRENT_SOURCE_DIR}/ca-specific-schema.sql)
generate_inline_file(${CMAKE_CURRENT_SOURCE_DIR}/schema.sql)
file(GLOB libstore_SRCS *.cc build/*.cc builtins/*.cc unix/*.cc unix/build/*.cc linux/*.cc)
add_library(libstore STATIC
        ${libstore_SRCS}
        # build
        # builtins
        builtins/unpack-channel.cc
        builtins/buildenv.cc
        builtins/fetchurl.cc
)

target_include_directories(libstore PUBLIC $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
        ${CMAKE_CURRENT_SOURCE_DIR}/build
        ${CMAKE_CURRENT_SOURCE_DIR}/unix
        ${CMAKE_CURRENT_SOURCE_DIR}/unix/build
        ${CMAKE_CURRENT_SOURCE_DIR}/linux
        ${CMAKE_CURRENT_SOURCE_DIR}/builtins
        ${sodium_INCLUDE_DIR}
)

target_link_libraries(libstore PUBLIC libutil PRIVATE CURL::libcurl SQLite::SQLite3 ${sodium_LIBRARY_RELEASE} lowdown bsd)
# TODO: add tests

include(system)


determine_platform(SYSTEM)
message(STATUS "Platform: ${SYSTEM}")

set(NIX_PREFIX "/usr")
set(NIX_STORE_DIR "/nix/store")
set(NIX_DATA_DIR "/usr/share")
set(NIX_STATE_DIR "/nix/var/nix")
set(NIX_LOG_DIR "/var/log/nix")
set(NIX_CONF_DIR "/etc/nix")
set(NIX_BIN_DIR "/usr/bin")
set(NIX_MAN_DIR "/usr/share/man")
set(LSOF "lsof")

file(READ ${CMAKE_CURRENT_SOURCE_DIR}/ca-specific-schema.sql CA_SCHEMA)
file(READ ${CMAKE_CURRENT_SOURCE_DIR}/schema.sql SCHEMA)

configure_file(sql-statements.h.in sql-statements.h @ONLY)
configure_file(compile-defined-variables.h.in compile-defined-variables.h @ONLY)
target_include_directories(libstore PUBLIC ${CMAKE_CURRENT_BINARY_DIR})


