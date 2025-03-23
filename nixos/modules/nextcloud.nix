{ self, config, lib, pkgs, ... }: 

{

  # services.caddy = {
  #   enable = true;
  #   globalconfig = ''
  #     auto_https off
  #     http_port 7080
  #     https_port 7443
  #   '';
  #   virtualHosts."192.168.1.178" = {
  #     extraConfig = ''
  #       reverse_proxy http://127.0.0.1:5432
  #     '';
  #   };
  # };

  # environment.etc."nextcloud-admin-pass".text = "PWD";
  # services.nextcloud = {
  #   enable = true;
  #   hostName = "192.168.1.178";
  #   package = pkgs.nextcloud30;
  #   database.createLocally = true;
  #   configureRedis = true;
  #
  #   maxUploadSize = "16G";
  #   https = true;
  #
  #   autoUpdateApps.enable = true;
  #   extraAppsEnable = true;
  #   extraApps = with config.services.nextcloud.package.packages.apps; {
  #     inherit calendar contacts mail notes onlyoffice tasks;
  #   };
  #
  #   config = {
  #     adminpassFile = "/etc/nextcloud-admin-pass";
  #     dbtype = "sqlite";
  #   };
  # };

  environment.etc."nextcloud-admin-pass".text = "PWD";

  services.nextcloud = {
    enable = true;
    https = true;
    package = pkgs.nextcloud30;
    configureRedis = true;
    hostName = "192.168.1.178";
    # datadir = "/home/caleb/data/nextcloud";
    config.adminpassFile = "/etc/nextcloud-admin-pass";
    config.dbtype = "sqlite";
  };


  services.nginx.virtualHosts.${config.services.nextcloud.hostName} = {
    forceSSL = true;
    sslCertificateKey = "/home/caleb/test/selfsigned.key";
    sslCertificate = "/home/caleb/test/selfsigned.key";
  };

  # security.acme = {
  #   acceptTerms = true;   
  #   certs = { 
  #     ${config.services.nextcloud.hostName}.email = "calebandreano@gmail.com"; 
  #   }; 
  # };


  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
