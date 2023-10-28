# Nix

[![Open Collective supporters](https://opencollective.com/nixos/tiers/supporter/badge.svg?label=Supporters&color=brightgreen)](https://opencollective.com/nixos)
[![Test](https://github.com/NixOS/nix/workflows/Test/badge.svg)](https://github.com/NixOS/nix/actions)

Nix is a powerful package manager for Linux and other Unix systems that makes package
management reliable and reproducible. Please refer to the [Nix manual](https://nixos.org/nix/manual)
for more details.

## Installation and first steps

Visit [nix.dev](https://nix.dev) for [installation instructions](https://nix.dev/tutorials/install-nix) and [beginner tutorials](https://nix.dev/tutorials/first-steps).

Full reference documentation can be found in the [Nix manual](https://nixos.org/nix/manual).

## Building And Developing

See our [Hacking guide](https://nixos.org/manual/nix/unstable/contributing/hacking.html) in our manual for instruction on how to
 set up a development environment and build Nix from source.

## Contributing

Check the [contributing guide](./CONTRIBUTING.md) if you want to get involved with developing Nix.

## Additional Resources

- [Nix manual](https://nixos.org/nix/manual)
- [Nix jobsets on hydra.nixos.org](https://hydra.nixos.org/project/nix)
- [NixOS Discourse](https://discourse.nixos.org/)
- [Matrix - #nix:nixos.org](https://matrix.to/#/#nix:nixos.org)

## License

Nix is released under the [LGPL v2.1](./COPYING).

## CMake support

Work in progress. For now, you can use cmake to build nix, but you cannot build tests with cmake.


### Dependencies

- `libboost-context-dev`
- `libsqlite3-dev`
- `libssl-dev`
- `libarchive-dev`
- `curl libcurl4-openssl-dev`
- `libedit-dev`
- `liblowdown-dev`
- `libsodium-dev`
- `libbrotli-dev`
- `libcpuid-dev`
- `bison`
- `flex`
- `nlohmann-json3-dev`
- `libreadline-dev`

if tests enabled:
- `libgtest-dev`
- `librapidcheck-dev`
- `libgmock-dev`

so the dependency installing script may look like this:
```bash
sudo apt install -y libboost-context-dev libsqlite3-dev libssl-dev \
libarchive-dev curl libcurl4-openssl-dev libedit-dev liblowdown-dev \
libsodium-dev libbrotli-dev libcpuid-dev bison flex nlohmann-json3-dev \
libreadline-dev libgtest-dev librapidcheck-dev libgmock-dev
```

### Checklist

- [X] nix built with cmake (main binary is built with cmake)
- [ ] all binaries built with cmake
- [X] add pch (for speeding up builds)
- [X] add ccache (for speeding up builds
- [ ] add toolchains (different values for different platforms)
- [ ] add tests (run tests with cmake)
- [ ] add build rules to .nix file ( for now it does use autoconf and make, so I need to replace that with cmake)
- [X] add gold linker (but I should check if linker is available on that device)
- [ ] add find scripts for all libraries (particularly complete)
- [ ] ci is working with cmake build system
- [X] nix output for cmake is working
- [ ] enable additional optimizations
- [ ] executable size should be as small as possible [article](https://wiki.wxwidgets.org/Reducing_Executable_Size)
- [ ] check how it does create multiple binaries which are symbolic links to the same binary under the hood
- [ ] replace cmake variable for sql statement with file generation
- [ ] lock g++ 13+ version
- [ ] editline declare -DREADLINE version if greater than 1.15.2, otherwise it won't work! what is the difference between readline and editline
- [ ] for some reason lowdown is bsd library with linux wrapper, so we need to link it with bsd in libstore
- [ ] we have a problem on g++-12 with latest nlohmann::json in derivations.cc:1360
- [ ] json-utils.hh have a problems with optional, it seems that it is a bug.