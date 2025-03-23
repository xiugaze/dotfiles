{config, pkgs, lib, ...}: 

{
  services.caddy = {
    enable = true;
    virtualHosts."192.168.1.178".extraConfig = ''
      respond "Hello world!"
    '';
  };
  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
