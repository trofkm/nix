add_library(libfetchers STATIC
        attrs.cc
        fetch-settings.cc
        cache.cc
        fetchers.cc
        filtering-input-accessor.cc
        fs-input-accessor.cc
        git-utils.cc
        git.cc
        github.cc
        indirect.cc
        input-accessor.cc
        memory-input-accessor.cc
        mercurial.cc
        mounted-input-accessor.cc
        path.cc
        registry.cc
        tarball.cc
)

target_include_directories(libfetchers PUBLIC $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>)

target_link_libraries(libfetchers PUBLIC libstore)