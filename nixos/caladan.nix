{ config, pkgs, inputs, ... }:
let
  unstable = import <nixos-unstable> { config.allowUnfree = true; };
in {
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "ntfs" ];
  boot.kernel.sysctl."net.ipv4.ip_unprivileged_port_start" = 0; 

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
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

  # Configure keymap in X11
  services.xserver = {
    xkb.layout = "us";
    xkb.variant = "";
  };

  services.flatpak.enable = true;
  hardware.bluetooth.enable = true;

  users.users.caleb = {
    isNormalUser = true;
    description = "caleb";
    extraGroups = [ "networkmanager" "wheel" "storage" ];
    packages = with pkgs; [];
    shell = pkgs.zsh;
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableLsColors = true;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # add missing dynamic libraries
  ];

  xdg.portal = {
      enable = true;
      wlr.enable = true;
  };


  imports = [
    ./pkgs-base.nix
    ./pkgs-wayland-hyprland.nix
    ./pkgs-neovim.nix 
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    xdg-desktop-portal
    fzf
    starship
    # desktop environment
    pipewire
    # clipboard
    # programs
    kitty
    tmux
    python3
    bitwarden
    bitwarden-cli
    librewolf
    firefox
    #lf
    pavucontrol
    imagemagick
    luajitPackages.magick
    # pkgs.pkgsCross has all the cross compilers, we're cross-compiling for AVR
    texlive.combined.scheme-full
    zathura

    # networking
    mullvad-vpn
    unstable.obsidian

    # hardware stuff
    kicad
    stm32cubemx

    gnome.nautilus

    prismlauncher
    jdk21

    unstable.zed-editor
    rsync
    xdg-desktop-portal-kde

    nftables
    tree

    usbutils
    udiskie
    udisks

    bluez
    blueberry
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

  services.openssh.enable = true;
  services.mullvad-vpn.enable = true;
  services.udisks2.enable = true;     # automounting 
  services.gvfs.enable = true;     

  services.syncthing = {
    enable = true;
    user = "caleb";
    dataDir = "/home/caleb/sync/";
    configDir = "/home/caleb/.config/syncthing";
  };

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    jack.enable = true;
    pulse.enable = true;
    socketActivation = true;
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
