{
  pkgs,
  user,
  ...
}:

let
  sshKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOk8iAnIaa1deoc7jw8YACPNVka1ZFJxhnU4G74TmS+p"
  ];
in
{
  users.users = {
    ${user} = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "docker"
      ];
      shell = pkgs.zsh;
      openssh.authorizedKeys.keys = sshKeys;
    };

    root.openssh.authorizedKeys.keys = sshKeys;
  };
}
