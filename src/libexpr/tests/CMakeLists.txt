cmake_minimum_required(VERSION 3.2)


project(libexpr-tests LANGUAGES CXX C)

find_package(rapidcheck REQUIRED)

add_executable(libexpr-tests derived-path.cc error_traces.cc flakeref.cc json.cc primops.cc
       search-path.cc trivial.cc
# value
        value/context.cc value/print.cc
)
target_link_libraries(libexpr-tests PRIVATE gtest gmock gtest_main rapidcheck libexpr)
#target_include_directories(${TARGET_EXECUTABLE}
#        PRIVATE
#        $<BUILD_INTERFACE:${BUILD_INCLUDE_DIRECTORIES}>
#        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>)
#configure_file(config.json config.json)

add_test(NAME libexpr-tests COMMAND libexpr-tests)