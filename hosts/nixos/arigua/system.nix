{
  pkgs,
  ...
}:

{
  hardware = {
    graphics.enable = true;
    ledger.enable = true;
  };

  virtualisation.docker = {
    enable = true;
    logDriver = "json-file";
  };

  security.sudo = {
    enable = true;
    extraRules = [
      {
        commands = [
          {
            command = "${pkgs.systemd}/bin/reboot";
            options = [ "NOPASSWD" ];
          }
        ];
        groups = [ "wheel" ];
      }
    ];
  };

  fonts.packages = with pkgs; [
    dejavu_fonts
    feather-font
    jetbrains-mono
    font-awesome
    noto-fonts
    noto-fonts-color-emoji
  ];

  environment.systemPackages = with pkgs; [
    gitFull
    inetutils
  ];
}
