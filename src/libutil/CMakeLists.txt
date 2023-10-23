add_library(libutil STATIC archive.cc args.cc canon-path.cc cgroup.cc
        compression.cc compute-levels.cc config.cc error.cc experimental-features.cc
        filesystem.cc fs-sink.cc git.cc hash.cc hilite.cc json-utils.cc logging.cc
        namespaces.cc references.cc serialise.cc suggestions.cc tarfile.cc
        thread-pool.cc url.cc util.cc xml-writer.cc posix-source-accessor.cc
        source-accessor.cc)

target_include_directories(libutil PUBLIC $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>)

target_link_libraries(libutil PRIVATE Threads::Threads nlohmann_json::nlohmann_json libstore LibArchive::LibArchive OpenSSL::SSL ${BROTLI_LIBRARIES})

# TODO: add test ssubdir