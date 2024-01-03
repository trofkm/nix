add_library(libutil STATIC
        compute-levels.cc
        hilite.cc
        json-utils.cc
        xml-writer.cc
        archive.cc
        args.cc
        canon-path.cc
        cgroup.cc
        compression.cc
        config.cc
        current-process.cc
        environment-variables.cc
        error.cc
        experimental-features.cc
        file-content-address.cc
        file-descriptor.cc
        file-system.cc
        fs-sink.cc
        git.cc
        hash.cc
        logging.cc
        memory-source-accessor.cc
        namespaces.cc
        posix-source-accessor.cc
        processes.cc
        references.cc
        serialise.cc
        signals.cc
        source-accessor.cc
        suggestions.cc
        tarfile.cc
        terminal.cc
        thread-pool.cc
        unix-domain-socket.cc
        url.cc
        users.cc
        util.cc
)

target_include_directories(libutil PUBLIC $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>)
target_compile_definitions(libutil PUBLIC -DHAVE_LIBCPUID)

target_link_libraries(libutil PRIVATE Threads::Threads nlohmann_json::nlohmann_json libstore LibArchive::LibArchive OpenSSL::SSL ${BROTLI_LIBRARIES})

# TODO: add test ssubdir