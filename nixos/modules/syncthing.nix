{config, pkgs, lib, ...}: 
let 
  cfg = config.services.st;
in with lib;
{

  options.services.st = {
    enable = mkEnableOption "caleb's syncthing";
    user = mkOption {
      default = "caleb";
      description = "User to run Syncthing as";
    };
    dataDir = mkOption {
      default = "/home/caleb/sync/";
      description = "Directory for Syncthing data";
    };
    configDir = mkOption {
      default = "/home/caleb/.config/syncthing";
      description = "Directory for Syncthing configuration";
    };
  };

  config = mkIf cfg.enable {
    services.syncthing = {
      enable = true;
      user = cfg.user;
      dataDir = cfg.dataDir;
      configDir = cfg.configDir;
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
  };
}

