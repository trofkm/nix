

function(determine_platform SYSTEM)
    if (CMAKE_SYSTEM_NAME STREQUAL "Linux")
        set(${SYSTEM} "${CMAKE_SYSTEM_PROCESSOR}_linux" PARENT_SCOPE)
    elseif (CMAKE_SYSTEM_NAME STREQUAL "Darwin")
        set(${SYSTEM} "${CMAKE_SYSTEM_PROCESSOR}_darwin" PARENT_SCOPE)
    else ()
        message(FATAL_ERROR "Unknown platform: ${CMAKE_SYSTEM_NAME}")
    endif ()
endfunction()