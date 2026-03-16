{
  pkgs,
  lib ? pkgs.lib,
}:

with pkgs;
rec {
  cli = [
    aspell
    aspellDicts.en
    bash-completion
    bat
    coreutils
    fd
    fzf
    hunspell
    jq
    killall
    ncdu
    openssh
    ripgrep
    rtk
    sqlite
    tree
    unrar
    unzip
    wget
    yq
    zip
  ];

  observability = [
    bandwhich
    btop
    dust
    fastfetch
    htop
    iftop
    procs
    vhs
  ];

  vcs = [
    delta
    gh
    git-absorb
    lazygit
  ];

  security = [
    age
    gnupg
    libfido2
  ];

  cloud = [
    awscli2
    rclone
  ];

  dev = [
    ast-grep
    difftastic
    go
    lazydocker
    mkcert
    nodejs_24
    ruff
    ty
    uv
  ];

  lsp = [
    clang-tools
    gopls
    intelephense
    jdt-language-server
    kotlin-language-server
    lua-language-server
    pyright
    rust-analyzer
    sourcekit-lsp
    typescript
    typescript-language-server
  ]
  ++ lib.optionals (!pkgs.stdenv.hostPlatform.isDarwin) [
    csharp-ls
  ];

  nixTools = [
    nil
    nix-index
    nixfmt
  ];

  fonts = [
    font-awesome
    hack-font
    meslo-lgs-nf
    noto-fonts
    noto-fonts-color-emoji
  ];

  shared = cli ++ observability ++ vcs ++ security ++ cloud ++ dev ++ lsp ++ nixTools ++ fonts;

  darwin = [
    _1password-cli
    caddy
    chatgpt
    code-cursor
    dockutil
  ];

  nixosBuild = [
    appimage-run
    cmake
    direnv
    gnumake
    home-manager
    libtool
    postgresql
  ];

  nixosDesktop = [
    bc
    feh
    flameshot
    font-manager
    fontconfig
    galculator
    google-chrome
    i3lock-fancy-rapid
    inotify-tools
    libnotify
    pavucontrol
    pcmanfm
    screenkey
    spotify
    unixtools.ifconfig
    unixtools.netstat
    vlc
    xrandr
    xclip
    xdg-utils
    xdotool
    xwininfo
    yad
    zathura
  ];

  nixosSecurity = [
    keepassxc
    yubikey-agent
  ];

  nixos = nixosBuild ++ nixosDesktop ++ nixosSecurity;
}
