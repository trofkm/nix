add_library(libmain STATIC common-args.cc loggers.cc progress-bar.cc shared.cc stack.cc)

target_include_directories(libmain PUBLIC $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>)

target_link_libraries(libmain PUBLIC libstore libutil)