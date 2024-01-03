
find_path(CPUID_INCLUDE_DIR
        NAMES libcpuid.h
        # TODO: for some reason it cannot find include headers in the root directory, so for now it will be hardcoded
        HINTS /usr/include/libcpuid)

if (CPUID_INCLUDE_DIR)
    # for now version is hardcoded

    set(CPUID_VERSION_MAJOR "1" CACHE STRING "" FORCE)
    set(CPUID_VERSION_MINOR "0" CACHE STRING "" FORCE)
    set(CPUID_VERSION ${CPUID_VERSION_MAJOR}.${CPUID_VERSION_MINOR}
            CACHE STRING "" FORCE)
endif ()

find_library(CPUID_LIBRARIES
        NAMES cpuid
        HINTS ${CPUID_ROOT_DIR}/lib)

if(CPUID_LIBRARIES AND CPUID_INCLUDE_DIR)
    set(CPUID_FOUND TRUE)
endif()
# TODO: add quiet support like in Brotli
if(CPUID_FOUND)
    message(STATUS "Found the cpuid library: ${CPUID_LIBRARIES}")
else()
    message(FATAL_ERROR "Could NOT find the cpuid library")
endif()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(
        cpuid
        DEFAULT_MSG
        CPUID_LIBRARIES
        CPUID_INCLUDE_DIR)

mark_as_advanced(
        CPUID_ROOT_DIR
        CPUID_LIBRARIES
        CPUID_INCLUDE_DIR
        CPUID_VERSION
        CPUID_VERSION_MAJOR
        CPUID_VERSION_MINOR
)