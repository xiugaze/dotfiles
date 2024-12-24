
{config, pkgs, lib, ...}: 

{
  services.nginx = {
    enable = true;

    # virtualHosts.locahost = {
    #   listen = [ { addr = "0.0.0.0"; port = 80; } { addr = "0.0.0.0"; port = 443; } ];
    #   root = "/var/www/test-site";
    # };
    virtualHosts."test.andreano.dev" = {
      listen = [ 
        { addr = "0.0.0.0"; port = 80; } 
        { addr = "0.0.0.0"; port = 443; } 
      ];
      addSSL = true;
      enableACME = true;
      root = "/var/www/test-site";
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "calebandreano@gmail.com";
  };
}
