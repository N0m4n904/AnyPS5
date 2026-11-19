{
  description = "Automatic porting of PS5 executables to Linux and Windows";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # The 3rdparty git submodules, pinned to the commits recorded in the index.
    # Every input except nixpkgs is materialized as 3rdparty/<input name>, so an
    # input's name is its submodule directory and adding a submodule needs
    # nothing beyond a new input here.
    LibAtrac9 = {
      url = "github:shadps4-emu/ext-LibAtrac9/946e05a9212976626a9f5e52f29c0a7202871f29";
      flake = false;
    };
    SDL2 = {
      url = "github:libsdl-org/SDL/74be4c2836da0940f0144d0d97852606f9ab11e9";
      flake = false;
    };
    SPIRV-Headers = {
      url = "github:KhronosGroup/SPIRV-Headers/b824a462d4256d720bebb40e78b9eb8f78bbb305";
      flake = false;
    };
    SPIRV-Tools = {
      url = "github:KhronosGroup/SPIRV-Tools/262bdab48146c937467f826699a40da0fdfc0f1a";
      flake = false;
    };
    Vulkan-Headers = {
      url = "github:KhronosGroup/Vulkan-Headers/2fa203425eb4af9dfc6b03f97ef72b0b5bcb8350";
      flake = false;
    };
    VulkanMemoryAllocator = {
      url = "github:GPUOpen-LibrariesAndSDKs/VulkanMemoryAllocator/a1d434708c217b2a6c7b365f1fe41fa03a562e59";
      flake = false;
    };
    ZArchive = {
      url = "github:Exzap/ZArchive/965b66c8d67b6b7e30fd63b3b75aa91a99ff303b";
      flake = false;
    };
    cairo = {
      url = "git+https://gitlab.freedesktop.org/cairo/cairo.git?rev=3909090108bb2db55330e3eb148aebe664735363";
      flake = false;
    };
    curl = {
      url = "github:curl/curl/801bd5138ce31aa0d906fa4e2eabfc599d74e793";
      flake = false;
    };
    ffmpeg-core = {
      url = "github:KytyPS5/ext-ffmpeg-core/9ac4cfd195f192ed8b08566f49c28dbb48d08341";
      flake = false;
    };
    fontconfig = {
      url = "github:fontconfig/fontconfig/72b9a48f57de6204d99ce1c217b5609ee92ece9b";
      flake = false;
    };
    freetype = {
      url = "git+https://github.com/freetype/freetype.git?rev=37515cf56ba3349656049edbed89ffc6f6466f2d&submodules=1";
      flake = false;
    };
    glslang = {
      url = "github:KhronosGroup/glslang/ba1640446f3826a518721d1f083f3a8cca1120c3";
      flake = false;
    };
    harfbuzz = {
      url = "github:harfbuzz/harfbuzz/a1d9bfe62818ef0fa9cf63b6e6d51436b1c93cbc";
      flake = false;
    };
    icu = {
      url = "github:unicode-org/icu/049e0d6a420629ac7db77256987d083a563287b5";
      flake = false;
    };
    jxrlib = {
      url = "github:4creators/jxrlib/f7521879862b9085318e814c6157490dd9dbbdb4";
      flake = false;
    };
    libfvad = {
      url = "github:dpirch/libfvad/532ab666c20d3cfda38bca63abbb0f152706c369";
      flake = false;
    };
    libjpeg-turbo = {
      url = "github:libjpeg-turbo/libjpeg-turbo/c85e6b905bf237038faa936dab160ebfc5da0344";
      flake = false;
    };
    libpng = {
      url = "github:pnggroup/libpng/cd952f49f95bb27154ae77dbb103032d95f6e580";
      flake = false;
    };
    libpsl = {
      url = "git+https://github.com/rockdaboot/libpsl.git?rev=ba4c49a205408845834b1648ad23c15ee09f722b&submodules=1";
      flake = false;
    };
    libressl-openbsd = {
      url = "github:libressl/openbsd/078b3d1df8ca2011c1605cd40418c58fa0f5b143";
      flake = false;
    };
    libusb-cmake = {
      url = "github:libusb/libusb-cmake/bea6567b63796ab27c1c33257d230284fb2d8316";
      flake = false;
    };
    libwpe = {
      url = "github:WebPlatformForEmbedded/libwpe/b90a8396864c9824a43838a5879f6ab01420c69e";
      flake = false;
    };
    libxml2 = {
      url = "github:GNOME/libxml2/7846b0a677f8d3ce72486125fa281e92ac9970e8";
      flake = false;
    };
    mbedtls = {
      url = "git+https://github.com/Mbed-TLS/mbedtls.git?rev=068ff080b369adfac81509f9b57b2afabaf82dc5&submodules=1";
      flake = false;
    };
    mimalloc = {
      url = "github:microsoft/mimalloc/f8401befa675adb13b98decababd7fdc59572477";
      flake = false;
    };
    nghttp2 = {
      url = "git+https://github.com/nghttp2/nghttp2.git?rev=85e300c79fb6dbcfa9c1013215c8710c1c2cd3d2&submodules=1";
      flake = false;
    };
    ogg = {
      url = "github:xiph/ogg/be05b13e98b048f0b5a0f5fa8ce514d56db5f822";
      flake = false;
    };
    opus = {
      url = "github:xiph/opus/22244de5a79bd1d6d623c32e72bf1954b56235be";
      flake = false;
    };
    pixman = {
      url = "git+https://gitlab.freedesktop.org/pixman/pixman.git?rev=37216a32839f59e8dcaa4c3951b3fcfc3f07852c";
      flake = false;
    };
    quickjs = {
      url = "git+https://github.com/quickjs-ng/quickjs.git?rev=6d46d07d04041b40f4f49eaa7fdebe44c314c699&submodules=1";
      flake = false;
    };
    sqlite = {
      url = "github:sqlite/sqlite/57520227c95396ce39ba6ecaac8d475b78dd3964";
      flake = false;
    };
    stb = {
      url = "github:nothings/stb/2c980bb59875b0d32144a71867fbdebb2f77cd20";
      flake = false;
    };
    tracy = {
      url = "github:wolfpld/tracy/30997d5ca6bb632cc10807a1da8a6d3de0aeeb3c";
      flake = false;
    };
    vgmstream = {
      url = "github:vgmstream/vgmstream/7c520e8f9b078dfde2f84f1b5bcbad0c6c415806";
      flake = false;
    };
    vorbis = {
      url = "github:xiph/vorbis/c2aa86b05e981c96bf381fc6aa11cdd03eccc2fb";
      flake = false;
    };
    zlib = {
      url = "github:madler/zlib/da607da739fa6047df13e66a2af6b8bec7c2a498";
      flake = false;
    };
    zstd = {
      url = "github:facebook/zstd/f8745da6ff1ad1e7bab384bd1f9d742439278e99";
      flake = false;
    };
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    let
      inherit (nixpkgs) lib;

      # The relinker is a self-contained converter and builds on any host. The
      # system libraries and their guest ABI are x86-64 only, as is the FFmpeg
      # package the root CMakeLists requests through ARCHITECTURE.
      relinkerSystems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      runtimeSystems = [ "x86_64-linux" ];

      thirdParty = import ./nix/third-party.nix {
        inherit lib;
        submodules = lib.removeAttrs inputs [
          "self"
          "nixpkgs"
        ];
      };

      version = "0-unstable-${self.shortRev or self.dirtyShortRev or "dev"}";

      # The build reads the CMake projects, the Python test tooling, the
      # documents the convention tests parse and the third-party sources
      # committed to the tree rather than tracked as a submodule; nothing else
      # in the tree changes its result, and the byte code a local test run
      # leaves behind must not.
      src = lib.fileset.toSource {
        root = ./.;
        fileset =
          let
            sources = lib.fileset.fileFilter (file: !file.hasExt "pyc");
          in
          lib.fileset.unions [
            ./CMakeLists.txt
            (sources ./cmake)
            (sources ./core)
            (sources ./tools)
            (sources ./docs)
            (sources ./3rdparty/FidelityFX-FSR)
          ];
      };

      eachSystem = systems: attrs: lib.genAttrs systems (system: attrs nixpkgs.legacyPackages.${system});

      allSystems = lib.unique (relinkerSystems ++ runtimeSystems);

      supports = systems: pkgs: lib.elem pkgs.stdenv.hostPlatform.system systems;

      packagesFor =
        pkgs:
        lib.optionalAttrs (supports relinkerSystems pkgs) {
          relinker = pkgs.callPackage ./nix/relinker.nix { inherit src version; };
        }
        // lib.optionalAttrs (supports runtimeSystems pkgs) {
          anyps5 = pkgs.callPackage ./nix/anyps5.nix { inherit src version thirdParty; };
        };
    in
    {
      # The full build is the default where it is available; elsewhere the
      # relinker is everything this flake can offer.
      packages = eachSystem allSystems (
        pkgs:
        let
          available = packagesFor pkgs;
        in
        available // { default = available.anyps5 or available.relinker; }
      );

      checks = eachSystem allSystems (
        pkgs:
        packagesFor pkgs
        // {
          submodule-inputs = pkgs.callPackage ./nix/submodule-inputs.nix {
            gitmodules = ./.gitmodules;
            inherit (thirdParty) submodules;
          };
        }
      );

      devShells = eachSystem allSystems (pkgs: {
        default = pkgs.callPackage ./nix/shell.nix { inherit thirdParty; };
      });

      formatter = eachSystem allSystems (pkgs: pkgs.nixfmt-tree);
    };
}
