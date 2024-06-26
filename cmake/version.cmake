
# parse_version(version_file version_var)
function(parse_version_from_file version_file version_var)
    file(STRINGS ${version_file} version_string)
    string(REGEX MATCH "([0-9]+\\.[0-9]+\\.[0-9]+)" version_string ${version_string})
    set(${version_var} ${CMAKE_MATCH_1} PARENT_SCOPE)
endfunction()

function(parse_commit_hash commit_hash)
    execute_process(
            COMMAND git log -1 --format=%h
            WORKING_DIRECTORY ${CMAKE_CURRENT_LIST_DIR}
            OUTPUT_VARIABLE GIT_HASH
            OUTPUT_STRIP_TRAILING_WHITESPACE
    )
    string(STRIP "${GIT_HASH}" commit_hash)
endfunction()