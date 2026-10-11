{
  lib,
  stdenv,
  src,
  version,
  thirdParty,
  callPackage,
  cmake,
  makeWrapper,
  ninja,
  patchelf,
  pkg-config,
  python3,
  # SPIR-V validation and optimization of every recompiled shader. The upstream
  # default is off; the Linux CI job builds with it on.
  enableSpirvTools ? false,
}:

let
  hostLibraries = callPackage ./host-libraries.nix { };
  libc = callPackage ./libc.nix { };
  ffmpeg = callPackage ./ffmpeg-core.nix { rev = thirdParty.shortRev "ffmpeg-core"; };
in
stdenv.mkDerivation {
  pname = "anyps5";
  inherit src version;

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    makeWrapper
    ninja
    pkg-config
    python3
  ];

  buildInputs = hostLibraries ++ [ libc.static ];

  postPatch = thirdParty.link ".";

  cmakeFlags = [
    (lib.cmakeBool "ANYPS5_ENABLE_SPIRV_TOOLS" enableSpirvTools)
    (lib.cmakeFeature "FFMPEG_PREBUILT_DIR" "${ffmpeg}")
  ]
  ++ libc.cmakeFlags;

  # Every library under core/libs/prx is EXCLUDE_FROM_ALL, so the default target
  # alone leaves the patched .prx files a converted title loads unbuilt.
  ninjaFlags = [
    "all"
    "libs"
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 core/relinker/relinker core/libs/nid_patcher -t "$out/bin"
    install -Dm755 core/libs/libs/*.prx -t "$out/lib/anyps5"

    runHook postInstall
  '';

  # A converted title searches for its system libraries where the relinker's
  # --rpath points, which leaves every caller to name this package's library
  # directory. anyps5 is the relinker with that directory already supplied; the
  # option can be given again to choose another one, because the relinker keeps
  # the last --rpath it is passed.
  postInstall = ''
    makeWrapper "$out/bin/relinker" "$out/bin/anyps5" \
      --add-flags "--rpath $out/lib/anyps5"
  '';

  # SDL2 and the Vulkan loader are linked in statically and reach the host's
  # display, input and audio stacks with dlopen, which leaves no DT_NEEDED entry
  # for the rpath shrinking in fixupPhase to keep. Each library already resolves
  # its siblings through $ORIGIN, which this appends to.
  postFixup = ''
    for library in "$out"/lib/anyps5/*.prx; do
      ${lib.getExe' patchelf "patchelf"} --add-rpath "${lib.makeLibraryPath hostLibraries}" "$library"
    done
  '';

  meta = {
    description = "Ports PS5 executables to Linux and Windows without emulation";
    longDescription = ''
      The relinker, the NID patcher and the system libraries a converted title
      links against.

      anyps5 converts a title and points it at the libraries in this package:

        anyps5 source/input.elf app.elf

      relinker is the converter as the usage documentation describes it, which
      expects the libraries beside the output in libs/ unless --rpath names
      another directory.

      A converted Linux executable asks for the interpreter
      /lib64/ld-linux-x86-64.so.2, which NixOS only provides with
      programs.nix-ld.enable, and its Vulkan device comes from the host's
      graphics drivers.
    '';
    homepage = "https://github.com/boykopovar/AnyPS5";
    license = lib.licenses.gpl2Only;
    mainProgram = "anyps5";
    platforms = [ "x86_64-linux" ];
  };
}
