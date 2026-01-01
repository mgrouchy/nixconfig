# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a Nix flake configuration repository for managing both macOS (nix-darwin) and NixOS systems. The configuration uses a modular architecture with shared components between platforms.

## Common Commands

### Build System (macOS)
- **Build only**: `nix run .#build` - Builds the system configuration without switching
- **Build and switch**: `nix run .#build-switch` - Builds and activates the new configuration 
- **Apply configuration**: `nix run .#apply` - Initial setup script that configures user settings
- **Rollback**: `nix run .#rollback` - Rollback to previous generation

### Build System (NixOS)
- **Apply configuration**: `nix run .#apply` - Initial setup script for NixOS systems
- **Build and switch**: `nix run .#build-switch` - Builds and activates new NixOS configuration

### Development
- **Enter dev shell**: `nix develop` - Provides bash and git for development
- **Check flake**: `nix flake check` - Validates the flake configuration
- **Update inputs**: `nix flake update` - Updates all flake inputs

## Architecture

### Directory Structure

```
├── hosts/                    # Host-specific configurations
│   ├── darwin/              # macOS host configuration
│   └── nixos/               # NixOS host configuration
├── modules/                 # Modular configuration components
│   ├── darwin/              # macOS-specific modules
│   ├── nixos/               # NixOS-specific modules  
│   └── shared/              # Cross-platform shared modules
├── overlays/                # Nixpkgs overlays (auto-imported)
└── apps/                    # Platform-specific build scripts
```

### Module System

The configuration uses a three-tier module system:

1. **Shared modules** (`modules/shared/`): Cross-platform configuration for tools like git, zsh, vim, tmux
2. **Platform modules** (`modules/darwin/`, `modules/nixos/`): Platform-specific system configuration
3. **Host modules** (`hosts/`): Final host-specific settings

Each module directory contains:
- `default.nix` - Main module definition
- `packages.nix` - Package lists
- `home-manager.nix` - User-level configuration
- `files.nix` - Static configuration files
- `config/` - Non-Nix configuration files

### Key Configuration Files

- **flake.nix**: Main flake definition with inputs, outputs, and build logic
- **hosts/darwin/default.nix**: macOS system configuration with TouchID, dock, and system defaults
- **hosts/nixos/default.nix**: NixOS configuration with display manager, window manager (bspwm), and services
- **modules/shared/default.nix**: Nixpkgs configuration and overlay imports

### Build Applications

The `apps/` directory contains platform and architecture-specific build scripts:
- Scripts are automatically generated based on system architecture
- Each script handles specific build operations (build, apply, switch, rollback)
- Scripts use color-coded output and proper error handling

### Important Features

- **Flakes**: Uses Nix flakes with inputs for nixpkgs, home-manager, nix-darwin, and disko
- **Home Manager**: User-level package and dotfile management integrated into system config  
- **Overlays**: Automatic overlay loading from `overlays/` directory
- **Homebrew Integration** (macOS): Managed through nix-homebrew with locked taps
- **Disk Management** (NixOS): Uses disko for declarative disk partitioning
- **Cross-platform**: Shared configuration between macOS and NixOS systems

### User Configuration

The default user is "mgrouchy" but the apply script allows customization during initial setup. SSH keys are configured for both user and root accounts on NixOS systems.