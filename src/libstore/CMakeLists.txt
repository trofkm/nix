generate_inline_file(${CMAKE_CURRENT_SOURCE_DIR}/ca-specific-schema.sql)
generate_inline_file(${CMAKE_CURRENT_SOURCE_DIR}/schema.sql)

add_library(libstore STATIC binary-cache-store.cc build-result.cc common-protocol.cc
        content-address.cc crypto.cc daemon.cc derivations.cc derived-path.cc
        derived-path-map.cc downstream-placeholder.cc dummy-store.cc export-import.cc
        filetransfer.cc gc.cc globals.cc http-binary-cache-store.cc legacy-ssh-store.cc
        local-binary-cache-store.cc local-fs-store.cc local-store.cc lock.cc log-store.cc
        machines.cc make-content-addressed.cc misc.cc names.cc nar-accessor.cc nar-info.cc
        nar-info-disk-cache.cc optimise-store.cc outputs-spec.cc parsed-derivations.cc
        path.cc path-info.cc pathlocks.cc path-references.cc path-with-outputs.cc
        profiles.cc realisation.cc remote-fs-accessor.cc remote-store.cc
        s3-binary-cache-store.cc serve-protocol.cc sqlite.cc ssh.cc ssh-store.cc
        store-api.cc uds-remote-store.cc worker-protocol.cc globals.hh
        compile-defined-variables.h
# build
        build/derivation-goal.cc
        build/drv-output-substitution-goal.cc
        build/entry-points.cc
        build/goal.cc
        build/hook-instance.cc
        build/local-derivation-goal.cc
        build/personality.cc
        build/substitution-goal.cc
        build/worker.cc
# builtins
        builtins/buildenv.cc
        builtins/fetchurl.cc
        builtins/unpack-channel.cc
)

target_include_directories(libstore PUBLIC $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
        ${CMAKE_CURRENT_SOURCE_DIR}/build
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


