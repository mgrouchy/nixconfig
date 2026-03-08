{
  user,
  ...
}:

{
  services = {
    getty = {
      autologinUser = user;
      autologinOnce = false;
    };
    libinput.enable = true;
    openssh.enable = true;
    syncthing = {
      enable = true;
      openDefaultPorts = true;
      dataDir = "/home/${user}/.local/share/syncthing";
      configDir = "/home/${user}/.config/syncthing";
      inherit user;
      group = "users";
      guiAddress = "127.0.0.1:8384";
      overrideFolders = true;
      overrideDevices = true;
      settings = {
        devices = { };
        options.globalAnnounceEnabled = false;
      };
    };
  };
}
