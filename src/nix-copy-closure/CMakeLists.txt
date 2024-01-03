add_library(nix-copy-closure STATIC nix-copy-closure.cc)

target_link_libraries(nix-copy-closure PRIVATE libcmd)