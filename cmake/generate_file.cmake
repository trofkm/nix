function(generate_inline_file filepath)
    get_filename_component(filename ${filepath} NAME)
    get_filename_component(directory ${filepath} DIRECTORY ABSOLUTE)
    file(READ ${filepath} content)
    set(content "R\"foo(${content})foo\"")
    message(STATUS "Writing ${directory}/${filename}.gen.hh")
    file(WRITE "${directory}/${filename}.gen.hh" "${content}")
endfunction()


function(generate_inline_file_in_dir filepath destination)
    get_filename_component(filename ${filepath} NAME)
    get_filename_component(directory ${filepath} DIRECTORY ABSOLUTE)
    file(READ ${filepath} content)
    set(content "R\"foo(${content})foo\"")
    message(STATUS "Writing ${destination}/${filename}.gen.hh")
    file(WRITE "${destination}/${filename}.gen.hh" "${content}")
endfunction()