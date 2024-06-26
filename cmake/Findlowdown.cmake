
find_path(LOWDOWN_INCLUDE_DIR
        NAMES lowdown.h
        HINTS ${LOWDOWN_ROOT_DIR}/include)

if (LOWDOWN_INCLUDE_DIR)
    # for now version is hardcoded

    set(LOWDOWN_VERSION_MAJOR "1" CACHE STRING "" FORCE)
    set(LOWDOWN_VERSION_MINOR "0" CACHE STRING "" FORCE)
    set(LOWDOWN_VERSION ${LOWDOWN_VERSION_MAJOR}.${LOWDOWN_VERSION_MINOR}
            CACHE STRING "" FORCE)
endif ()

find_library(LOWDOWN_LIBRARIES
        NAMES lowdown
        HINTS ${LOWDOWN_ROOT_DIR}/lib)

if(LOWDOWN_LIBRARIES AND LOWDOWN_INCLUDE_DIR)
    set(LOWDOWN_FOUND TRUE)
endif()
# TODO: add quiet support like in Brotli
if(LOWDOWN_FOUND)
    message(STATUS "Found the lowdown library: ${LOWDOWN_LIBRARIES}")
else()
    message(FATAL_ERROR "Could NOT find the lowdown library")
endif()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(
        lowdown
        DEFAULT_MSG
        LOWDOWN_LIBRARIES
        LOWDOWN_INCLUDE_DIR)

mark_as_advanced(
        LOWDOWN_ROOT_DIR
        LOWDOWN_LIBRARIES
        LOWDOWN_INCLUDE_DIR
        LOWDOWN_VERSION
        LOWDOWN_VERSION_MAJOR
        LOWDOWN_VERSION_MINOR
)