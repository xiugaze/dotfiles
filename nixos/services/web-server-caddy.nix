{config, pkgs, lib, ...}: 

{
  services.caddy = {
    enable = true;
    virtualHosts."test.andreano.dev".extraConfig = ''
      reverse_proxy localhost:9999
    '';
  };
  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
