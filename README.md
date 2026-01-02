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

## Customization

To use this config for yourself:

1. **Set your username** in `flake.nix`:
   ```nix
   user = "yourusername";
   ```

2. **Set your git identity** in `modules/shared/home-manager.nix`:
   ```nix
   let name = "Your Name";
       user = "yourusername";
       email = "you@example.com"; in
   ```

3. **For NixOS**: Set your hostname in `hosts/nixos/default.nix`:
   ```nix
   networking.hostName = "yourhostname";
   ```
   Or run `nix run .#apply` which will prompt you for hostname and replace the `%HOST%` placeholder.

4. **Optional**: Add your SSH public key to `hosts/nixos/default.nix` if using NixOS:
   ```nix
   sshKeys = [
     "ssh-ed25519 AAAA..."
   ];
   ```

## License

BSD 3-Clause. See [LICENSE](LICENSE).
