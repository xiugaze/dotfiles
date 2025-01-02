{ config, pkgs, love-letters, ...}:

let 
  port = "55569";
in { 
  environment.systemPackages = [ love-letters.packages.${pkgs.system}.default ];

  systemd.services.love-letters= {
    description = "Love letters";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];

    environment = {
      STATIC_FILES_PATH = "${love-letters.packages.${pkgs.system}.default}/share/love-letters/static";
      MEDIA_FILES_PATH = "/var/lib/love-letters/media";
      PORT = "${port}";
    };

    serviceConfig = {
      ExecStart = "${love-letters.packages.${pkgs.system}.default}/bin/love-letters";
      Restart = "always";
      Type = "simple";

      StateDirectory = "love-letters";
      User = "love-letters";
      Group = "love-letters";

      ExecStartPre = [
        "${pkgs.coreutils}/bin/mkdir -p /var/lib/love-letters/media"
      ];

      ReadOnlyPaths = [ "${love-letters.packages.${pkgs.system}.default}/share/love-letters/static" ];
      ReadWritePaths = [ "/var/lib/love-letters" ];

      # security
      ProtectSystem = "off";
      ProtectHome = false;
      NoNewPrivileges = false;
    };
  };

  services.caddy = {
    enable = true;
    virtualHosts."test.andreano.dev".extraConfig = ''
      reverse_proxy localhost:${port}
    '';
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];
  users.extraUsers.love-letters = {
    isSystemUser = true;
    group = "love-letters";
    description = "love-letters web service runner";
  };
  users.extraGroups.love-letters = {};
}
