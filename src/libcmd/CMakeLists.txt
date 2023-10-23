
# TODO: make sure you name it properly
add_library(libcmd STATIC repl.cc markdown.cc legacy.cc installables.cc installable-value.cc installable-flake.cc
        installable-derived-path.cc installable-attr-path.cc editor-for.cc common-eval-args.cc
        command-installable-value.cc command.cc built-path.cc)
# TODO: this is very stupid way, but we need to handle that somehow in our code
target_compile_definitions(libcmd PRIVATE -DREADLINE)

target_include_directories(libcmd PUBLIC $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>)

target_link_libraries(libcmd PUBLIC libexpr libmain PRIVATE edit lowdown)
