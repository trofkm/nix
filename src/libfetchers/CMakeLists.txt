add_library(libfetchers STATIC attrs.cc cache.cc fetch-settings.cc fetchers.cc git.cc
        github.cc indirect.cc input-accessor.cc mercurial.cc path.cc registry.cc tarball.cc
        fs-input-accessor.cc memory-input-accessor.cc)

target_include_directories(libfetchers PUBLIC $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>)

target_link_libraries(libfetchers PUBLIC libstore)