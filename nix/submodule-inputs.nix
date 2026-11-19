# SPDX-License-Identifier: GPL-2.0-or-later
# The flake materializes 3rdparty/<input name> from its inputs alone, so what a
# checkout gets from `git submodule update --init --recursive` has to come from
# the inputs themselves. Two things can therefore be missing without anything
# saying so until CMake configures: a submodule recorded in .gitmodules with no
# input of the same name, and a submodule of a submodule, which the github
# scheme cannot fetch because it serves tarballs. This checks both against the
# fetched sources and names what is short.
{
  lib,
  runCommand,
  git,
  gitmodules,
  submodules,
}:

runCommand "anyps5-submodule-inputs"
  {
    nativeBuildInputs = [ git ];
    inherit gitmodules;
    declared = lib.concatStringsSep "\n" (lib.attrNames submodules);
    sources = lib.concatStringsSep "\n" (
      lib.mapAttrsToList (name: source: "${name} ${source}") submodules
    );
  }
  ''
    export LC_ALL=C

    listSubmodulePaths() {
      git config --file "$1" --get-regexp '^submodule\..*\.path$' | cut -d' ' -f2-
    }

    listSubmodulePaths "$gitmodules" | sed 's|^3rdparty/||' | sort > recorded
    printf '%s\n' "$declared" | sort > declared

    missing=$(comm -23 recorded declared)
    unused=$(comm -13 recorded declared)

    if [ -n "$missing" ]; then
      echo "These submodules in .gitmodules have no flake input of the same name:" >&2
      echo "$missing" | sed 's|^|  |' >&2
      echo "Add an input for each, named after its directory under 3rdparty." >&2
    fi
    if [ -n "$unused" ]; then
      echo "These flake inputs match no submodule in .gitmodules:" >&2
      echo "$unused" | sed 's|^|  |' >&2
      echo "Remove each input, or restore the submodule it was added for." >&2
    fi

    printf '%s\n' "$sources" | while read -r name source; do
      [ -s "$source/.gitmodules" ] || continue
      listSubmodulePaths "$source/.gitmodules" | while read -r nested; do
        if [ -z "$(ls -A "$source/$nested" 2>/dev/null)" ]; then
          echo "The $name input is missing its own submodule $nested." >&2
          echo "Fetch it with git+<its clone url>?rev=<commit>&submodules=1," >&2
          echo "because the github scheme serves tarballs without submodules." >&2
          touch nested-missing
        fi
      done
    done

    if [ -n "$missing" ] || [ -n "$unused" ] || [ -e nested-missing ]; then
      exit 1
    fi

    touch "$out"
  ''
