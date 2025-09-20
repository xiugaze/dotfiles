{ config, pkgs, inputs, ... }: 
let 
  unstable = import inputs.nixpkgs-unstable {
    system = "x86_64-linux";
    config = config.nixpkgs.config;
  };
  old = import inputs.nixpkgs-old {
    system = "x86_64-linux";
    config = config.nixpkgs.config;
  };

  andreano-dev-pkg = inputs.andreano-dev.packages.${pkgs.system}.default;
in {
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  networking.hostName = "chapterhouse"; # Define your hostname.

  disabledModules = [ "services/web-servers/caddy/default.nix" ];
  imports = [ 
    ./hardware-configuration.nix
    ../../modules/base.nix
    ../../modules/neovim.nix
    ../../modules/syncthing.nix
    ../../services/skrimp_server.nix
    inputs.andreano-dev.nixosModules."x86_64-linux".default
    inputs.sops-nix.nixosModules.sops
    "${inputs.nixpkgs-unstable}/nixos/modules/services/web-servers/caddy/default.nix"
  ];
  _module.args.unstable = unstable;
  nixpkgs.config.allowUnfree = true;

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  networking.networkmanager.enable = true;
  services.st.enable = true;

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  programs.fish.enable = true;
  documentation.man.generateCaches = false;
  users.users.caleb = {
    isNormalUser = true;
    description = "caleb";
    extraGroups = [ "networkmanager" "wheel" "nextcloud" "docker" ];
    packages = with pkgs; [];
    shell = pkgs.fish;
  };

  environment.systemPackages = with pkgs; [
    mcrcon
    jdk
    openssl
    podman
    jellyfin
    jellyfin-web
    jellyfin-ffmpeg
    curlie
    traceroute
    netcat
    andreano-dev-pkg
    sops
  ];

  services.andreano-dev.enable = true;
  services.openssh.enable = true;
  services.skrimp_server = {
    enable = true;
    user = "caleb";
  };


  services.homepage-dashboard = 
    let 
      port = 29100;
    in {
    enable = true;
    listenPort = port;
    widgets = [
      {
        resources = {
            cpu = true;
            disk = "/";
            memory = true;
          };
      }

      {
        search = {
          provider = "custom";
          url =  "https://kagi.com/search?q=";
          target = "_blank";
          suggestionUrl = "https://kagi.com/api/autosuggest?q=";
          showSearchSuggestions = true;
        };
      }
    ];

    services = [
      { 
        "Home" = [
          {
            "Calendar" = {
              href = "https://cloud.andreano.dev/apps/calendar/timeGridWeek/now";
            };
          }
          {
            "Tasks" = {
              href = "https://cloud.andreano.dev/apps/tasks/calendars/caleb-andreano";
            };
          }
        ];
      }
      {
        "Media" = [
          {
            "Immich" = {
              description = "Photos";
              href = "https://immich.andreano.dev";
            };
          }
          {
            "Jellyfin" = {
              description = "Movies/TV";
              href = "https://jellyfin.andreano.dev";
            };
          }
        ];
      }
    ];
  };


  services.actual = {
    enable = true;
    settings = {
      hostname = "0.0.0.0";
      port = 29984;
    };
    openFirewall = true;
  };

  services.jellyfin = {
    enable = true;
    openFirewall = true;
    user = "jellyfin";
  };

  services.audiobookshelf = {
    enable = true;
    host = "0.0.0.0";
    port = 29120;
  };

  services.immich = {
    package = pkgs.immich;
    enable = true;
    port = 2283;
    openFirewall = true;
    mediaLocation = "/mnt/data/immich";
  };

  # # paperless-ngx
  services.paperless = {
    enable = true;
    address = "100.64.0.5";
    dataDir = "/mnt/data/paperless";
    settings = {
      PAPERLESS_OCR_USER_ARGS = {
        "invalidate_digital_signatures" = true;
      };
    };
    port = 29891;
  };

  services.headscale = {
    enable = true;
    address = "0.0.0.0";
    port = 29999;
    settings.dns.base_domain = "andreano.dev";
    settings.server_url = "https://headscale.andreano.dev:443";
  };

  sops.defaultSopsFile = ../../secrets/secrets.yaml;
  sops.defaultSopsFormat = "yaml";
  sops.age.keyFile = "/home/caleb/.config/sops/age/keys.txt";


  # NEXTCLOUD
  sops.secrets."NEXTCLOUD_ADMIN_PASSWORD" = {};
  sops.templates."nextcloud" = {
    content = ''
      ${config.sops.placeholder."NEXTCLOUD_ADMIN_PASSWORD"}
    '';
    owner = "nextcloud";
  };

  environment.etc."nextcloud-admin-pass".text = "testpass123";
  services.nextcloud = {
    enable = true;
    hostName = "nix-nextcloud"; # local only
    package = pkgs.nextcloud31;
    configureRedis = true;
    config.adminpassFile = "${config.sops.templates."nextcloud".path}";
    # config.adminpassFile = "/etc/nextcloud-admin-pass";
    config.adminuser = "root";
    config.dbtype = "sqlite";
    settings.overwriteprotocol = "https";
    settings.trusted_domains = [ "cloud.andreano.dev" ];
    extraApps = {
      inherit (config.services.nextcloud.package.packages.apps) contacts calendar tasks;
    };
    extraAppsEnable = true;
  };
  services.nginx.virtualHosts."nix-nextcloud".listen = [ { addr = "127.0.0.1"; port = 8009; } ]; # nextcloud module runs nginx

  sops.secrets."CLOUDFLARE_API_KEY" = {};
  sops.templates."caddy.env" = {
    content = ''
      CLOUDFLARE_API_KEY="${config.sops.placeholder."CLOUDFLARE_API_KEY"}"
    '';
    owner = "caddy";
  };
  services.caddy = 
    let 
        apex-config = ''
        reverse_proxy :8080
        tls {
          dns cloudflare {env.CLOUDFLARE_API_KEY}
        }
      '';
    in {
      enable = true;
      environmentFile = "${config.sops.templates."caddy.env".path}";
      package = unstable.caddy.withPlugins {
        plugins = [ "github.com/caddy-dns/cloudflare@v0.2.1" ];
        hash = "sha256-j+xUy8OAjEo+bdMOkQ1kVqDnEkzKGTBIbMDVL7YDwDY=";
      };
      globalConfig = ''
        debug
      '';
      virtualHosts."andreano.dev".extraConfig = apex-config;
      virtualHosts."www.andreano.dev".extraConfig = apex-config;
      virtualHosts."jellyfin.andreano.dev".extraConfig = ''
          reverse_proxy :8096
      '';
      virtualHosts."headscale.andreano.dev".extraConfig = ''
          reverse_proxy :29999
      '';

      virtualHosts."budget.andreano.dev".extraConfig = ''
          reverse_proxy :29984
      '';

      virtualHosts."home.andreano.dev".extraConfig = ''
          reverse_proxy :29100
          tls {
            dns cloudflare {env.CLOUDFLARE_API_KEY}
          }
      '';

      # no TLS for paperless, internal only
      virtualHosts."http://paperless.andreano.dev".extraConfig = ''
          reverse_proxy :29891
      '';

      virtualHosts."immich.andreano.dev".extraConfig = ''
          reverse_proxy http://localhost:2283
      '';

      virtualHosts."audiobooks.andreano.dev".extraConfig = ''
          reverse_proxy http://localhost:29120
      '';

      virtualHosts."cloud.andreano.dev" = {
        extraConfig = ''
          redir /.well-known/carddav /remote.php/dav 301
          redir /.well-known/caldav /remote.php/dav 301
          redir /.well-known/webfinger /index.php/.well-known/webfinger 301
          redir /.well-known/nodeinfo /index.php/.well-known/nodeinfo 301

          encode gzip
          reverse_proxy http://localhost:8009
        '';
      };
  };

  services.tailscale.enable = true;
  networking.firewall.trustedInterfaces = [ "enp1s0" "tailscale0" ];
  networking.firewall.allowedTCPPorts = [ 80 443 9090 22000 2283 29891 config.services.tailscale.port ];
  networking.firewall.allowedUDPPorts = [ 80 443 9090 22000 2283 29891 config.services.tailscale.port ];

  virtualisation.podman = {
    enable = true;
  };

  virtualisation.oci-containers = {
    backend = "podman";
    containers = {
    };
  };

  system.stateVersion = "24.11"; # Did you read the comment?

}
