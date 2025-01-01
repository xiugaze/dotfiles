{ config, pkgs, go-test-server, ...}:

{ 
  environment.systemPackages = [ go-test-server.packages.${pkgs.system}.default ];
}
