{config, pkgs, ...}: {

  services.syncthing = {
    enable = true;
    user = "caleb";
    dataDir = "/home/caleb/sync/";
    configDir = "/home/caleb/.config/syncthing";
    openDefaultPorts = true;
  };

  systemd.services.syncthing.environment.STNODEFAULTFOLDER = "true";

  networking = {
    networkmanager.enable = true;
    firewall = {
      allowedTCPPorts = [ 8384 22000 ];
      allowedUDPPorts = [ 22000 21027 ];
    };
  };
}

