generate_inline_file(${CMAKE_CURRENT_SOURCE_DIR}/buildenv.nix)

add_library(nix-env STATIC nix-env.cc user-env.cc)

target_link_libraries(nix-env PRIVATE libcmd nlohmann_json::nlohmann_json)