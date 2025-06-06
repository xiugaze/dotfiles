{inputs, config, pkgs, ...}: {

  environment.systemPackages = with pkgs; [
    hyprpaper
    unstable.hyprlock
    hyprshot
    hypridle
    hyprshade
    hyprcursor
    hyprpolkitagent
    unstable.hyprsunset
    catppuccin-cursors
    waybar
    rofi-wayland
    wl-clipboard
    wl-clip-persist
    cliphist

    pipewire
    wireplumber

    dunst
  ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services.xserver.videoDrivers = ["nvidia"];

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    package = pkgs.unstable.hyprland;
  };

  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.production;
    modesetting.enable = true;
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
