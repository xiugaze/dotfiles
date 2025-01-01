{config, pkgs, lib, ...}: 

{
  services.caddy = {
    enable = true;
    # virtualHosts."test.andreano.dev".extraConfig = ''
    #   respond "This is working"
    # '';
    virtualHosts."test.andreano.dev".extraConfig = ''
      reverse_proxy localhost:8080
    '';
  };
  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
