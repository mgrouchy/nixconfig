# nixos-config

Nix flake configuration for managing macOS (nix-darwin) and NixOS systems. Uses a modular architecture with shared components between platforms.

Based on [dustinlyons/nixos-config](https://github.com/dustinlyons/nixos-config).

## Quick Start

### macOS

```bash
# Initial setup
nix run .#apply

# Build and switch to new configuration
nix run .#build-switch

# Build only (without switching)
nix run .#build

# Rollback to previous generation
nix run .#rollback
```

### NixOS

```bash
# Initial setup
nix run .#apply

# Build and switch
nix run .#build-switch
```

### Development

```bash
# Enter dev shell
nix develop

# Validate flake
nix flake check

# Update inputs
nix flake update
```

## Structure

```
├── hosts/                    # Host-specific configurations
│   ├── darwin/              # macOS configuration
│   └── nixos/               # NixOS configuration
├── modules/                 # Modular components
│   ├── darwin/              # macOS-specific modules
│   ├── nixos/               # NixOS-specific modules
│   └── shared/              # Cross-platform (git, zsh, vim, etc.)
├── overlays/                # Nixpkgs overlays
└── apps/                    # Build scripts per platform/arch
```

## Features

- **Flakes** with nixpkgs, home-manager, nix-darwin, and disko
- **Home Manager** for user-level packages and dotfiles
- **Homebrew integration** on macOS via nix-homebrew
- **Declarative disk management** on NixOS via disko
- **Shared configuration** between macOS and NixOS

## License

BSD 3-Clause. See [LICENSE](LICENSE).
