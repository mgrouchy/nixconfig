{ pkgs }:

with pkgs;
let shared-packages = import ../shared/packages.nix { inherit pkgs; }; in
shared-packages ++ [
  dockutil
  raycast
  chatgpt
  code-cursor
  _1password-cli
  caddy
]
