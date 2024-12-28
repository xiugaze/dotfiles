{ config, pkgs, inputs, unstable, ... }:
let
  unstable = import <nixos-unstable> { config.allowUnfree = true; };
in {

  imports = [
    ../../modules/base.nix 
    ../../modules/neovim.nix 
    ../../modules/hyprland.nix 
    ../../services/web-server-caddy.nix
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.overlays = [ (import ../../overlays/custom-pkgs.nix) ];
  nixpkgs.config.allowUnfree = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "ntfs" ];

  # allow binding directly to 80 and 443
  boot.kernel.sysctl."net.ipv4.ip_unprivileged_port_start" = 0; 

  # networking
  hardware.bluetooth.enable = true;

  # locale
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

  programs.zsh.enable = true;
  users.users.caleb = {
    isNormalUser = true;
    description = "caleb";
    extraGroups = [ "networkmanager" "wheel" "storage" "docker" "disk" ];
    packages = with pkgs; [];
    shell = pkgs.zsh;
  };

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # add missing dynamic libraries
  ];

  xdg.portal = {
      enable = true;
      xdgOpenUsePortal = true;
      extraPortals = [
      	# pkgs.xdg-desktop-portal-hyprland
      	pkgs.xdg-desktop-portal-gtk
      ];
  };

  environment.systemPackages = with pkgs; [
    pipewire
    texlive.combined.scheme-full
    kitty
    zathura
    pavucontrol
    mullvad-vpn
    unstable.obsidian
    unstable.vscodium
    nautilus
    kicad
    stm32cubemx
    unstable.librewolf-bin
    ungoogled-chromium
    jdk21
    python3
    rsync
    nftables

    usbutils
    udiskie
    udisks

    bluez
    blueberry
    nsxiv

    nwg-look
    ffmpeg-full
    x264
    mcrcon
    rpi-imager
    libxkbcommon
    gparted
    psst
    kepubify
    avrdis
  ];

  fonts.packages = with pkgs; [
    fira-code
    fira-code-symbols
    nerdfonts
  ];

  services = {
    udisks2.enable = true;     # automounting 
    gvfs.enable = true;     
    openssh.enable = true;

    xserver = {
      xkb.layout = "us";
      xkb.variant = "";
    };

    mullvad-vpn.enable = true;

    syncthing = {
      enable = true;
      user = "caleb";
      dataDir = "/home/caleb/sync/";
      configDir = "/home/caleb/.config/syncthing";
    };

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      jack.enable = true;
      pulse.enable = true;
      socketActivation = true;
    };
  };

  virtualisation.docker =  {
    enable = true;
  };

  networking = {
    networkmanager.enable = true;
    firewall = {

      allowedTCPPorts = [ 
        8384 22000  # syncthing
        80 443      # http/https
      ];

      allowedUDPPorts = [ 
        22000 21027 # syncthing
        80 443      # http/https
      ];
    };
  };

  system.stateVersion = "24.11"; 
}
