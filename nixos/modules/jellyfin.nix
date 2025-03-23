{ self, config, lib, pkgs, ... }: 

{
  environment.systemPackages = with pkgs; [
    jellyfin
    jellyfin-web
    jellyfin-ffmpeg
  ];
  services.jellyfin = {
    enable = true;
    openFirewall = true;
    user = "caleb";
    # dataDir = "/home/caleb/jellyfin/data";
  };
}
