add_library(nix-build nix-build.cc)

target_link_libraries(nix-build PRIVATE libcmd)