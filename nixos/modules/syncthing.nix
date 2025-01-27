{config, pkgs, ...}: {
  # environment.systemPackages = with pkgs; [
  #   syncthing
  # ];

  services.syncthing = {
    enable = true;
    user = "caleb";
    dataDir = "/home/caleb/sync/";
    configDir = "/home/caleb/.config/syncthing";
  };

  networking = {
    networkmanager.enable = true;
    firewall = {
      allowedTCPPorts = [ 8384 22000 ];
      allowedUDPPorts = [ 22000 21027 ];
    };
  };
}

