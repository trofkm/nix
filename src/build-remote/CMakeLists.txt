add_library(build-remote STATIC build-remote.cc)

target_link_libraries(build-remote PRIVATE libcmd)