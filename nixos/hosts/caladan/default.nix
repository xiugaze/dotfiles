{ config, pkgs, lib, inputs, ... }: 
# let 
#   unstable = import inputs.nixpkgs-unstable {
#     system = "x86_64-linux";
#     config = config.nixpkgs.config;
#   };
# in {
{

  networking.hostName = "caladan"; # Define your hostname.

  imports = [ 
    ./hardware-configuration.nix
    ../global/locale.nix
    ../../modules/base.nix 
    ../../modules/syncthing.nix 
    ../../modules/neovim.nix 
    ../../modules/hyprland.nix 
    ../../modules/usb-wakeup-disable.nix 
  ];
  # _module.args.unstable = unstable;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nixpkgs.overlays = [ 
    (import ../../overlays/custom-pkgs.nix) 
  ];

  nixpkgs.config.allowUnfree = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "ntfs" ];
  boot.kernelParams = [ "nvidia.NVreg_PreserveVideoMemoryAllocations=1" ];




  hardware.enableAllFirmware = true;
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  hardware.usb.wakeupDisabled = [
    { vendor = "046d"; product = "c547"; } # G502X
    { vendor = "046d"; product = "c52b"; } # Logitech Unifying Receiver
  ];

  programs.zsh.enable = true;
  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;
  users.users.caleb = {
    isNormalUser = true;
    description = "caleb";
    extraGroups = [ "networkmanager" "wheel" "storage" "docker" "disk" "dialout" "wireshark" ];
    packages = with pkgs; [];
    useDefaultShell = true;
  };

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # add missing dynamic libraries
  ];

  # I think the hyprland module already does all this but...
  xdg.portal = {
      enable = true;
      xdgOpenUsePortal = true;
      extraPortals = [
      ];
  };

  # services.emacs.package = pkgs.emacs-unstable;
  environment.systemPackages = with pkgs; [

    # system
    pipewire
    texlive.combined.scheme-full
    rsync
    nftables
    usbutils
    udiskie # automount usb drives
    udisks
    bluez
    blueberry
    ffmpeg-full
    x264
    libxkbcommon
    pandoc
    
    # development
    python314
    octave
    rust-bin.stable.latest.default 
    jdk21

    # desktop programs
    kitty
    zathura
    inputs.zen-browser.packages."${system}".beta
    pavucontrol
    mullvad-vpn
    nautilus
    gnome-epub-thumbnailer
    unstable.obsidian
    unstable.vscodium
    ungoogled-chromium
    nsxiv
    psst # spotify
    gparted
    exfatprogs
    # ((emacsPackagesFor emacs-unstable).emacsWithPackages (
    #   epkgs: [ epkgs.evil ]
    # ))
    beeper
    gpclient # for MSOE vpn
    libreoffice
    wireshark
    inkscape
    obs-studio
    mpv
    qbittorrent
    adafruit-nrfutil
    unstable.zed-editor

    # other programs
    mcrcon  # talk to minecraft server over network
    nwg-look # gtk settings
    avrdis # avr disassembler (from overlays)
    kepubify
    system-config-printer
    spotify-player
    caligula
    unstable.ergogen

  ];

  nixpkgs.config.packageOverrides = unstable: {
    obsidian = unstable.obsidian.overrideAttrs (old: {
        desktopItem = old.desktopItem.override (old: {
          exec = "obsidian --disable-gpu";
      });
    });
  };

  xdg.mime = {
    enable = true;
    defaultApplications = {
      "text/html" = "zen.desktop";
      "x-scheme-handler/http" = "zen.desktop";
      "x-scheme-handler/https" = "zen.desktop";
      "x-scheme-handler/about" = "zen.desktop";
      "x-scheme-handler/unknown" = "zen.desktop";
      "application/pdf" = "org.pwmt.zathura.desktop";
    };
  };

  documentation.man.generateCaches = false;

  fonts.packages = with pkgs; [
    fira-code
    fira-code-symbols
    nerd-fonts.fira-code
  ];

  services = {
    # printing
    st.enable = true; # syncthing

    displayManager.ly.enable = true;

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
    udev = {
      packages = with pkgs; [ 
        platformio-core.udev

      ];
      # let wireshark read packets
      extraRules = ''
        SUBSYSTEM=="wlp5s0", GROUP="wireshark", MODE="0640"
      '';
    };
    xserver = {
      xkb.layout = "us";
      xkb.variant = "";
    };

    mullvad-vpn.enable = true;
    tailscale = {
      enable = true;
      package = pkgs.unstable.tailscale;
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

  virtualisation.podman =  {
    enable = true;
  };

  networking = {
    networkmanager.enable = true;
    networkmanager.dns = "none";
    useDHCP = false;
    dhcpcd.enable = false;
    nameservers = [
      # "192.168.1.165" # pi hole
      "1.1.1.1"       # cloudflare
    ];
  };

  networking.firewall.allowedTCPPorts = [ 8080 8000 ];
  networking.firewall.allowedUDPPorts = [ 8080 8000 ];

  system.stateVersion = "24.11"; 
}
