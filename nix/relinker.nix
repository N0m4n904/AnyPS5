{
  lib,
  stdenv,
  src,
  version,
  callPackage,
  cmake,
  ctestCheckHook,
  git,
  ninja,
  python3,
}:

let
  libc = callPackage ./libc.nix { };
in
stdenv.mkDerivation {
  pname = "anyps5-relinker";
  inherit src version;

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    ninja
    python3
    ctestCheckHook
  ];

  buildInputs = [ libc.static ];

  cmakeFlags = [
    (lib.cmakeBool "ANYPS5_RELINKER_ONLY" true)
    (lib.cmakeBool "BUILD_TESTING" true)
  ]
  ++ libc.cmakeFlags;

  doCheck = true;

  # Run ctest directly instead of through ninja's `test` target, which ignores
  # the excluded tests below.
  dontUseNinjaCheck = true;

  nativeCheckInputs = [ git ];

  # The convention and pull request tests build throwaway git repositories, and
  # the relinker tests write and run converted executables, both below $TMPDIR.
  preCheck = ''
    export HOME="$TMPDIR"
  '';

  ctestFlags = [ "--timeout=120" ];

  # A converted Linux executable asks for the interpreter that
  # core/relinker/elfpatcher/src/linux/LinuxElfPatcher.cpp hardcodes,
  # /lib64/ld-linux-x86-64.so.2, which no build sandbox provides. These two
  # tests run their own output; every other test only inspects it.
  disabledTests = [
    "linux_entry_argv"
    "linux_program_header_order"
  ];

  # The project installs nothing: the relinker is a single self-contained
  # executable that the usage documentation invokes from the build tree.
  installPhase = ''
    runHook preInstall

    install -Dm755 core/relinker/relinker -t "$out/bin"

    runHook postInstall
  '';

  meta = {
    description = "Converter that rewrites PS5 executables into native Linux, Windows and macOS binaries";
    longDescription = ''
      The relinker alone, built without the system libraries and third-party
      dependencies. It converts an executable and its bundled modules to the
      target system's native format; running a converted title also needs the
      system libraries from the anyps5 package.
    '';
    homepage = "https://github.com/boykopovar/AnyPS5";
    license = lib.licenses.gpl2Only;
    mainProgram = "relinker";
    platforms = lib.platforms.linux;
  };
}
