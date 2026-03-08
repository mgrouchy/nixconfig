{
  host,
  user,
  ...
}:

{
  time.timeZone = "America/New_York";

  networking = {
    inherit (host) hostName;
    useDHCP = false;
    interfaces.${host.primaryInterface}.useDHCP = true;
  };

  nix = {
    nixPath = [ "nixos-config=/home/${user}/.local/share/src/nixos-config:/etc/nixos" ];
    settings = {
      allowed-users = [ user ];
      trusted-users = [
        "@admin"
        user
      ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };
}
