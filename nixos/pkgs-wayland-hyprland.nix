{config, pkgs, ...}: 
let
  unstable = import <nixos-unstable> { config.allowUnfree = true; };
in {
  environment.systemPackages = with pkgs; [
    # xdg-desktop-portal-hyprland
    # xdg-desktop-portal-gnome
    hyprpaper
    hyprlock
    hyprshot
    hypridle
    hyprcursor
    hyprpolkitagent
    catppuccin-cursors
    waybar
    rofi-wayland
    wl-clipboard
    wl-clip-persist
    cliphist
  ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };



  services.xserver.videoDrivers = ["nvidia"];

  programs.hyprland = {
    enable = true;
    #enableNvidiaPatches = true;
    xwayland.enable = true;
  };

  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.production;
    modesetting.enable = true;
    # powerManagement.enable = false;
    # powerManagement.finegrained = false;
    powerManagement.enable = true;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
  };


  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
  };

}
