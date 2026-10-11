# The pinned 3rdparty submodules, as the data the build and the dev shell share.
{
  lib,
  submodules,
}:

{
  inherit submodules;

  # The commit of a pinned submodule, abbreviated the way the submodule's own
  # CMake code abbreviates `git rev-parse --short=12 HEAD`.
  shortRev =
    name:
    lib.substring 0 12 (
      submodules.${name}.rev
        or (throw "The ${name} flake input has no revision; pin it to a commit instead of a local path")
    );

  # Shell fragment that populates <root>/3rdparty with the pinned submodules,
  # the state `git submodule update --init --recursive` produces in a checkout.
  # <root> is interpolated inside the quotes it needs, so a caller passes a bare
  # path or shell expansion.
  #
  # A checkout holds an empty directory per uninitialized submodule, and an
  # initialized one holds its sources, which this keeps: replacing a link or an
  # empty directory is all a working tree ever needs here.
  link = root: ''
    linkPinnedSubmodule() {
      local target="${root}/3rdparty/$2"
      if [ -d "$target" ] && [ ! -L "$target" ] && [ -n "$(ls -A "$target")" ]; then
        echo "3rdparty/$2 already has sources, keeping them" >&2
        return
      fi
      rm -rf "$target"
      ln -s "$1" "$target"
    }

    mkdir -p "${root}/3rdparty"
    ${lib.concatLines (
      lib.mapAttrsToList (name: source: ''linkPinnedSubmodule "${source}" "${name}"'') submodules
    )}
  '';
}
