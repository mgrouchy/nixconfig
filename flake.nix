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
      inherit (nixpkgs) lib;
      user = "mgrouchy";
      nixosHost = import ./hosts/nixos/host.nix;
      linuxSystems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      darwinSystems = [
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      forAllSystems = f: lib.genAttrs (linuxSystems ++ darwinSystems) f;
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
                export EDITOR=nvim
                export VISUAL=nvim
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
            ${command}
            mkdir -p "$out"
          '';
      mkLintChecks = system: {
        nixfmt = mkCheck system "nixfmt" ''
          find ${self} -type f -name '*.nix' -print0 | xargs -0 nixfmt --check
        '';
        deadnix = mkCheck system "deadnix" ''
          find ${self} -type f -name '*.nix' -print0 | xargs -0 deadnix --fail
        '';
        statix = mkCheck system "statix" ''
          find ${self} -type f -name '*.nix' -print0 | xargs -0 -n1 statix check
        '';
      };
      mkCheckApp =
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          targets = [
            "${self}#checks.${system}.nixfmt"
            "${self}#checks.${system}.deadnix"
            "${self}#checks.${system}.statix"
          ]
          ++ lib.optionals (lib.elem system darwinSystems) [ "${self}#checks.${system}.darwin-system" ]
          ++ lib.optionals (lib.elem system nixosHost.supportedSystems) [
            "${self}#checks.${system}.nixos-system"
          ];
          targetArgs = lib.concatStringsSep " " (map lib.escapeShellArg targets);
        in
        {
          type = "app";
          program = "${(pkgs.writeShellScriptBin "check" ''
            exec ${pkgs.nix}/bin/nix build --no-link ${targetArgs}
          '')}/bin/check";
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
        "check" = mkCheckApp system;
        "install" = mkApp "install" system;
      };
      mkDarwinApps = system: {
        "apply" = mkApp "apply" system;
        "build" = mkApp "build" system;
        "build-switch" = mkApp "build-switch" system;
        "check" = mkCheckApp system;
        "copy-keys" = mkApp "copy-keys" system;
        "create-keys" = mkApp "create-keys" system;
        "check-keys" = mkApp "check-keys" system;
        "rollback" = mkApp "rollback" system;
      };
    in
    {
      devShells = forAllSystems devShell;
      checks = forAllSystems (
        system:
        mkLintChecks system
        // lib.optionalAttrs (lib.elem system darwinSystems) {
          darwin-system = self.darwinConfigurations.${system}.system;
        }
        // lib.optionalAttrs (lib.elem system nixosHost.supportedSystems) {
          nixos-system = self.nixosConfigurations.${system}.config.system.build.toplevel;
        }
      );
      apps = lib.genAttrs linuxSystems mkLinuxApps // lib.genAttrs darwinSystems mkDarwinApps;

      darwinConfigurations = lib.genAttrs darwinSystems (
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

      nixosConfigurations = lib.genAttrs nixosHost.supportedSystems (
        system:
        lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs user;
            host = nixosHost;
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
