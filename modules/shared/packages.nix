{ pkgs }:

with pkgs; [
  # General packages for development and system management
  aspell
  aspellDicts.en
  bash-completion
  bat
  btop
  coreutils
  killall
  fastfetch
  openssh
  sqlite
  wget
  zip
  neovim
  zellij
  fzf
  fd
  rclone
  ncdu

  #github
  gh
  lazygit

  # Encryption and security tools
  age
  gnupg
  libfido2

  # Cloud-related tools and SDKs
  # we are installing these via brew, as there is no docker desktop in nix
  # and sometimes its just easier to use docker desktop to do some things. 
  #docker
  #docker-compose

  # Media-related packages (fonts)
  font-awesome
  hack-font
  noto-fonts
  noto-fonts-emoji
  meslo-lgs-nf
  vhs

  # Node.js development tools
  nodejs_24
  go

  # Text and terminal utilities
  htop
  hunspell
  iftop
  jq
  yq
  ripgrep
  tree
  unrar
  unzip
  #zsh-powerlevel10k
  difftastic
  ast-grep
  git-absorb
  delta
  nix-index
  dust
  procs
  bandwhich
  

  # Python packages
  uv
  ruff
  ty

  # agentic coding tools (moved to ai-tools.nix via nix-ai-tools flake)
]
