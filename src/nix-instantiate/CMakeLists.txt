add_library(nix-instantiate STATIC nix-instantiate.cc)

target_link_libraries(nix-instantiate PRIVATE libcmd)