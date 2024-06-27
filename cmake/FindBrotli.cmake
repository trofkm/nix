# This module defines
#  BROTLI_INCLUDE_DIR, directory containing headers
#  BROTLI_LIBS, directory containing brotli libraries
#  BROTLI_STATIC_LIB, path to libbrotli.a
#  BROTLI_SHARED_LIB, path to libbrotli's shared library
#  BROTLI_FOUND, whether brotli has been found

set(BROTLI_HOME "/usr")

find_path(BROTLI_INCLUDE_DIR NAMES brotli/decode.h
        PATHS ${BROTLI_HOME}
        NO_DEFAULT_PATH
        PATH_SUFFIXES "include" )

find_library(BROTLI_LIBRARY_ENC NAMES brotlienc.a brotlienc
        PATHS ${BROTLI_HOME}
        NO_DEFAULT_PATH
        PATH_SUFFIXES "lib/${CMAKE_LIBRARY_ARCHITECTURE}" "lib" )

find_library(BROTLI_LIBRARY_DEC NAMES libbrotlidec.a brotlidec
        PATHS ${BROTLI_HOME}
        NO_DEFAULT_PATH
        PATH_SUFFIXES "lib/${CMAKE_LIBRARY_ARCHITECTURE}" "lib" )

find_library(BROTLI_LIBRARY_COMMON NAMES libbrotlicommon.a brotlicommon
        PATHS ${BROTLI_HOME}
        NO_DEFAULT_PATH
        PATH_SUFFIXES "lib/${CMAKE_LIBRARY_ARCHITECTURE}" "lib" )

set(BROTLI_LIBRARIES ${BROTLI_LIBRARY_ENC} ${BROTLI_LIBRARY_DEC}
        ${BROTLI_LIBRARY_COMMON})

if (BROTLI_INCLUDE_DIR AND (PARQUET_MINIMAL_DEPENDENCY OR BROTLI_LIBRARIES))
    set(BROTLI_FOUND TRUE)
    get_filename_component( BROTLI_LIBS ${BROTLI_LIBRARY_ENC} PATH )
    set(BROTLI_LIB_NAME brotli)
    if (MSVC AND NOT BROTLI_MSVC_STATIC_LIB_SUFFIX)
        set(BROTLI_MSVC_STATIC_LIB_SUFFIX _static)
    endif()
    set(BROTLI_STATIC_LIB
            ${BROTLI_LIBS}/${CMAKE_STATIC_LIBRARY_PREFIX}${BROTLI_LIB_NAME}enc${BROTLI_MSVC_STATIC_LIB_SUFFIX}${CMAKE_STATIC_LIBRARY_SUFFIX}
            ${BROTLI_LIBS}/${CMAKE_STATIC_LIBRARY_PREFIX}${BROTLI_LIB_NAME}dec${BROTLI_MSVC_STATIC_LIB_SUFFIX}${CMAKE_STATIC_LIBRARY_SUFFIX}
            ${BROTLI_LIBS}/${CMAKE_STATIC_LIBRARY_PREFIX}${BROTLI_LIB_NAME}common${BROTLI_MSVC_STATIC_LIB_SUFFIX}${CMAKE_STATIC_LIBRARY_SUFFIX})
    set(BROTLI_STATIC_LIBRARY_ENC ${BROTLI_LIBS}/${CMAKE_STATIC_LIBRARY_PREFIX}${BROTLI_LIB_NAME}enc${BROTLI_MSVC_STATIC_LIB_SUFFIX}${CMAKE_STATIC_LIBRARY_SUFFIX})
    set(BROTLI_STATIC_LIBRARY_DEC ${BROTLI_LIBS}/${CMAKE_STATIC_LIBRARY_PREFIX}${BROTLI_LIB_NAME}dec${BROTLI_MSVC_STATIC_LIB_SUFFIX}${CMAKE_STATIC_LIBRARY_SUFFIX})
    set(BROTLI_STATIC_LIBRARY_COMMON ${BROTLI_LIBS}/${CMAKE_STATIC_LIBRARY_PREFIX}${BROTLI_LIB_NAME}common${BROTLI_MSVC_STATIC_LIB_SUFFIX}${CMAKE_STATIC_LIBRARY_SUFFIX})
    set(BROTLI_SHARED_LIB
            ${BROTLI_LIBS}/${CMAKE_SHARED_LIBRARY_PREFIX}${BROTLI_LIB_NAME}enc${CMAKE_SHARED_LIBRARY_SUFFIX}
            ${BROTLI_LIBS}/${CMAKE_SHARED_LIBRARY_PREFIX}${BROTLI_LIB_NAME}dec${CMAKE_SHARED_LIBRARY_SUFFIX}
            ${BROTLI_LIBS}/${CMAKE_SHARED_LIBRARY_PREFIX}${BROTLI_LIB_NAME}common${CMAKE_SHARED_LIBRARY_SUFFIX})
else ()
    set(BROTLI_FOUND FALSE)
endif ()

if (BROTLI_FOUND)
    if (NOT Brotli_FIND_QUIETLY)
        if (PARQUET_MINIMAL_DEPENDENCY)
            message(STATUS "Found the Brotli headers: ${BROTLI_INCLUDE_DIR}")
        else ()
            message(STATUS "Found the Brotli library: ${BROTLI_LIBRARIES}")
        endif ()
    endif ()
else ()
    if (NOT Brotli_FIND_QUIETLY)
        set(BROTLI_ERR_MSG "Could not find the Brotli library. Looked in ")
        set(BROTLI_ERR_MSG "${BROTLI_ERR_MSG} in ${BROTLI_HOME}.")
        if (Brotli_FIND_REQUIRED)
            message(FATAL_ERROR "${BROTLI_ERR_MSG}")
        else (Brotli_FIND_REQUIRED)
            message(STATUS "${BROTLI_ERR_MSG}")
        endif (Brotli_FIND_REQUIRED)
    endif ()
endif ()

mark_as_advanced(
        BROTLI_INCLUDE_DIR
        BROTLI_LIBS
        BROTLI_LIBRARIES
        BROTLI_STATIC_LIB
        BROTLI_SHARED_LIB
)