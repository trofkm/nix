begin_header("Generate inline files")

generate_inline_file(${CMAKE_CURRENT_SOURCE_DIR}/get-env.sh)
generate_inline_file_in_dir(${PROJECT_SOURCE_DIR}/doc/manual/generate-settings.nix ${CMAKE_CURRENT_SOURCE_DIR})
generate_inline_file_in_dir(${PROJECT_SOURCE_DIR}/doc/manual/utils.nix ${CMAKE_CURRENT_SOURCE_DIR})
generate_inline_file_in_dir(${PROJECT_SOURCE_DIR}/doc/manual/generate-store-info.nix ${CMAKE_CURRENT_SOURCE_DIR})
generate_inline_file_in_dir(${PROJECT_SOURCE_DIR}/doc/manual/generate-manpage.nix ${CMAKE_CURRENT_SOURCE_DIR})
file(MAKE_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/doc/files)
generate_inline_file_in_dir(${PROJECT_SOURCE_DIR}/doc/manual/src/package-management/profiles.md ${CMAKE_CURRENT_SOURCE_DIR}/doc/files)
generate_inline_file_in_dir_with_no_postfix_name(${PROJECT_SOURCE_DIR}/doc/manual/src/store/types/index.md.in ${CMAKE_CURRENT_SOURCE_DIR}/generated-doc help-stores.md)

file(MAKE_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/generated-doc/files)
generate_inline_file_in_dir_with_name(${CMAKE_CURRENT_SOURCE_DIR}/profile.md ${CMAKE_CURRENT_SOURCE_DIR}/generated-doc/files profiles.md)

end_header()

add_executable(nix
        copy.cc
        derivation-add.cc
        derivation-show.cc
        diff-closures.cc
        eval.cc
        log.cc
        make-content-addressed.cc
        optimise-store.cc
        path-from-hash-part.cc
        repl.cc
        search.cc
        store-copy-log.cc
        store-delete.cc
        store-gc.cc
        store-info.cc
        store-repair.cc
        build.cc
        app.cc
        add-to-store.cc
        bundle.cc
        cat.cc
        config-check.cc
        config.cc
        daemon.cc
        derivation.cc
        develop.cc
        dump-path.cc
        edit.cc
        flake.cc
        fmt.cc
        hash.cc
        ls.cc
        main.cc
        nar.cc
        path-info.cc
        prefetch.cc
        profile.cc
        realisation.cc
        registry.cc
        run.cc
        sigs.cc
        store.cc
        upgrade-nix.cc
        verify.cc
        why-depends.cc
)

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