{ pkgs }:

let
  groups = import ./package-groups.nix { inherit pkgs; };
in
groups.shared
