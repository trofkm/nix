begin_header("Generate inline files")

generate_inline_file(${CMAKE_CURRENT_SOURCE_DIR}/primops/derivation.nix)
generate_inline_file(${CMAKE_CURRENT_SOURCE_DIR}/flake/call-flake.nix)
generate_inline_file(${CMAKE_CURRENT_SOURCE_DIR}/imported-drv-to-derivation.nix)
generate_inline_file(${CMAKE_CURRENT_SOURCE_DIR}/fetchurl.nix)

end_header()


add_library(libexpr STATIC attr-path.cc attr-set.cc eval.cc eval-cache.cc eval-settings.cc
        function-trace.cc get-drvs.cc json-to-value.cc nixexpr.cc paths.cc primops.cc
        print.cc search-path.cc value-to-json.cc value-to-xml.cc
# flake
        flake/config.cc
        flake/flake.cc
        flake/flakeref.cc
        flake/lockfile.cc
# primops
        primops/context.cc
        primops/fetchClosure.cc
        primops/fetchMercurial.cc
        primops/fetchTree.cc
        primops/fromTOML.cc
# value
        value/context.cc
)

target_include_directories(libexpr PUBLIC $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
    ${CMAKE_CURRENT_SOURCE_DIR}/flake
    ${CMAKE_CURRENT_SOURCE_DIR}/primops
    ${CMAKE_CURRENT_SOURCE_DIR}/value
)

target_link_libraries(libexpr PUBLIC libutil libstore libfetchers Boost::context Threads::Threads gc)

if (${CMAKE_SYSTEM_NAME} MATCHES "Linux")
    target_link_libraries(libexpr PUBLIC dl)
endif()

# TODO: add tests

begin_header("Generate bison and flex files")

add_custom_command(
        OUTPUT ${CMAKE_CURRENT_SOURCE_DIR}/parser-tab.cc ${CMAKE_CURRENT_SOURCE_DIR}/parser-tab.hh
        COMMAND ${BISON_EXECUTABLE} -o ${CMAKE_CURRENT_SOURCE_DIR}/parser-tab.cc -d ${CMAKE_CURRENT_SOURCE_DIR}/parser.y
        COMMENT "Generating parser-tab.cc"
)

add_custom_command(
        OUTPUT ${CMAKE_CURRENT_SOURCE_DIR}/lexer-tab.cc ${CMAKE_CURRENT_SOURCE_DIR}/lexer-tab.hh
        COMMAND ${FLEX_EXECUTABLE} -o ${CMAKE_CURRENT_SOURCE_DIR}/lexer-tab.cc --header-file=${CMAKE_CURRENT_SOURCE_DIR}/lexer-tab.hh   ${CMAKE_CURRENT_SOURCE_DIR}/lexer.l
        COMMENT "Generating lexer-tab.cc and lexer-tab.hh"
)

target_sources(libexpr PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/parser-tab.cc ${CMAKE_CURRENT_SOURCE_DIR}/lexer-tab.cc)

end_header()


