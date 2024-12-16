{ config, pkgs, inputs, ... }:
let
  unstable = import <nixos-unstable> { config.allowUnfree = true; };
in {
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "ntfs" ];
  boot.kernel.sysctl."net.ipv4.ip_unprivileged_port_start" = 0; 

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
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

  services.xserver = {
    xkb.layout = "us";
    xkb.variant = "";
  };

  hardware.bluetooth.enable = true;

  users.users.caleb = {
    isNormalUser = true;
    description = "caleb";
    extraGroups = [ "networkmanager" "wheel" "storage" "docker" "disk" ];
    packages = with pkgs; [];
    shell = pkgs.zsh;
  };

  home-manager.users.caleb = { config, pkgs, ...}: {
    nixpkgs.config.allowUnfree = true;
    home.username = "caleb";
    home.homeDirectory = "/home/caleb";
    home.packages = [];
    home.stateVersion = "24.05";
    home.pointerCursor = {
      gtk.enable = true;
      name = "Posy_Cursor_Black";
      package = pkgs.posy-cursors;
      size = 24;
    };
  };


  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableLsColors = true;
  };

  nixpkgs.config.allowUnfree = true;

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

  imports = [
    <home-manager/nixos>
    ./pkgs-base.nix
    ./pkgs-wayland-hyprland.nix
    ./pkgs-neovim.nix 
  ];

  environment.systemPackages = with pkgs; [
    pipewire
    texlive.combined.scheme-full

    # utilites
    bitwarden-cli

    # desktop programs
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
    firefox

    # development
    jdk21
    python3

    rsync

    nftables
    tree

    usbutils
    udiskie
    udisks

    bluez
    blueberry
    nsxiv

    posy-cursors
    nwg-look
    ffmpeg-full
    x264
    mcrcon
    rpi-imager
    libxkbcommon
    gparted
  ];

  fonts.packages = with pkgs; [
    fira-code
    fira-code-symbols
    nerdfonts
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Services
  services = {
    udisks2.enable = true;     # automounting 
    gvfs.enable = true;     
    openssh.enable = true;

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
    firewall = {

      allowedTCPPorts = [ 
        8384 22000  # syncthing
        80 443      # http/https
      ];

      allowedUDPPorts = [ 
        22000 21027 # syncthing
      ];
    };
  };

  # don't change this
  system.stateVersion = "24.05"; 
}
