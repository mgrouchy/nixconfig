{
  description = "Starter Configuration for MacOS and NixOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew = {
      url = "github:zhaofengli-wip/nix-homebrew";
    };
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    homebrew-cmux = {
      url = "github:manaflow-ai/homebrew-cmux";
      flake = false;
    };
    homebrew-varlock = {
      url = "github:dmno-dev/homebrew-tap";
      flake = false;
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      darwin,
      nix-homebrew,
      homebrew-bundle,
      homebrew-core,
      homebrew-cask,
      homebrew-cmux,
      homebrew-varlock,
      home-manager,
      nixpkgs,
      disko,
      ...
    }@inputs:
    let
      user = "mgrouchy";
      # NixOS-specific settings
      hostName = "arigua";
      primaryInterface = "eth0"; # change to your interface (run: ip link)
      linuxSystems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      darwinSystems = [
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      forAllSystems = f: nixpkgs.lib.genAttrs (linuxSystems ++ darwinSystems) f;
      devShell =
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default =
            with pkgs;
            mkShell {
              nativeBuildInputs = with pkgs; [
                bashInteractive
                git
              ];
              shellHook = with pkgs; ''
                export EDITOR=vim
              '';
            };
        };
      mkCheck =
        system: name: command:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        pkgs.runCommand "${name}-${system}"
          {
            nativeBuildInputs = with pkgs; [
              deadnix
              findutils
              nixfmt
              statix
            ];
          }
          ''
            set -eu
            cd ${self}
            ${command}
            mkdir -p "$out"
          '';
      mkChecks = system: {
        nixfmt = mkCheck system "nixfmt" ''
          nixfmt --check flake.nix hosts/darwin/default.nix modules/shared/packages.nix
        '';
        deadnix = mkCheck system "deadnix" ''
          deadnix --fail flake.nix hosts/darwin/default.nix modules/shared/packages.nix
        '';
        statix = mkCheck system "statix" ''
          statix check flake.nix
          statix check hosts/darwin/default.nix
          statix check modules/shared/packages.nix
        '';
      };
      mkApp = scriptName: system: {
        type = "app";
        program = "${
          (nixpkgs.legacyPackages.${system}.writeScriptBin scriptName ''
            #!/usr/bin/env bash
            PATH=${nixpkgs.legacyPackages.${system}.git}/bin:$PATH
            echo "Running ${scriptName} for ${system}"
            exec ${self}/apps/${system}/${scriptName}
          '')
        }/bin/${scriptName}";
      };
      mkLinuxApps = system: {
        "apply" = mkApp "apply" system;
        "build-switch" = mkApp "build-switch" system;
        "copy-keys" = mkApp "copy-keys" system;
        "create-keys" = mkApp "create-keys" system;
        "check-keys" = mkApp "check-keys" system;
        "install" = mkApp "install" system;
      };
      mkDarwinApps = system: {
        "apply" = mkApp "apply" system;
        "build" = mkApp "build" system;
        "build-switch" = mkApp "build-switch" system;
        "copy-keys" = mkApp "copy-keys" system;
        "create-keys" = mkApp "create-keys" system;
        "check-keys" = mkApp "check-keys" system;
        "rollback" = mkApp "rollback" system;
      };
    in
    {
      devShells = forAllSystems devShell;
      checks = forAllSystems mkChecks;
      apps =
        nixpkgs.lib.genAttrs linuxSystems mkLinuxApps // nixpkgs.lib.genAttrs darwinSystems mkDarwinApps;

      darwinConfigurations = nixpkgs.lib.genAttrs darwinSystems (
        system:
        darwin.lib.darwinSystem {
          inherit system;
          specialArgs = inputs // {
            inherit inputs user;
          };
          modules = [
            home-manager.darwinModules.home-manager
            nix-homebrew.darwinModules.nix-homebrew
            {
              nix-homebrew = {
                inherit user;
                enable = true;
                taps = {
                  "homebrew/homebrew-core" = homebrew-core;
                  "homebrew/homebrew-cask" = homebrew-cask;
                  "homebrew/homebrew-bundle" = homebrew-bundle;
                  "manaflow-ai/homebrew-cmux" = homebrew-cmux;
                  "dmno-dev/homebrew-tap" = homebrew-varlock;
                };
                mutableTaps = false;
                autoMigrate = true;
              };
            }
            ./hosts/darwin
          ];
        }
      );

      nixosConfigurations = nixpkgs.lib.genAttrs linuxSystems (
        system:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = inputs // {
            inherit
              inputs
              user
              hostName
              primaryInterface
              ;
          };
          modules = [
            disko.nixosModules.disko
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = { inherit user; };
                users.${user} = import ./modules/nixos/home-manager.nix;
              };
            }
            ./hosts/nixos
          ];
        }
      );
    };
}
