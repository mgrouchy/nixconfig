{ config, pkgs, inputs, ... }:

let
  # AI tools from the nix-ai-tools flake
  ai = inputs."nix-ai-tools".packages.${pkgs.system};
in
{

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowBroken = true;
      allowInsecure = false;
      allowUnsupportedSystem = true;
    };

    overlays =
      # Apply each overlay found in the /overlays directory
      let path = ../../overlays; in with builtins;
      map (n: import (path + ("/" + n)))
          (filter (n: match ".*\\.nix" n != null ||
                      pathExists (path + ("/" + n + "/default.nix")))
                  (attrNames (readDir path)));
  };

  # Shared AI tools across Darwin and NixOS (from nix-ai-tools flake)
  environment.systemPackages = with ai; [
    claude-code
    gemini-cli
    qwen-code
  ];
}
