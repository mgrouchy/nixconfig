{ pkgs }:

with pkgs;
let shared-packages = import ../shared/packages.nix { inherit pkgs; }; in
shared-packages ++ [
  dockutil
  raycast
  google-chrome
  chatgpt
  #devtools
  code-cursor
  _1password-cli

  
  # A tiny launcher so `ghostty` is on PATH (calls the .app).
  (pkgs.writeShellScriptBin "ghostty" ''
    #!/usr/bin/env bash
    # Prefer direct binary if present; otherwise fall back to open -a.
    APP="/Applications/Ghostty.app/Contents/MacOS/ghostty"
    if [ -x "$APP" ]; then
      exec "$APP" "$@"
    else
      exec /usr/bin/open -a "Ghostty" --args "$@"
    fi
  '')
]
