add_library(nix-store STATIC nix-store.cc dotgraph.cc graphml.cc)

target_link_libraries(nix-store PRIVATE libcmd)