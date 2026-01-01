{ pkgs, inputs, ... }:

let
  ai = inputs."nix-ai-tools".packages.${pkgs.system};
in {
  # Add AI CLI tools from numtide/nix-ai-tools to system packages
  environment.systemPackages = with ai; [
    claude-code
    gemini-cli
    codex
  ];
}
