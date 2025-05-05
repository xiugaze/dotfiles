{ config, pkgs, inputs, ... }: 
let 
  unstable = import inputs.nixpkgs-unstable {
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
    # ../../modules/nextcloud.nix
    # ../../modules/jellyfin.nix
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

  services.jellyfin = {
    enable = true;
    openFirewall = true;
    user = "caleb";
  };

  sops.defaultSopsFile = ../../secrets/secrets.yaml;
  sops.defaultSopsFormat = "yaml";
  sops.age.keyFile = "/home/caleb/.config/sops/age/keys.txt";

  sops.secrets."CLOUDFLARE_API_KEY" = { };
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
    in

    {
    enable = true;
    environmentFile = "${config.sops.templates."caddy.env".path}";
    package = unstable.caddy.withPlugins {
      plugins = [ "github.com/caddy-dns/cloudflare@v0.1.0" ];
      hash = "sha256-KnXqw7asSfAvKNSIRap9HfSvnijG07NYI3Yfknblcl4=";
    };
    virtualHosts."andreano.dev".extraConfig = apex-config;
    virtualHosts."www.andreano.dev".extraConfig = apex-config;
    virtualHosts."jellyfin.local".extraConfig = ''
        reverse_proxy :8096
        tls internal
    '';
  };

  networking.firewall.allowedTCPPorts = [ 80 443 9090 22000];
  networking.firewall.allowedUDPPorts = [ 80 443 9090 22000];

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
