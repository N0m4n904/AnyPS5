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
      url = "github:libsdl-org/SDL/4b69833bc54abf3dd3288d4aa7afbba527775e5b";
      flake = false;
    };
    SPIRV-Headers = {
      url = "github:KhronosGroup/SPIRV-Headers/01e0577914a75a2569c846778c2f93aa8e6feddd";
      flake = false;
    };
    SPIRV-Tools = {
      url = "github:KhronosGroup/SPIRV-Tools/7f2d9ee926f98fc77a3ed1e1e0f113b8c9c49458";
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
    ffmpeg-core = {
      url = "github:KytyPS5/ext-ffmpeg-core/9ac4cfd195f192ed8b08566f49c28dbb48d08341";
      flake = false;
    };
    freetype = {
      url = "github:freetype/freetype/42608f77f20749dd6ddc9e0536788eaad70ea4b5";
      flake = false;
    };
    glslang = {
      url = "github:KhronosGroup/glslang/ba1640446f3826a518721d1f083f3a8cca1120c3";
      flake = false;
    };
    libjpeg-turbo = {
      url = "github:libjpeg-turbo/libjpeg-turbo/c85e6b905bf237038faa936dab160ebfc5da0344";
      flake = false;
    };
    stb = {
      url = "github:nothings/stb/2c980bb59875b0d32144a71867fbdebb2f77cd20";
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

      # The build reads the CMake projects, the Python test tooling and the
      # documents the convention tests parse; nothing else in the tree changes
      # its result, and the byte code a local test run leaves behind must not.
      src = lib.fileset.toSource {
        root = ./.;
        fileset =
          let
            sources = lib.fileset.fileFilter (file: !file.hasExt "pyc");
          in
          lib.fileset.unions [
            ./CMakeLists.txt
            (sources ./core)
            (sources ./tools)
            (sources ./docs)
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

      checks = eachSystem allSystems packagesFor;

      devShells = eachSystem allSystems (pkgs: {
        default = pkgs.callPackage ./nix/shell.nix { inherit thirdParty; };
      });

      formatter = eachSystem allSystems (pkgs: pkgs.nixfmt-tree);
    };
}
