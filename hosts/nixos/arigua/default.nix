_:

{
  imports = [
    ../../../modules/nixos/disk-config.nix
    ../../../modules/shared
    ./boot.nix
    ./desktop.nix
    ./networking.nix
    ./services.nix
    ./system.nix
    ./users.nix
  ];

  system.stateVersion = "21.05";
}
