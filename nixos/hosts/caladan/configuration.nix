{ config, pkgs, inputs, nixpkgs-unstable, ... }: 
let 
  unstable = import nixpkgs-unstable {
    system = "x86_64-linux";
    config = config.nixpkgs.config;
  };
in {
  networking.hostName = "caladan"; # Define your hostname.

  imports = [ 
      ./hardware-configuration.nix
    ../../modules/base.nix 
    ../../modules/neovim.nix 
    ../../modules/hyprland.nix 
    ../../modules/usb-wakeup-disable.nix 
  ];
  _module.args.unstable = unstable;

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

  hardware.usb.wakeupDisabled = [
    { vendor = "046d"; product = "c547"; } # G502X
    { vendor = "046d"; product = "c52b"; } # Logitech Unifying Receiver
  ];

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
    extraGroups = [ "networkmanager" "wheel" "storage" "docker" "disk" "dialout" ];
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
        pkgs.xdg-desktop-portal-kde
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
    gnome-epub-thumbnailer
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
    arduino-ide
    system-config-printer
    unstable.ghostty
    kdePackages.kdeconnect-kde
  ];

  fonts.packages = with pkgs; [
    fira-code
    fira-code-symbols
    nerdfonts
  ];

  services = {
    # printing
    printing.enable = true;
    # printer discovery
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
    udisks2.enable = true;     # automounting 
    gvfs.enable = true;     
    openssh.enable = true;
    udev.packages = with pkgs; [ 
      platformio-core.udev
    ];
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
      ];
      allowedUDPPorts = [ 
        22000 21027 # syncthing
      ];
    };
  };

  system.stateVersion = "24.11"; 
}
