# About

Tool for automatic executables porting to Linux and Windows.

Includes a [relinker](core/relinker) that converts executable to the target system's native format and implementations of [system prx libraries](core/libs/prx) suitable for dynamic linking. No emulation or separate runtime process.

[Usage](docs/user/USAGE.md), [Build instructions](docs/dev/BUILD.md), [Architecture](docs/dev/ARCHITECTURE.md), [Technical debt of the project](docs/dev/TechnicalDebt.md), [code style conventions](docs/dev/CONVENTIONS.md), [contributing](CONTRIBUTING.md)

## Status

[![libraries](https://boykopovar.github.io/AnyPS5/badge-libraries.svg)](https://boykopovar.github.io/AnyPS5/) [![shaders](https://boykopovar.github.io/AnyPS5/badge-shaders.svg)](https://boykopovar.github.io/AnyPS5/)

[![progress map](https://boykopovar.github.io/AnyPS5/progress.svg)](https://boykopovar.github.io/AnyPS5/)

<sub>* System libraries: percentage of the functions known to the project so far (declared in [core/libs/prx](core/libs/prx)), not of every PS5 system function. The total grows as more functions are declared.</sub>

[List of verified games](docs/user/COMPATIBILITY.md)

Dreaming Sarah (2D platformer) runs at a stable 60 fps on a GTX 1050 Ti / i5-7500 3.4GHz.

Unsupported or unexpected states strictly throw `std::runtime_error`. `what()` is printed to stderr and the process terminates.

The [shader recompiler](core/shader/recompiler/Recompiler.cpp) successfully produces SPIR-V (validated via [Spirv-Tools](3rdparty/SPIRV-Tools) when built with `ANYPS5_ENABLE_SPIRV_TOOLS`).

## Run from GitHub

With [Nix](https://nixos.org/download/) and flakes enabled, one command converts a title, with no checkout, toolchain or submodule:

```sh
nix run github:N0m4n904/AnyPS5 -- source/input.elf app.elf
./app.elf
```

It fetches this repository's default branch, builds it, caches the result and points the converted executable at the system libraries it just built, so no `libs/` directory has to be assembled by hand. Game resources still belong in `app0/` as [usage](docs/user/USAGE.md) describes. `nix run github:N0m4n904/AnyPS5#relinker` builds the converter alone, without the third-party dependencies, for a title whose libraries are already in place.

The output reads those libraries from the Nix store, where `nix-collect-garbage` can remove them again; `nix profile install github:N0m4n904/AnyPS5` keeps them. For an output that carries its own libraries instead, convert with `--rpath '$ORIGIN/libs'` and copy the `.prx` files into a `libs/` directory beside it.

On NixOS, a converted executable asks for `/lib64/ld-linux-x86-64.so.2`, which `programs.nix-ld.enable` provides, and shared direct memory needs the user in the `kvm` group. [Build instructions](docs/dev/BUILD.md#nix-and-nixos) cover the flake's packages, its dev shell and these requirements.

## Compatibility

See the [game compatibility list](docs/user/COMPATIBILITY.md) for tested games and known issues.

## Input mapping

SDL-mapped game controllers are supported, including analog sticks and triggers. Keyboard and mouse controls can be configured with an `anyps5-input.ini` file. See [input mapping](docs/user/INPUT_MAPPING.md) for the supported devices and configuration format.

## Disclaimer

This project is intended for interoperability, research, preservation, and compatibility purposes. It does not include, distribute, or require copyrighted software, firmware, cryptographic keys, or proprietary libraries. Users are responsible for ensuring that any binaries used with this project are obtained and used in accordance with applicable laws and their respective license terms.

## License

This project is licensed under the GNU General Public License version 2 only.
