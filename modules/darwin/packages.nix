{ pkgs }:

let
  groups = import ../shared/package-groups.nix { inherit pkgs; };
in
groups.shared ++ groups.darwin
