generate_inline_file(${CMAKE_CURRENT_SOURCE_DIR}/unpack-channel.nix)

add_library(nix-channel nix-channel.cc)

target_link_libraries(nix-channel PRIVATE libcmd)