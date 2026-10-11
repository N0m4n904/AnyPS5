{
  lib,
  callPackage,
  mkShell,
  thirdParty,
  ccache,
  cmake,
  git,
  ninja,
  python3,
  vulkan-tools,
  writeShellApplication,
}:

let
  hostLibraries = callPackage ./host-libraries.nix { };
  libc = callPackage ./libc.nix { };
  ffmpeg = callPackage ./ffmpeg-core.nix { rev = thirdParty.shortRev "ffmpeg-core"; };

  # The documented build expects the submodules in place. This links the commits
  # the flake pins, so a checkout needs no further network access and the tree
  # keeps matching flake.lock.
  linkSubmodules = writeShellApplication {
    name = "anyps5-link-submodules";
    runtimeInputs = [ git ];
    text = ''
      root="$(git rev-parse --show-toplevel)"
      ${thirdParty.link "$root"}
      echo "Linked the pinned submodules into $root/3rdparty" >&2
    '';
  };
in
mkShell {
  packages = [
    cmake
    ninja
    python3
    ccache
    vulkan-tools
    linkSubmodules
  ];

  # The host libraries let SDL configure its X11, input and audio backends;
  # the static glibc serves the executables the project links with -static.
  buildInputs = hostLibraries ++ [ libc.static ];

  # CMake seeds its executable, shared and module linker flags from this.
  LDFLAGS = libc.ldflags;

  # Executables and system libraries built in the tree carry no store rpath,
  # so their dlopen of libX11, libvulkan and the audio backends needs this.
  LD_LIBRARY_PATH = lib.makeLibraryPath hostLibraries;

  # A linked submodule has no git metadata, so ffmpeg-core cannot derive the
  # commit its package is published under and tries to download an empty
  # release tag. Configuring with this takes that path out of the build.
  ANYPS5_FFMPEG_PREBUILT_DIR = "${ffmpeg}";

  shellHook = ''
    echo "AnyPS5 dev shell. Link the pinned submodules once with anyps5-link-submodules, then:" >&2
    echo '  cmake -S . -B build -G Ninja -DCMAKE_BUILD_TYPE=Release -DBUILD_TESTING=ON -DFFMPEG_PREBUILT_DIR="$ANYPS5_FFMPEG_PREBUILT_DIR"' >&2
    echo "  cmake --build build && cmake --build build --target libs" >&2
  '';
}
