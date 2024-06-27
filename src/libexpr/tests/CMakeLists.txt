cmake_minimum_required(VERSION 3.2)

project(libexpr-tests LANGUAGES CXX C)


add_executable(libexpr-tests derived-path.cc error_traces.cc flakeref.cc json.cc primops.cc
       search-path.cc trivial.cc
# value
        value/context.cc value/print.cc
)

# FIXME: it depends on code from libstore/tests, so it's not linked now.
target_link_libraries(libexpr-tests PRIVATE gtest gmock gtest_main rapidcheck libexpr)

add_test(NAME libexpr-tests COMMAND libexpr-tests)