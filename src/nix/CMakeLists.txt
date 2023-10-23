begin_header("Generate inline files")

generate_inline_file(${CMAKE_CURRENT_SOURCE_DIR}/get-env.sh)
generate_inline_file_in_dir(${PROJECT_SOURCE_DIR}/doc/manual/generate-settings.nix ${CMAKE_CURRENT_SOURCE_DIR})
generate_inline_file_in_dir(${PROJECT_SOURCE_DIR}/doc/manual/utils.nix ${CMAKE_CURRENT_SOURCE_DIR})
generate_inline_file_in_dir(${PROJECT_SOURCE_DIR}/doc/manual/generate-store-info.nix ${CMAKE_CURRENT_SOURCE_DIR})
generate_inline_file_in_dir(${PROJECT_SOURCE_DIR}/doc/manual/generate-manpage.nix ${CMAKE_CURRENT_SOURCE_DIR})
file(MAKE_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/doc/files)
generate_inline_file_in_dir(${PROJECT_SOURCE_DIR}/doc/manual/src/package-management/profiles.md ${CMAKE_CURRENT_SOURCE_DIR}/doc/files)

end_header()

add_executable(nix main.cc add-to-store.cc app.cc build.cc bundle.cc cat.cc copy.cc daemon.cc derivation.cc
        derivation-add.cc derivation-show.cc develop.cc diff-closures.cc doctor.cc dump-path.cc edit.cc eval.cc
        flake.cc fmt.cc hash.cc log.cc ls.cc make-content-addressed.cc nar.cc optimise-store.cc path-from-hash-part.cc
        path-info.cc prefetch.cc profile.cc realisation.cc repl.cc run.cc search.cc show-config.cc sigs.cc store.cc
        store-copy-log.cc store-delete.cc store-gc.cc store-info.cc store-repair.cc upgrade-nix.cc verify.cc
        why-depends.cc)

# TODO: this is very weird that we have source files in our root folder but for now we have autoconf and makefile, so I cannot move that file to the src directory.
target_precompile_headers(nix PUBLIC ${PROJECT_SOURCE_DIR}/precompiled-headers.h)


target_link_libraries(nix PRIVATE libcmd
# commands
        nix-env nix-build nix-channel nix-collect-garbage nix-copy-closure nix-instantiate nix-store build-remote
)

# Strip the binary
add_custom_command(
        TARGET nix POST_BUILD
        DEPENDS nix
        COMMAND $<$<CONFIG:release>:${CMAKE_STRIP}>
        ARGS --strip-all $<TARGET_FILE:nix>
)