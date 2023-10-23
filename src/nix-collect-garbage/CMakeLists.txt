add_library(nix-collect-garbage STATIC nix-collect-garbage.cc)

target_link_libraries(nix-collect-garbage PRIVATE libcmd)