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
  imports = [ 
    ./hardware-configuration.nix
    ../../modules/base.nix
    ../../modules/neovim.nix
    # ../../modules/syncthing.nix
    # ../../modules/nextcloud.nix
    # ../../modules/jellyfin.nix
    ../../services/skrimp_server.nix
    inputs.andreano-dev.nixosModules."x86_64-linux".default
  ];
  _module.args.unstable = unstable;
  nixpkgs.config.allowUnfree = true;

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;


  networking.networkmanager.enable = true;

  time.timeZone = "America/Chicago";

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  users.users.caleb = {
    isNormalUser = true;
    description = "caleb";
    extraGroups = [ "networkmanager" "wheel" "nextcloud" "docker" ];
    packages = with pkgs; [];
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

  services = {

    caddy = {
      enable = true;
      virtualHosts."andreano.dev".extraConfig = ''
        reverse_proxy :8080
      '';
      virtualHosts."test.andreano.dev".extraConfig = ''
        reverse_proxy :8080
      '';
    };

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
